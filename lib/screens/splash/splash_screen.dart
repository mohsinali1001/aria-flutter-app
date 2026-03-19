// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, a, __) => FadeTransition(
          opacity: CurvedAnimation(parent: a, curve: Curves.easeInOut),
          child: const AuthGate(),
        ),
      ));
    });
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AriaColors.splashGradient),
        child: Stack(children: [
          // Decorative circles
          Positioned(top: -size.height * 0.12, right: -80,
              child: _Circle(size.width * 0.75, 0.12)),
          Positioned(bottom: -size.height * 0.14, left: -60,
              child: _Circle(size.width * 0.85, 0.1)),
          Positioned(top: size.height * 0.42, left: -50,
              child: _Circle(160, 0.07)),
          Positioned(bottom: size.height * 0.22, right: -30,
              child: _Circle(110, 0.08)),
          Positioned(top: size.height * 0.18, left: size.width * 0.6,
              child: _Circle(70, 0.06)),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing logo
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) => Container(
                      width:  120 + _pulse.value * 6,
                      height: 120 + _pulse.value * 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2 + _pulse.value * 0.12),
                            width: 1.5),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 40 + _pulse.value * 10,
                            offset: const Offset(0, 14))],
                      ),
                      child: child,
                    ),
                    child: const Center(
                      child: Text('A', style: TextStyle(
                          fontSize: 66, fontWeight: FontWeight.w900,
                          color: Colors.white, letterSpacing: -3)),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 300), duration: const Duration(milliseconds: 600))
                      .scale(begin: const Offset(0.4, 0.4),
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut),

                  const SizedBox(height: 32),

                  const Text('ARIA', style: TextStyle(
                      fontSize: 46, fontWeight: FontWeight.w900,
                      color: Colors.white, letterSpacing: 12))
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 800), duration: const Duration(milliseconds: 500))
                      .slideY(begin: 0.5,
                      delay: const Duration(milliseconds: 800),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic),

                  const SizedBox(height: 10),

                  Text('AI Personal Secretary', style: TextStyle(
                      fontSize: 16, color: Colors.white.withOpacity(0.75),
                      letterSpacing: 2.5, fontWeight: FontWeight.w400))
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 1100), duration: const Duration(milliseconds: 500)),

                  SizedBox(height: size.height * 0.1),

                  // Animated dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) =>
                        Container(
                          width: 9, height: 9,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              shape: BoxShape.circle),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .fadeIn(delay: Duration(milliseconds: 1400 + i * 180))
                            .then()
                            .scale(begin: const Offset(1,1), end: const Offset(1.6,1.6),
                            duration: const Duration(milliseconds: 600), curve: Curves.easeInOut)
                            .then()
                            .scale(begin: const Offset(1.6,1.6), end: const Offset(1,1),
                            duration: const Duration(milliseconds: 600)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom text
          Positioned(
            bottom: 32, left: 0, right: 0,
            child: Text('Powered by Groq AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12, letterSpacing: 1))
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 2000)),
          ),
        ]),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size, opacity;
  const _Circle(this.size, this.opacity);
  @override Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity)),
  );
}