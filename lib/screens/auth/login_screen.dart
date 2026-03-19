import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'signup_screen.dart';
import '../../auth/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final credential = await ref.read(authServiceProvider).signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      // Manually sync Firebase user to Drift DB
      final fbUser = credential.user;
      if (fbUser != null) {
        await ref.read(authProvider.notifier).syncFromFirebase(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          name: fbUser.displayName ??
              fbUser.email?.split('@').first ??
              'User',
        );
      }

      _showSuccess('Welcome back!');
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });
    try {
      final credential = await ref.read(authServiceProvider).signInWithGoogle();

      // Manually sync Firebase user to Drift DB
      final fbUser = credential?.user;
      if (fbUser != null) {
        await ref.read(authProvider.notifier).syncFromFirebase(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          name: fbUser.displayName ??
              fbUser.email?.split('@').first ??
              'User',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: AriaColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AriaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Header
              Text(
                'ARIA',
                style: TextStyle(
                  color: AriaColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome back',
                style: AriaText.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: AriaText.bodyMedium,
              ),

              const SizedBox(height: 48),

              // Email field
              _buildLabel('Email'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AriaText.bodyLarge.copyWith(
                  color: AriaColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: AriaColors.textHint,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AriaText.bodyLarge.copyWith(
                  color: AriaColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AriaColors.textHint,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AriaColors.textHint,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AriaColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Error message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AriaColors.errorBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AriaColors.errorBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: AriaColors.error, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: AriaColors.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Sign In button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailLogin,
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Sign In'),
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  Expanded(
                      child: Divider(color: AriaColors.divider, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or',
                        style: TextStyle(
                            color: AriaColors.textHint, fontSize: 13)),
                  ),
                  Expanded(
                      child: Divider(color: AriaColors.divider, thickness: 1)),
                ],
              ),

              const SizedBox(height: 20),

              // Google Sign In button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: _isGoogleLoading ? null : _handleGoogleLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AriaColors.textPrimary,
                    side: BorderSide(color: AriaColors.divider, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rad.lg),
                    ),
                  ),
                  child: _isGoogleLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AriaColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.google.com/favicon.ico',
                        width: 20,
                        height: 20,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.g_mobiledata,
                          color: AriaColors.google,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: AriaColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                        color: AriaColors.textSecondary, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SignupScreen()),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: AriaColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: TextStyle(
      color: AriaColors.textSecondary,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  );
}