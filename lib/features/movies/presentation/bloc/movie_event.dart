import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';

/// События фичи movies.
sealed class MovieEvent {
  const MovieEvent();
}

/// Запросить загрузку подборки фильмов.
final class FetchMovies extends MovieEvent {
  const FetchMovies();
}

/// Сбросить историю свайпов и заново загрузить подборку.
final class ResetMovieHistory extends MovieEvent {
  const ResetMovieHistory();
}

/// Пользователь свайпнул (лайк/дизлайк) текущую карточку.
final class MovieSwiped extends MovieEvent {
  const MovieSwiped({required this.movie, required this.direction});

  /// Фильм, по которому был совершён свайп.
  final Movie movie;

  /// Направление свайпа.
  final SwipeDirection direction;
}
