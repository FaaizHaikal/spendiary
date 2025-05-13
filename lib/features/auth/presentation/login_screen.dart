import 'package:flutter/material.dart';
import 'package:spendiary/features/auth/logic/auth_controller.dart';
import 'package:spendiary/features/auth/presentation/widgets/auth_button.dart';
import 'package:spendiary/features/auth/presentation/widgets/input_field.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/features/dashboard/presentation/dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Username and password cannot be empty.";
      });

      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthController.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      setState(() {
        _errorMessage = error;
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(label: 'Username', controller: _usernameController),
            const SizedBox(height: 12),
            InputField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null)
              Align(
                alignment: Alignment.centerLeft, // Aligns the text to the left
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.redAccent),
                ),
              ),
            const SizedBox(height: 24),
            AuthButton(
              text: 'Login',
              onPressed: _handleLogin,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                SizedBox(width: 4),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith(
                      (_) => Colors.transparent,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: WidgetStateProperty.all(Size.zero),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
