import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'glass_container.dart';
import 'kinopoisk_button.dart';

/// Панель с названием, рейтингом, описанием и счётчиком карточек.
class MovieInfoPanel extends StatelessWidget {
  const MovieInfoPanel({
    required this.movie,
    required this.remaining,
    super.key,
  });

  final Movie movie;

  /// Сколько фильмов осталось после текущей карточки.
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Icon(
                Icons.star_rounded,
                size: 18,
                color: theme.colorScheme.tertiary,
                semanticLabel: 'Рейтинг',
              ),
              const SizedBox(width: 4),
              Text(
                '${movie.rating.toStringAsFixed(1)} / 10',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
              Text('•', style: theme.textTheme.bodyMedium),
              const SizedBox(width: 8),
              Text(
                '${movie.releaseYear}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            movie.overview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Осталось карточек: $remaining',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              KinopoiskButton(url: movie.kinopoiskUrl),
            ],
          ),
        ],
      ),
    );
  }
}
