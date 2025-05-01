import 'package:dio/dio.dart';
import 'package:spendiary/core/contants.dart';
import 'package:spendiary/core/services/storage_service.dart';
import 'package:spendiary/features/auth/data/auth_service.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl',
      headers: {'Content-Type': 'application/json'}
    )
  ) ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await StorageService.getAccessToken();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        final successRefresh = await AuthService.refreshAccessToken();

        if (successRefresh) {
          final newAccessToken = await StorageService.getAccessToken();
          error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retry = await dio.fetch(error.requestOptions);
          return handler.resolve(retry);
        }
      }

      return handler.next(error);
    },
  ));
}