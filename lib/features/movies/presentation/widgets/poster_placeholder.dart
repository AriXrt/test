import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'poster_style.dart';

/// Офлайн-основа постера: градиент, иконка и подпись из [Movie.id].
///
/// Служит подложкой под сетевую картинку и полностью заменяет её,
/// если постер не загрузился.
class PosterPlaceholder extends StatelessWidget {
  const PosterPlaceholder({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PosterStyle style = PosterStyle.forMovie(movie);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.lerp(
              theme.colorScheme.primaryContainer,
              style.accent,
              0.35,
            )!,
            theme.colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -48,
            right: -32,
            child: _GlowCircle(size: 180, color: style.accent),
          ),
          Positioned(
            bottom: -64,
            left: -40,
            child: _GlowCircle(size: 220, color: style.accent),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(style.icon, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  style.genre,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Полупрозрачный декоративный круг для «глубины» градиента.
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}
