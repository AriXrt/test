import '../entities/movie.dart';
import '../entities/swipe_direction.dart';

/// Контракт доступа к фильмам. Реализация живёт в data-слое.
abstract interface class MovieRepository {
  /// Загружает подборку фильмов для свайпов.
  ///
  /// Бросает исключение, если данные получить не удалось.
  Future<List<Movie>> fetchMovies();

  /// Сохраняет результат свайпа (лайк или дизлайк) в локальное хранилище.
  Future<void> saveSwipe({
    required Movie movie,
    required SwipeDirection direction,
  });

  /// Возвращает фильмы, которые пользователь лайкнул.
  Future<List<Movie>> fetchLikedMovies();

  /// Полностью очищает историю свайпов и лайки.
  Future<void> clearHistory();
}
