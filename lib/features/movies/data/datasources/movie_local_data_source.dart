import 'dart:developer' as developer;

import 'package:hive/hive.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';

/// Локальное хранилище фильмов и истории свайпов на Hive.
///
/// Бокс `movie_swipes` хранит направление свайпа (`right`/`left`),
/// бокс `movie_cache` — снимок сущности [Movie] для экрана «Избранное».
class MovieLocalDataSource {
  MovieLocalDataSource({
    required Box<String> swipes,
    required Box<Movie> movieCache,
  }) : _swipesBox = swipes,
       _movieCacheBox = movieCache;

  // v2: в Movie добавилось поле kinopoiskUrl (7 полей в адаптере).
  static const String swipesBoxName = 'movie_swipes_v2';
  static const String movieCacheBoxName = 'movie_cache_v2';
  static const String _logName = 'MovieLocalDataSource';

  final Box<String> _swipesBox;
  final Box<Movie> _movieCacheBox;

  /// Открывает боксы.
  ///
  /// Требует предварительной инициализации: `Hive.initFlutter()` в приложении
  /// или `Hive.init(path)` в тестах, плюс регистрацию `MovieAdapter`.
  static Future<MovieLocalDataSource> open() async {
    final Box<String> swipesBox = await Hive.openBox<String>(swipesBoxName);
    final Box<Movie> movieCacheBox = await Hive.openBox<Movie>(
      movieCacheBoxName,
    );

    return MovieLocalDataSource(
      swipes: swipesBox,
      movieCache: movieCacheBox,
    );
  }

  /// Идентификаторы фильмов, по которым пользователь уже свайпнул.
  Future<Set<int>> swipedMovieIds() async {
    try {
      return _swipesBox.keys.whereType<int>().toSet();
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось прочитать историю свайпов',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Фильмы, которые пользователь лайкнул (свайп вправо).
  Future<List<Movie>> likedMovies() async {
    try {
      final List<Movie> liked = <Movie>[];
      for (final dynamic key in _swipesBox.keys) {
        final String? direction = _swipesBox.get(key);
        if (direction != SwipeDirection.right.name) continue;

        final Movie? movie = _movieCacheBox.get(key);
        if (movie != null) liked.add(movie);
      }
      return List<Movie>.unmodifiable(liked);
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось прочитать лайкнутые фильмы',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Сохраняет свайп: направление и снимок фильма.
  Future<void> saveSwipe({
    required Movie movie,
    required SwipeDirection direction,
  }) async {
    try {
      await _swipesBox.put(movie.id, direction.name);
      await _movieCacheBox.put(movie.id, movie);
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось сохранить свайп для «${movie.title}»',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Полностью очищает историю свайпов и кэш фильмов.
  Future<void> clearHistory() async {
    try {
      await _swipesBox.clear();
      await _movieCacheBox.clear();
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось очистить историю свайпов',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
