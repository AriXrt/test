import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'poster_placeholder.dart';

/// Постер фильма: реальная картинка с CDN Кинопоиска поверх офлайн-основы.
///
/// Основа всегда под низом, поэтому белых прямоугольников не бывает:
/// пока идёт загрузка — спиннер, при ошибке — красивый градиентный постер.
class MoviePoster extends StatelessWidget {
  const MoviePoster({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        PosterPlaceholder(movie: movie),
        Semantics(
          image: true,
          label: 'Постер фильма «${movie.title}»',
          child: Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? progress,
            ) {
              if (progress == null) return child;
              return _PosterLoading(progress: progress);
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) =>
                    const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

/// Индикатор загрузки постера: спиннер и проценты поверх мягкой подложки.
class _PosterLoading extends StatelessWidget {
  const _PosterLoading({this.progress});

  final ImageChunkEvent? progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int? totalBytes = progress?.expectedTotalBytes;
    final double? value = totalBytes == null || totalBytes == 0
        ? null
        : (progress?.cumulativeBytesLoaded ?? 0) / totalBytes;

    return ColoredBox(
      color: theme.colorScheme.surface.withValues(alpha: 0.55),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 4,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text('Загружаем постер…', style: theme.textTheme.labelLarge),
            if (value != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                '${(value * 100).round()}%',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
