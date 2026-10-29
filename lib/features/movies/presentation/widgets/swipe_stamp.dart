import 'package:flutter/material.dart';

/// Штамп «ЛАЙК» / «ДИЗЛАЙК», проявляющийся на карточке во время свайпа.
class SwipeStamp extends StatelessWidget {
  const SwipeStamp({
    required this.label,
    required this.color,
    required this.opacity,
    required this.alignment,
    super.key,
  });

  final String label;
  final Color color;

  /// Прозрачность штампа: 0 — скрыт, 1 — полностью виден.
  final double opacity;

  /// Угол крепления штампа на карточке.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLeft = alignment == Alignment.topLeft;

    return IgnorePointer(
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0).toDouble(),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Transform.rotate(
              angle: isLeft ? -0.35 : 0.35,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.85),
                  border: Border.all(color: color, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
