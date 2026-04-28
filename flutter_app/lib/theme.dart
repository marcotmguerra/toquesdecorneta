import 'package:flutter/material.dart';

const _accent      = Color(0xFF3B5BFF);
const _accentDark  = Color(0xFF6B80FF);

ThemeData lightTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _accent,
    brightness: Brightness.light,
    primary: _accent,
    surface: const Color(0xFFFFFFFF),
  ),
  scaffoldBackgroundColor: const Color(0xFFF2F2F7),
  cardColor: Colors.white,
  fontFamily: 'Inter',
  textTheme: _textTheme(const Color(0xFF111111), const Color(0xFF555555)),
  elevatedButtonTheme: _btnTheme(_accent),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    foregroundColor: Color(0xFF111111),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _accent,
    unselectedItemColor: Color(0xFFAAAAAA),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  extensions: const [AppColors.light],
);

ThemeData darkTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _accentDark,
    brightness: Brightness.dark,
    primary: _accentDark,
    surface: const Color(0xFF1E1E21),
  ),
  scaffoldBackgroundColor: const Color(0xFF121214),
  cardColor: const Color(0xFF1E1E21),
  fontFamily: 'Inter',
  textTheme: _textTheme(const Color(0xFFF0F0F3), const Color(0xFF9A9A9F)),
  elevatedButtonTheme: _btnTheme(_accentDark),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E21),
    foregroundColor: Color(0xFFF0F0F3),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E21),
    selectedItemColor: _accentDark,
    unselectedItemColor: Color(0xFF56565B),
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  extensions: const [AppColors.dark],
);

TextTheme _textTheme(Color primary, Color secondary) => TextTheme(
  headlineMedium: TextStyle(color: primary,   fontWeight: FontWeight.w700, fontSize: 20),
  titleLarge:     TextStyle(color: primary,   fontWeight: FontWeight.w700, fontSize: 18),
  titleMedium:    TextStyle(color: primary,   fontWeight: FontWeight.w600, fontSize: 16),
  bodyMedium:     TextStyle(color: secondary, fontSize: 14),
  bodySmall:      TextStyle(color: secondary, fontSize: 12),
);

ElevatedButtonThemeData _btnTheme(Color color) => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: color,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    elevation: 0,
  ),
);

// ── Extension for custom colors ───────────────────────────────────────────────

class AppColors extends ThemeExtension<AppColors> {
  final Color accent;
  final Color accentBg;
  final Color surface;
  final Color text1;
  final Color text2;
  final Color text3;
  final Color border;
  final Color badgeAprendendo;
  final Color badgeBom;
  final Color badgeDominado;

  const AppColors({
    required this.accent,
    required this.accentBg,
    required this.surface,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.border,
    required this.badgeAprendendo,
    required this.badgeBom,
    required this.badgeDominado,
  });

  static const light = AppColors(
    accent:           Color(0xFF3B5BFF),
    accentBg:         Color(0xFFE9EDFF),
    surface:          Color(0xFFFFFFFF),
    text1:            Color(0xFF111111),
    text2:            Color(0xFF555555),
    text3:            Color(0xFFAAAAAA),
    border:           Color(0xFFE0E0E0),
    badgeAprendendo:  Color(0xFF3B5BFF),
    badgeBom:         Color(0xFFF5A623),
    badgeDominado:    Color(0xFF27AE60),
  );

  static const dark = AppColors(
    accent:           Color(0xFF6B80FF),
    accentBg:         Color(0xFF1A1E40),
    surface:          Color(0xFF1E1E21),
    text1:            Color(0xFFF0F0F3),
    text2:            Color(0xFF9A9A9F),
    text3:            Color(0xFF56565B),
    border:           Color(0xFF38383C),
    badgeAprendendo:  Color(0xFF6B80FF),
    badgeBom:         Color(0xFFD4A017),
    badgeDominado:    Color(0xFF2ECC71),
  );

  @override
  AppColors copyWith({
    Color? accent, Color? accentBg, Color? surface,
    Color? text1, Color? text2, Color? text3, Color? border,
    Color? badgeAprendendo, Color? badgeBom, Color? badgeDominado,
  }) => AppColors(
    accent:           accent           ?? this.accent,
    accentBg:         accentBg         ?? this.accentBg,
    surface:          surface          ?? this.surface,
    text1:            text1            ?? this.text1,
    text2:            text2            ?? this.text2,
    text3:            text3            ?? this.text3,
    border:           border           ?? this.border,
    badgeAprendendo:  badgeAprendendo  ?? this.badgeAprendendo,
    badgeBom:         badgeBom         ?? this.badgeBom,
    badgeDominado:    badgeDominado    ?? this.badgeDominado,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      accent:           Color.lerp(accent,           other.accent,           t)!,
      accentBg:         Color.lerp(accentBg,         other.accentBg,         t)!,
      surface:          Color.lerp(surface,           other.surface,          t)!,
      text1:            Color.lerp(text1,             other.text1,            t)!,
      text2:            Color.lerp(text2,             other.text2,            t)!,
      text3:            Color.lerp(text3,             other.text3,            t)!,
      border:           Color.lerp(border,            other.border,           t)!,
      badgeAprendendo:  Color.lerp(badgeAprendendo,   other.badgeAprendendo,  t)!,
      badgeBom:         Color.lerp(badgeBom,          other.badgeBom,         t)!,
      badgeDominado:    Color.lerp(badgeDominado,     other.badgeDominado,    t)!,
    );
  }
}

extension ThemeX on BuildContext {
  AppColors get ac => Theme.of(this).extension<AppColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
