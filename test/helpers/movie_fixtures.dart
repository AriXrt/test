import 'package:test_project/features/movies/domain/entities/movie.dart';

/// Фильм №1 для тестов.
const Movie testMovieInception = Movie(
  id: 1,
  title: 'Начало',
  overview: 'Кража идей из снов.',
  posterUrl: 'https://example.com/1.jpg',
  rating: 8.4,
  releaseYear: 2010,
  kinopoiskUrl: 'https://www.kinopoisk.ru/film/1/',
);

/// Фильм №2 для тестов.
const Movie testMovieDarkKnight = Movie(
  id: 2,
  title: 'Тёмный рыцарь',
  overview: 'Джокер и Готэм.',
  posterUrl: 'https://example.com/2.jpg',
  rating: 8.5,
  releaseYear: 2008,
  kinopoiskUrl: 'https://www.kinopoisk.ru/film/2/',
);

/// Фильм №3 для тестов.
const Movie testMovieInterstellar = Movie(
  id: 3,
  title: 'Интерстеллар',
  overview: 'Поиск нового дома для человечества.',
  posterUrl: 'https://example.com/3.jpg',
  rating: 8.4,
  releaseYear: 2014,
  kinopoiskUrl: 'https://www.kinopoisk.ru/film/3/',
);
