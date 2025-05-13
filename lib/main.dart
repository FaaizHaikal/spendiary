import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/core/theme/app_theme.dart';
import 'features/auth/presentation/splash_screen.dart';

void main() {
  runApp(ProviderScope(child: const SpendiaryApp()));
}

class SpendiaryApp extends StatelessWidget {
  const SpendiaryApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendiary',
      theme: AppTheme.appTheme,
      home: const SplashScreen(),
    );
  }
}
