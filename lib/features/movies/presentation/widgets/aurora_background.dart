import 'package:flutter/material.dart';

/// Мягкий пастельный фон в духе iOS: размытые цветовые пятна из темы.
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _AuroraBlob(
            alignment: const Alignment(-1, -1),
            color: colors.primary,
          ),
          _AuroraBlob(
            alignment: const Alignment(1.1, -0.3),
            color: colors.tertiary,
          ),
          _AuroraBlob(
            alignment: const Alignment(-0.7, 1.1),
            color: colors.secondary,
          ),
        ],
      ),
    );
  }
}

/// Одно размытое пятно фона.
class _AuroraBlob extends StatelessWidget {
  const _AuroraBlob({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: 0.95,
        heightFactor: 0.62,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                color.withValues(alpha: 0.38),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
