import 'package:flutter/material.dart';
import 'package:spendiary/features/auth/applications/auth_controller.dart';
import 'package:spendiary/features/auth/presentations/widgets/auth_button.dart';
import 'package:spendiary/features/auth/presentations/widgets/input_field.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/features/auth/presentations/widgets/password_requirement.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isPasswordLengthValid = false;
  bool _isPasswordHasNumber = false;
  bool _isConfirmPasswordValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _isPasswordLengthValid = password.length >= 8;
      _isPasswordHasNumber = RegExp(r'\d').hasMatch(password);

      _isConfirmPasswordValid =
          (_isPasswordLengthValid &&
              _isPasswordHasNumber &&
              password == confirmPassword);
    });
  }

  Future<void> _handleRegister() async {
    if (!_isPasswordLengthValid ||
        !_isPasswordHasNumber ||
        !_isConfirmPasswordValid) {
      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthController.register(
      _usernameController.text,
      _passwordController.text,
    );

    if (error == null) {
      // TODO: Add snackbar register successful

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
        padding: const EdgeInsets.all(16.0),
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
            InputField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            PasswordRequirement(
              requirement: 'At least 8 characters',
              isValid: _isPasswordLengthValid,
            ),
            PasswordRequirement(
              requirement: 'Contains a number',
              isValid: _isPasswordHasNumber,
            ),
            PasswordRequirement(
              requirement: 'Passwords match',
              isValid: _isConfirmPasswordValid,
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
              text: 'Register',
              onPressed: _handleRegister,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                SizedBox(width: 4),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                    'Login',
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
