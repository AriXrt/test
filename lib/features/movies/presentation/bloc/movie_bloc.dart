import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';
import '../../domain/repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

/// BLoC, выдающий карточки фильмов и обрабатывающий свайпы.
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({required MovieRepository movieRepository})
    : _repository = movieRepository,
      super(const MovieLoading()) {
    on<FetchMovies>(_onFetchMovies);
    on<MovieSwiped>(_onMovieSwiped);
    on<ResetMovieHistory>(_onResetMovieHistory);
  }

  static const String _logName = 'MovieBloc';

  final MovieRepository _repository;

  /// Очередь фильмов: первый элемент — текущая карточка.
  final List<Movie> _queue = <Movie>[];

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    _queue.clear();

    try {
      final movies = await _repository.fetchMovies();
      if (isClosed) return;

      _queue.addAll(movies);
      emit(_nextState());
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось загрузить фильмы',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        const MovieFailure(
          message: 'Не удалось загрузить фильмы. Попробуйте ещё раз.',
        ),
      );
    }
  }

  Future<void> _onMovieSwiped(
    MovieSwiped event,
    Emitter<MovieState> emit,
  ) async {
    final currentState = state;

    if (currentState is! MovieLoaded) {
      developer.log(
        'Свайп проигнорирован: состояние ${currentState.runtimeType}',
        name: _logName,
      );
      return;
    }

    if (currentState.movie.id != event.movie.id) {
      developer.log(
        'Свайп проигнорирован: карточка ${event.movie.id} уже не актуальна',
        name: _logName,
      );
      return;
    }

    try {
      await _repository.saveSwipe(
        movie: event.movie,
        direction: event.direction,
      );
      if (isClosed) return;

      _queue.removeWhere((movie) => movie.id == event.movie.id);
      emit(_nextState(lastDirection: event.direction));
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось сохранить свайп для «${event.movie.title}»',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        const MovieFailure(
          message: 'Не удалось сохранить свайп. Попробуйте ещё раз.',
        ),
      );
    }
  }

  Future<void> _onResetMovieHistory(
    ResetMovieHistory event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    _queue.clear();

    try {
      await _repository.clearHistory();
      if (isClosed) return;

      final movies = await _repository.fetchMovies();
      if (isClosed) return;

      _queue.addAll(movies);
      emit(_nextState());
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось сбросить историю свайпов',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        const MovieFailure(
          message: 'Не удалось сбросить историю. Попробуйте ещё раз.',
        ),
      );
    }
  }

  /// Собирает состояние по текущей очереди фильмов.
  MovieState _nextState({SwipeDirection? lastDirection}) {
    if (_queue.isEmpty) return const MovieEmpty();

    return MovieLoaded(
      movie: _queue.first,
      remaining: _queue.length - 1,
      lastDirection: lastDirection,
    );
  }
}
