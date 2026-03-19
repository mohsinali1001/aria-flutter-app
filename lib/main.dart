import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'auth/auth_providers.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AriaColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const ProviderScope(child: AriaApp()));
}

class AriaApp extends ConsumerWidget {
  const AriaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start Firebase → Drift sync listener
    ref.watch(firebaseSyncProvider);

    // Use Drift authProvider as single source of truth
    final authState = ref.watch(authProvider);

    // Loading state
    if (authState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AriaTheme.light,
        home: const SplashScreen(),
      );
    }

    return MaterialApp(
      title: 'ARIA — AI Personal Secretary',
      debugShowCheckedModeBanner: false,
      theme: AriaTheme.light,
      home: authState.isAuthenticated
          ? const HomeScreen()
          : const _AuthEntry(),
    );
  }
}

// Decides between onboarding and login
class _AuthEntry extends ConsumerWidget {
  const _AuthEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sharedPreferencesProvider);

    return prefsAsync.when(
      loading: () => const SplashScreen(),
      error: (_, __) => const LoginScreen(),
      data: (prefs) {
        final onboardingDone = prefs.getBool('ui.onboardingDone') ?? false;
        if (!onboardingDone) {
          return OnboardingScreen(
            onFinished: () async {
              await prefs.setBool('ui.onboardingDone', true);
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}