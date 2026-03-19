import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinished; // ← add this

  const OnboardingScreen({super.key, this.onFinished}); // ← add this

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.auto_awesome,
      title: 'Meet ARIA',
      subtitle:
      'Your AI personal secretary. One conversation handles your entire professional life.',
    ),
    _OnboardingData(
      icon: Icons.mail_outline_rounded,
      title: 'Email, handled',
      subtitle:
      'ARIA reads your inbox, surfaces what matters, and drafts replies in your tone.',
    ),
    _OnboardingData(
      icon: Icons.calendar_today_outlined,
      title: 'Your day, summarised',
      subtitle:
      'Ask ARIA anything about your schedule. Get a full day brief every morning.',
    ),
    _OnboardingData(
      icon: Icons.notifications_none_rounded,
      title: 'Never forget again',
      subtitle:
      'Set reminders naturally. Just tell ARIA and it handles the rest.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    if (widget.onFinished != null) {
      widget.onFinished!();
      // Navigate to login after callback
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AriaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: AriaColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AriaColors.primarySurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AriaColors.primaryBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: 44,
                            color: AriaColors.primary,
                          ),
                        ),

                        const SizedBox(height: 48),

                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AriaText.displaySmall,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: AriaText.bodyLarge.copyWith(
                            color: AriaColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AriaColors.primary
                        : AriaColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 48),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}