import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import 'liked_state.dart';

/// Cubit вкладки «Избранное»: читает лайкнутые фильмы из репозитория.
class LikedCubit extends Cubit<LikedState> {
  LikedCubit({required MovieRepository movieRepository})
    : _repository = movieRepository,
      super(const LikedLoading());

  static const String _logName = 'LikedCubit';

  final MovieRepository _repository;

  /// Перечитывает список лайкнутых фильмов.
  Future<void> load() async {
    emit(const LikedLoading());

    try {
      final List<Movie> movies = await _repository.fetchLikedMovies();
      if (isClosed) return;

      emit(movies.isEmpty ? const LikedEmpty() : LikedLoaded(movies: movies));
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось загрузить избранное',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      if (isClosed) return;

      emit(const LikedFailure(message: 'Не удалось загрузить избранное.'));
    }
  }
}
