import '../../domain/entities/movie.dart';

/// Состояния вкладки «Избранное».
sealed class LikedState {
  const LikedState();
}

/// Идёт загрузка лайкнутых фильмов.
final class LikedLoading extends LikedState {
  const LikedLoading();
}

/// Есть сохранённые лайки.
final class LikedLoaded extends LikedState {
  const LikedLoaded({required this.movies});

  final List<Movie> movies;
}

/// Лайкнутых фильмов пока нет.
final class LikedEmpty extends LikedState {
  const LikedEmpty();
}

/// Не удалось прочитать избранное.
final class LikedFailure extends LikedState {
  const LikedFailure({required this.message});

  final String message;
}
