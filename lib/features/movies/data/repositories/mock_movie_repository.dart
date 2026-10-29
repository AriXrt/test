import 'dart:developer' as developer;

import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/mock_movies_data.dart';

/// Моковый источник подборки: 35 культовых фильмов Кинопоиска.
class MockMovieRepository implements MovieRepository {
  MockMovieRepository({this.latency = const Duration(milliseconds: 600)});

  /// Искусственная задержка, имитирующая сетевой запрос.
  final Duration latency;

  final List<Movie> _likedMovies = <Movie>[];

  /// Фильмы, которые пользователь лайкнул за время работы приложения.
  List<Movie> get likedMovies => List<Movie>.unmodifiable(_likedMovies);

  @override
  Future<List<Movie>> fetchMovies() async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
    developer.log(
      'Загружено фильмов: ${mockMovies.length}',
      name: 'MockMovieRepository',
    );
    return mockMovies;
  }

  @override
  Future<List<Movie>> fetchLikedMovies() async =>
      List<Movie>.unmodifiable(_likedMovies);

  @override
  Future<void> saveSwipe({
    required Movie movie,
    required SwipeDirection direction,
  }) async {
    if (direction.isLike) {
      _likedMovies.add(movie);
    }
    developer.log(
      '${direction.isLike ? 'Лайк' : 'Дизлайк'}: «${movie.title}»',
      name: 'MockMovieRepository',
    );
  }

  @override
  Future<void> clearHistory() async {
    _likedMovies.clear();
    developer.log('История свайпов очищена', name: 'MockMovieRepository');
  }
}
