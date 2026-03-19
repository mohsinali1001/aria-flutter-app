import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../theme/app_theme.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';
import 'auth_screen.dart';

const _prefsOnboardingDoneKey = 'ui.onboardingDone';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sharedPreferencesProvider);

    return prefsAsync.when(
      loading: () => const _FullScreenLoading(),
      error: (e, _) => _FullScreenError(message: e.toString()),
      data: (prefs) {
        final auth = ref.watch(authProvider);
        if (auth.isLoading) return const _FullScreenLoading();
        if (!auth.isAuthenticated) return const AuthScreen();

        final onboardingDone = prefs.getBool(_prefsOnboardingDoneKey) ?? false;
        if (!onboardingDone) {
          return OnboardingScreen(
            onFinished: () async {
              await prefs.setBool(_prefsOnboardingDoneKey, true);
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }
            },
          );
        }

        return const HomeScreen();
      },
    );
  }
}

class _FullScreenLoading extends StatelessWidget {
  const _FullScreenLoading();

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AriaColors.background,
        body: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
        ),
      );
}

class _FullScreenError extends StatelessWidget {
  final String message;
  const _FullScreenError({required this.message});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AriaColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Startup failed:\n$message',
              textAlign: TextAlign.center,
              style: AriaText.bodyMedium.copyWith(color: AriaColors.error),
            ),
          ),
        ),
      );
}

