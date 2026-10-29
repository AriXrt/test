import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';

/// Состояния фичи movies.
sealed class MovieState {
  const MovieState();
}

/// Идёт загрузка подборки фильмов.
final class MovieLoading extends MovieState {
  const MovieLoading();
}

/// Есть карточка, которую можно свайпнуть.
final class MovieLoaded extends MovieState {
  const MovieLoaded({
    required this.movie,
    required this.remaining,
    this.lastDirection,
  });

  /// Текущая карточка фильма.
  final Movie movie;

  /// Сколько фильмов осталось после текущей карточки.
  final int remaining;

  /// Направление последнего свайпа, `null` для первой карточки.
  final SwipeDirection? lastDirection;

  /// `true`, если предыдущая карточка была лайкнута.
  bool get isLike => lastDirection?.isLike ?? false;
}

/// Фильмы закончились.
final class MovieEmpty extends MovieState {
  const MovieEmpty();
}

/// Произошла ошибка при загрузке или сохранении свайпа.
final class MovieFailure extends MovieState {
  const MovieFailure({required this.message});

  /// Сообщение для показа пользователю.
  final String message;
}
