/// Доменная сущность фильма. Не зависит от Flutter и источников данных.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    required this.releaseYear,
    required this.kinopoiskUrl,
  });

  /// Уникальный идентификатор фильма (TMDB id).
  final int id;

  /// Название фильма.
  final String title;

  /// Краткое описание сюжета.
  final String overview;

  /// Ссылка на постер.
  final String posterUrl;

  /// Рейтинг по десятибалльной шкале.
  final double rating;

  /// Год выхода фильма.
  final int releaseYear;

  /// Ссылка на страницу фильма на Кинопоиске.
  final String kinopoiskUrl;

  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterUrl,
    double? rating,
    int? releaseYear,
    String? kinopoiskUrl,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterUrl: posterUrl ?? this.posterUrl,
      rating: rating ?? this.rating,
      releaseYear: releaseYear ?? this.releaseYear,
      kinopoiskUrl: kinopoiskUrl ?? this.kinopoiskUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.overview == overview &&
        other.posterUrl == posterUrl &&
        other.rating == rating &&
        other.releaseYear == releaseYear &&
        other.kinopoiskUrl == kinopoiskUrl;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    overview,
    posterUrl,
    rating,
    releaseYear,
    kinopoiskUrl,
  );

  @override
  String toString() => 'Movie(id: $id, title: $title, releaseYear: $releaseYear)';
}
