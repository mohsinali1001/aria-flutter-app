import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../theme/app_theme.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _loginEmail = TextEditingController();
  final _loginPass = TextEditingController();

  final _regName = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPass = TextEditingController();

  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _loginEmail.dispose();
    _loginPass.dispose();
    _regName.dispose();
    _regEmail.dispose();
    _regPass.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? AriaColors.error : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.md)),
      ),
    );
  }

  bool _isValidEmail(String e) => e.contains('@') && e.contains('.');

  void _switchToLoginWithMessage() {
    _tab.animateTo(0);
    _regPass.clear();
    _snack('Account created. Please login.');
  }

  Future<void> _doLogin() async {
    final email = _loginEmail.text.trim();
    final pass = _loginPass.text;
    if (!_isValidEmail(email) || pass.length < 6) {
      _snack('Enter valid email + password (min 6)', error: true);
      return;
    }
    setState(() => _busy = true);
    final ok = await ref.read(authProvider.notifier).login(email: email, password: pass);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) _snack('Login failed. Check email/password.', error: true);
  }

  Future<void> _doRegister() async {
    final name = _regName.text.trim();
    final email = _regEmail.text.trim();
    final pass = _regPass.text;
    if (name.length < 2 || !_isValidEmail(email) || pass.length < 6) {
      _snack('Enter name, valid email + password (min 6)', error: true);
      return;
    }
    setState(() => _busy = true);
    final ok = await ref
        .read(authProvider.notifier)
        .register(name: name, email: email, password: pass);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      _snack('Email already registered.', error: true);
      return;
    }
    _switchToLoginWithMessage();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final disabled = _busy || auth.isLoading;
    final h = MediaQuery.sizeOf(context).height;
    final cardHeight = h < 700 ? 360.0 : 420.0;

    return Scaffold(
      backgroundColor: AriaColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AriaLogo(size: 38),
                      const SizedBox(width: 10),
                      Text(
                        'ARIA',
                        style: AriaText.headlineMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15),
                  const SizedBox(height: 10),
                  Text(
                    'Register then login to access your assistant',
                    textAlign: TextAlign.center,
                    style: AriaText.bodySmall.copyWith(color: AriaColors.textHint),
                  ).animate().fadeIn(delay: 120.ms),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      color: AriaColors.surface,
                      borderRadius: BorderRadius.circular(Rad.xl),
                      border: Border.all(color: AriaColors.divider),
                      boxShadow: AriaShadow.subtle,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AriaColors.inputFill,
                              borderRadius: BorderRadius.circular(Rad.lg),
                              border: Border.all(color: AriaColors.divider),
                            ),
                            child: TabBar(
                              controller: _tab,
                              indicator: BoxDecoration(
                                gradient: AriaColors.primaryGradient,
                                borderRadius: BorderRadius.circular(Rad.lg),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: AriaColors.textHint,
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: 'Login'),
                                Tab(text: 'Register'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: cardHeight,
                          child: TabBarView(
                            controller: _tab,
                            children: [
                              _LoginPane(
                                emailCtrl: _loginEmail,
                                passCtrl: _loginPass,
                                disabled: disabled,
                                onSubmit: _doLogin,
                              ),
                              _RegisterPane(
                                nameCtrl: _regName,
                                emailCtrl: _regEmail,
                                passCtrl: _regPass,
                                disabled: disabled,
                                onSubmit: _doRegister,
                              ),
                            ],
                          ),
                        ),
                        if (auth.error != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              auth.error!,
                              style: AriaText.bodySmall.copyWith(color: AriaColors.error),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 160.ms),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Fields marked with * are required',
                      textAlign: TextAlign.center,
                      style: AriaText.bodySmall.copyWith(color: AriaColors.textHint),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginPane extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool disabled;
  final VoidCallback onSubmit;

  const _LoginPane({
    required this.emailCtrl,
    required this.passCtrl,
    required this.disabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Field(
              label: 'Email *',
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              enabled: !disabled,
            ),
            const SizedBox(height: 12),
            _Field(
              label: 'Password *',
              controller: passCtrl,
              obscure: true,
              enabled: !disabled,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: disabled ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rad.lg),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: disabled ? null : AriaColors.primaryGradient,
                    color: disabled ? AriaColors.divider : null,
                    borderRadius: BorderRadius.circular(Rad.lg),
                  ),
                  child: Center(
                    child: disabled
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : Text('Login',
                            style: AriaText.button.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _RegisterPane extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool disabled;
  final VoidCallback onSubmit;

  const _RegisterPane({
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.disabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Field(
              label: 'Full name *',
              controller: nameCtrl,
              enabled: !disabled,
            ),
            const SizedBox(height: 12),
            _Field(
              label: 'Email *',
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              enabled: !disabled,
            ),
            const SizedBox(height: 12),
            _Field(
              label: 'Password * (min 6)',
              controller: passCtrl,
              obscure: true,
              enabled: !disabled,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: disabled ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rad.lg),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: disabled ? null : AriaColors.primaryGradient,
                    color: disabled ? AriaColors.divider : null,
                    borderRadius: BorderRadius.circular(Rad.lg),
                  ),
                  child: Center(
                    child: disabled
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : Text('Create account',
                            style: AriaText.button.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final bool enabled;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        enabled: enabled,
        style: AriaText.bodyMedium.copyWith(color: AriaColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AriaColors.inputFill,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Rad.lg),
            borderSide: const BorderSide(color: AriaColors.divider),
          ),
        ),
      );
}

