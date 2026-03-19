// ═══════════════════════════════════════════════════════════════════════
//  lib/theme/app_theme.dart
//  ARIA Complete Design System
//  PDF Colors: Sage Green #5B8A7B | Soft Teal #2E8B9E | Off-White #FAFAFA
// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────
//  COLOR SYSTEM
// ─────────────────────────────────────────────────────────────────────────
class AriaColors {
  AriaColors._();

  // ── Core palette — PDF exact ─────────────────────────────────────────
  static const primary         = Color(0xFF5B8A7B); // Sage Green
  static const secondary       = Color(0xFF2E8B9E); // Soft Teal
  static const ariaMessage     = Color(0xFFE8F4F8); // Light Blue (ARIA bubbles)
  static const background      = Color(0xFFFAFAFA); // Off-White
  static const surface         = Color(0xFFFFFFFF); // White

  // ── Extended palette ─────────────────────────────────────────────────
  static const primaryLight    = Color(0xFF8BB5A9);
  static const primaryDark     = Color(0xFF3D6B5F);
  static const primarySurface  = Color(0xFFF0F7F5);
  static const primaryBorder   = Color(0xFFD0E6E0);
  static const secondaryLight  = Color(0xFF5BAFC2);
  static const secondarySurface= Color(0xFFEBF6FA);
  static const secondaryBorder = Color(0xFFB8DEE8);

  // ── Text ─────────────────────────────────────────────────────────────
  static const textPrimary     = Color(0xFF1A2F2B);
  static const textSecondary   = Color(0xFF4A6560);
  static const textHint        = Color(0xFF8FA9A4);
  static const textOnDark      = Color(0xFFFFFFFF);

  // ── UI Elements ──────────────────────────────────────────────────────
  static const divider         = Color(0xFFE2EDEB);
  static const inputFill       = Color(0xFFF2F8F7);
  static const cardBorder      = Color(0xFFE8F0EE);
  static const shimmer         = Color(0xFFE8F0EE);

  // ── Semantic ─────────────────────────────────────────────────────────
  static const error           = Color(0xFFD32F2F);
  static const errorBg         = Color(0xFFFDECEC);
  static const errorBorder     = Color(0xFFFFCDD2);
  static const success         = Color(0xFF2E7D32);
  static const successBg       = Color(0xFFEBF5EB);
  static const successBorder   = Color(0xFFC8E6C9);
  static const warning         = Color(0xFFF57C00);
  static const warningBg       = Color(0xFFFFF3E0);
  static const warningBorder   = Color(0xFFFFE0B2);
  static const info            = Color(0xFF1565C0);
  static const infoBg          = Color(0xFFE3F2FD);

  // ── Priority ─────────────────────────────────────────────────────────
  static const urgent          = Color(0xFFD32F2F);
  static const urgentBg        = Color(0xFFFDECEC);
  static const high            = Color(0xFFF57C00);
  static const highBg          = Color(0xFFFFF3E0);

  // ── Gradient ─────────────────────────────────────────────────────────
  static const gradientStart   = Color(0xFF5B8A7B);
  static const gradientEnd     = Color(0xFF2E8B9E);
  static const gradientMid     = Color(0xFF4A8F8A);

  // ── Google ───────────────────────────────────────────────────────────
  static const google          = Color(0xFF4285F4);

  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [gradientStart, gradientMid, gradientEnd],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static LinearGradient get splashGradient => const LinearGradient(
    colors: [Color(0xFF4A7A6B), Color(0xFF5B8A7B), Color(0xFF2E8B9E)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  TYPOGRAPHY
// ─────────────────────────────────────────────────────────────────────────
class AriaText {
  AriaText._();

  static const displayLarge = TextStyle(
    fontSize: 36, fontWeight: FontWeight.w800,
    color: AriaColors.textPrimary, letterSpacing: -1.2, height: 1.15,
  );
  static const displayMedium = TextStyle(
    fontSize: 30, fontWeight: FontWeight.w800,
    color: AriaColors.textPrimary, letterSpacing: -0.8, height: 1.18,
  );
  static const displaySmall = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AriaColors.textPrimary, letterSpacing: -0.4, height: 1.22,
  );
  static const headlineLarge = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AriaColors.textPrimary, letterSpacing: -0.3, height: 1.25,
  );
  static const headlineMedium = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700,
    color: AriaColors.textPrimary, height: 1.3,
  );
  static const headlineSmall = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AriaColors.textPrimary, height: 1.35,
  );
  static const titleLarge = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AriaColors.textPrimary, height: 1.4,
  );
  static const titleMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AriaColors.textPrimary, height: 1.4,
  );
  static const titleSmall = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AriaColors.textPrimary, height: 1.4,
  );
  static const bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AriaColors.textPrimary, height: 1.65,
  );
  static const bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AriaColors.textSecondary, height: 1.6,
  );
  static const bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AriaColors.textHint, height: 1.5,
  );
  static const labelLarge = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AriaColors.textPrimary, letterSpacing: 0.1,
  );
  static const labelMedium = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AriaColors.textSecondary, letterSpacing: 0.3,
  );
  static const labelSmall = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: AriaColors.textHint, letterSpacing: 0.4,
  );
  static const button = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );
  static const buttonSmall = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static const caption = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w400,
    color: AriaColors.textHint, letterSpacing: 0.3,
  );
  static const overline = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w600,
    color: AriaColors.textHint, letterSpacing: 1.5,
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  SPACING
// ─────────────────────────────────────────────────────────────────────────
class Sp {
  Sp._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 16;
  static const double lg   = 24;
  static const double xl   = 32;
  static const double xxl  = 48;
  static const double xxxl = 64;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets listPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
}

// ─────────────────────────────────────────────────────────────────────────
//  BORDER RADIUS
// ─────────────────────────────────────────────────────────────────────────
class Rad {
  Rad._();
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double xxl  = 28;
  static const double xxxl = 36;
  static const double full = 999;
}

// ─────────────────────────────────────────────────────────────────────────
//  SHADOWS
// ─────────────────────────────────────────────────────────────────────────
class AriaShadow {
  AriaShadow._();

  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF5B8A7B).withOpacity(0.08),
      blurRadius: 16, offset: const Offset(0, 4), spreadRadius: -2,
    ),
  ];
  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 24, offset: const Offset(0, 8), spreadRadius: -4,
    ),
  ];
  static List<BoxShadow> get subtle => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8, offset: const Offset(0, 2),
    ),
  ];
  static List<BoxShadow> get button => [
    BoxShadow(
      color: AriaColors.primary.withOpacity(0.35),
      blurRadius: 20, offset: const Offset(0, 8), spreadRadius: -4,
    ),
  ];
  static List<BoxShadow> get fab => [
    BoxShadow(
      color: AriaColors.primary.withOpacity(0.4),
      blurRadius: 24, offset: const Offset(0, 10), spreadRadius: -4,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────
//  ARIA THEME
// ─────────────────────────────────────────────────────────────────────────
class AriaTheme {
  AriaTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness:           Brightness.light,
      primary:              AriaColors.primary,
      onPrimary:            Colors.white,
      primaryContainer:     AriaColors.primarySurface,
      onPrimaryContainer:   AriaColors.primaryDark,
      secondary:            AriaColors.secondary,
      onSecondary:          Colors.white,
      secondaryContainer:   AriaColors.secondarySurface,
      onSecondaryContainer: AriaColors.secondary,
      surface:              AriaColors.surface,
      onSurface:            AriaColors.textPrimary,
      error:                AriaColors.error,
      onError:              Colors.white,
      errorContainer:       AriaColors.errorBg,
      onErrorContainer:     AriaColors.error,
      outline:              AriaColors.divider,
      outlineVariant:       AriaColors.cardBorder,
    ),
    scaffoldBackgroundColor: AriaColors.background,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AriaColors.background,
      foregroundColor: AriaColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AriaColors.background,
      ),
      titleTextStyle: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w700,
        color: AriaColors.textPrimary,
      ),
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AriaColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AriaColors.divider,
        disabledForegroundColor: AriaColors.textHint,
        elevation: 0, shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        minimumSize: const Size(double.infinity, 58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.lg)),
        textStyle: AriaText.button,
      ),
    ),

    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AriaColors.primary,
        side: const BorderSide(color: AriaColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        minimumSize: const Size(double.infinity, 58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.lg)),
        textStyle: AriaText.button.copyWith(color: AriaColors.primary),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AriaColors.primary,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: AriaColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rad.xl),
        side: const BorderSide(color: AriaColors.divider, width: 1),
      ),
    ),

    // InputDecoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AriaColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rad.lg),
        borderSide: const BorderSide(color: AriaColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rad.lg),
        borderSide: const BorderSide(color: AriaColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rad.lg),
        borderSide: const BorderSide(color: AriaColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rad.lg),
        borderSide: const BorderSide(color: AriaColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rad.lg),
        borderSide: const BorderSide(color: AriaColors.error, width: 2),
      ),
      hintStyle: AriaText.bodyMedium.copyWith(color: AriaColors.textHint),
      labelStyle: const TextStyle(color: AriaColors.textSecondary, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: AriaColors.primary, fontWeight: FontWeight.w600),
      prefixIconColor: AriaColors.textHint,
      suffixIconColor: AriaColors.textHint,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AriaColors.primarySurface,
      selectedColor: AriaColors.primary,
      labelStyle: AriaText.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.full)),
      side: const BorderSide(color: AriaColors.divider),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
        color: AriaColors.divider, thickness: 1, space: 0),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AriaColors.textPrimary,
      contentTextStyle: AriaText.bodyMedium.copyWith(color: Colors.white),
      actionTextColor: AriaColors.primaryLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.lg)),
    ),

    // BottomSheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AriaColors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Rad.xxl))),
      elevation: 0,
    ),

    // ListTile
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      iconColor: AriaColors.textSecondary,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? AriaColors.primary : Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
              ? AriaColors.primary.withOpacity(0.5) : AriaColors.divider),
    ),

    // FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AriaColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  REUSABLE UI COMPONENTS
// ─────────────────────────────────────────────────────────────────────────

/// ARIA Logo Widget
class AriaLogo extends StatelessWidget {
  final double size;
  final bool white;
  const AriaLogo({super.key, this.size = 40, this.white = false});

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: white ? Colors.white.withOpacity(0.2) : AriaColors.primary,
      borderRadius: BorderRadius.circular(size * 0.28),
      boxShadow: white ? null : AriaShadow.button,
    ),
    child: Center(
      child: Text('A', style: TextStyle(
        color: white ? Colors.white : Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: size * 0.55,
        letterSpacing: -1,
      )),
    ),
  );
}

/// Status Badge
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? bgColor;
  final double? fontSize;
  const StatusBadge(this.label, {super.key, required this.color, this.bgColor, this.fontSize});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bgColor ?? color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(Rad.full),
    ),
    child: Text(label, style: TextStyle(
      fontSize: fontSize ?? 11, fontWeight: FontWeight.w700,
      color: color, letterSpacing: 0.3,
    )),
  );
}

/// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12, left: 2),
    child: Row(children: [
      Expanded(child: Text(title.toUpperCase(), style: AriaText.overline.copyWith(
          color: AriaColors.textHint, fontWeight: FontWeight.w700, letterSpacing: 1.5))),
      if (trailing != null) trailing!,
    ]),
  );
}

/// Settings Card wrapper
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AriaColors.surface,
      borderRadius: BorderRadius.circular(Rad.xl),
      border: Border.all(color: AriaColors.divider),
      boxShadow: AriaShadow.subtle,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(Rad.xl),
      child: Column(children: children),
    ),
  );
}

/// Shimmer loading effect
class ShimmerBox extends StatefulWidget {
  final double width, height, radius;
  const ShimmerBox({super.key, required this.width, required this.height, this.radius = 8});
  @override State<ShimmerBox> createState() => _ShimmerBoxState();
}
class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _a = Tween<double>(begin: 0.3, end: 0.8).animate(_c);
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: _a,
    builder: (_, __) => Container(
      width: widget.width, height: widget.height,
      decoration: BoxDecoration(
        color: AriaColors.shimmer.withOpacity(_a.value),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    ),
  );
}
