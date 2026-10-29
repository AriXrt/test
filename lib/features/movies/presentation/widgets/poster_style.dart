import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

/// Детерминированный визуальный стиль офлайн-постера.
///
/// Один и тот же фильм всегда получает одинаковые цвет, иконку и подпись,
/// а разные фильмы — разные, поэтому карточки визуально отличаются.
class PosterStyle {
  const PosterStyle({
    required this.accent,
    required this.icon,
    required this.genre,
  });

  /// Акцентный цвет, подмешиваемый к цветам темы.
  final Color accent;

  /// Иконка по центру постера.
  final IconData icon;

  /// Короткая подпись под иконкой (жанр-заглушка).
  final String genre;

  static const List<IconData> _icons = <IconData>[
    Icons.theaters_outlined,
    Icons.movie_filter,
    Icons.videocam_outlined,
    Icons.local_movies_outlined,
    Icons.movie_creation_outlined,
    Icons.slow_motion_video_outlined,
  ];

  static const List<String> _genres = <String>[
    'ФАНТАСТИКА',
    'ТРИЛЛЕР',
    'ДРАМА',
    'БОЕВИК',
    'ДЕТЕКТИВ',
    'ПРИКЛЮЧЕНИЯ',
  ];

  /// Стиль, вычисленный из идентификатора фильма.
  factory PosterStyle.forMovie(Movie movie) {
    final int seed = movie.id.abs();

    return PosterStyle(
      accent: HSLColor.fromAHSL(1, (seed * 47) % 360, 0.62, 0.58).toColor(),
      icon: _icons[seed % _icons.length],
      genre: _genres[(seed ~/ 3) % _genres.length],
    );
  }
}
