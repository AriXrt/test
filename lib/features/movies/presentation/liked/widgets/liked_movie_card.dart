import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../domain/entities/movie.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/kinopoisk_button.dart';
import '../../widgets/movie_poster.dart';

/// Карточка фильма в сетке «Избранного».
class LikedMovieCard extends StatelessWidget {
  const LikedMovieCard({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GlassContainer(
      radius: AppTheme.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: MoviePoster(movie: movie)),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 6, 6),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: theme.colorScheme.tertiary,
                            semanticLabel: 'Рейтинг',
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              '${movie.rating.toStringAsFixed(1)} • ${movie.releaseYear}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                KinopoiskButton(url: movie.kinopoiskUrl, showLabel: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
