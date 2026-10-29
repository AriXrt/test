import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';

/// Репозиторий фильмов с локальной историей свайпов в Hive.
///
/// Подборка берётся из [source] (пока моки), а уже оценённые фильмы
/// отфильтровываются, чтобы не показываться повторно после перезапуска.
class HiveMovieRepository implements MovieRepository {
  HiveMovieRepository({
    required MovieRepository movieRepository,
    required MovieLocalDataSource localDataSource,
  }) : _source = movieRepository,
       _local = localDataSource;

  final MovieRepository _source;
  final MovieLocalDataSource _local;

  @override
  Future<List<Movie>> fetchMovies() async {
    final List<Movie> movies = await _source.fetchMovies();
    final Set<int> swipedIds = await _local.swipedMovieIds();

    if (swipedIds.isEmpty) return movies;

    return movies
        .where((Movie movie) => !swipedIds.contains(movie.id))
        .toList(growable: false);
  }

  @override
  Future<void> saveSwipe({
    required Movie movie,
    required SwipeDirection direction,
  }) {
    return _local.saveSwipe(movie: movie, direction: direction);
  }

  @override
  Future<List<Movie>> fetchLikedMovies() => _local.likedMovies();

  @override
  Future<void> clearHistory() => _local.clearHistory();
}
