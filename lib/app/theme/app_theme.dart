import 'package:flutter/material.dart';

/// Дизайн-система MovieMood в стиле Apple Liquid Glass.
abstract final class AppTheme {
  static const Color _seedColor = Color(0xFF5B6CFF);

  /// Полностью прозрачный цвет (экраны поверх собственного фона).
  static const Color transparent = Color(0x00000000);

  /// Радиус скругления карточки фильма.
  static const double cardRadius = 28;

  /// Радиус стеклянных поверхностей.
  static const double glassRadius = 24;

  /// Радиус парящего навигационного острова.
  static const double navRadius = 32;

  /// Сила размытия стекла в BackdropFilter.
  static const double blurSigma = 20;

  /// Толщина стеклянной рамки.
  static const double glassBorderWidth = 0.5;

  /// Прозрачность стеклянной рамки.
  static const double glassBorderOpacity = 0.2;

  /// Прозрачность заливки стекла.
  static const double glassFillOpacity = 0.18;

  /// Отступ снизу, чтобы контент не прятался под островом навигации.
  static const double navBarInset = 104;

  /// Максимальная ширина карточки на планшетах и десктопе.
  static const double cardMaxWidth = 420;

  /// Стандартный отступ контента экрана.
  static const EdgeInsets screenPadding = EdgeInsets.all(20);

  /// Светлая тема приложения.
  static ThemeData get light {
    final ColorScheme colors = ColorScheme.fromSeed(seedColor: _seedColor);

    return ThemeData(
      colorScheme: colors,
      scaffoldBackgroundColor: transparent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: transparent,
        surfaceTintColor: transparent,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: colors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(
            color: colors.onSurface.withValues(alpha: glassBorderOpacity),
            width: glassBorderWidth,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
