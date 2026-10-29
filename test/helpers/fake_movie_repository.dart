import 'package:test_project/features/movies/domain/entities/movie.dart';
import 'package:test_project/features/movies/domain/entities/swipe_direction.dart';
import 'package:test_project/features/movies/domain/repositories/movie_repository.dart';

/// Репозиторий-заглушка с настраиваемыми ответами и ошибками.
class FakeMovieRepository implements MovieRepository {
  FakeMovieRepository({
    this.movies = const <Movie>[],
    this.likedMovies = const <Movie>[],
    this.fetchError,
    this.likedError,
    this.saveError,
    this.clearError,
  });

  final List<Movie> movies;
  final List<Movie> likedMovies;

  /// Если задано — соответствующий метод бросает это исключение.
  final Object? fetchError;
  final Object? likedError;
  final Object? saveError;
  final Object? clearError;

  /// Сохранённые свайпы: фильм и направление.
  final List<Movie> savedMovies = <Movie>[];
  final List<SwipeDirection> savedDirections = <SwipeDirection>[];

  /// Сколько раз вызывалась очистка истории.
  int clearHistoryCalls = 0;

  @override
  Future<List<Movie>> fetchMovies() async {
    final Object? error = fetchError;
    if (error != null) throw error;
    return movies;
  }

  @override
  Future<List<Movie>> fetchLikedMovies() async {
    final Object? error = likedError;
    if (error != null) throw error;
    return likedMovies;
  }

  @override
  Future<void> saveSwipe({
    required Movie movie,
    required SwipeDirection direction,
  }) async {
    final Object? error = saveError;
    if (error != null) throw error;

    savedMovies.add(movie);
    savedDirections.add(direction);
  }

  @override
  Future<void> clearHistory() async {
    clearHistoryCalls++;

    final Object? error = clearError;
    if (error != null) throw error;
  }
}
