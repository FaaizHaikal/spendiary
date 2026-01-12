import 'package:dio/dio.dart';
import 'package:spendiary/core/contants.dart';
import 'package:spendiary/core/services/storage_service.dart';
import 'package:spendiary/features/auth/services/auth_service.dart';

class DioClient {
  static final Dio dio = Dio(
      BaseOptions(
        baseUrl: '$baseUrl',
        headers: {'Content-Type': 'application/json'},
        validateStatus:
            (status) => 
        status != null && (status >= 200 && status < 300 || status == 401),
      ),
    )
    // ..interceptors.add(LogInterceptor(responseBody: true))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await StorageService.getAccessToken();

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final requestPath = error.requestOptions.path;

          print(requestPath);

          if (requestPath == '/api/refresh') {
            return handler.next(error);
          }

          if (error.response?.statusCode == 401) {
            final successRefresh = await AuthService.refreshAccessToken();

            if (successRefresh) {
              final newAccessToken = await StorageService.getAccessToken();
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              final retry = await dio.fetch(error.requestOptions);
              return handler.resolve(retry);
            } else {
              await StorageService.clearTokens();
            }
          }

          return handler.next(error);
        },
      ),
    );
}
