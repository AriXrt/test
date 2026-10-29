import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// Матовое стекло в стиле Apple Liquid Glass.
///
/// Размывает фон, добавляет полупрозрачную заливку и тонкую светлую рамку.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    required this.child,
    this.padding,
    this.radius = AppTheme.glassRadius,
    this.blurSigma = AppTheme.blurSigma,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: AppTheme.glassFillOpacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: colors.onSurface.withValues(
                alpha: AppTheme.glassBorderOpacity,
              ),
              width: AppTheme.glassBorderWidth,
            ),
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}
