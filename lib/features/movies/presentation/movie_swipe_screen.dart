import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/movie_bloc.dart';
import 'bloc/movie_event.dart';
import 'bloc/movie_state.dart';
import 'liked/liked_cubit.dart';
import 'widgets/movie_card_view.dart';
import 'widgets/movie_message_view.dart';

/// Экран свайпов: показывает текущую карточку фильма.
class MovieSwipeScreen extends StatefulWidget {
  const MovieSwipeScreen({super.key});

  @override
  State<MovieSwipeScreen> createState() => _MovieSwipeScreenState();
}

class _MovieSwipeScreenState extends State<MovieSwipeScreen> {
  bool _isResetting = false;

  void _resetHistory() {
    setState(() => _isResetting = true);
    context.read<MovieBloc>().add(const ResetMovieHistory());
    context.read<LikedCubit>().load();
  }

  bool _listenWhen(MovieState previous, MovieState current) {
    if (!_isResetting) return false;
    return current is MovieLoaded ||
        current is MovieEmpty ||
        current is MovieFailure;
  }

  void _onResetFinished(MovieState state) {
    setState(() => _isResetting = false);
    if (state is MovieFailure) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('История очищена')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieMood'),
        actions: <Widget>[
          Semantics(
            button: true,
            label: 'Сбросить историю свайпов',
            child: IconButton(
              tooltip: 'Сбросить историю',
              onPressed: _isResetting ? null : _resetHistory,
              icon: const Icon(Icons.restart_alt),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<MovieBloc, MovieState>(
          listenWhen: _listenWhen,
          listener: (BuildContext context, MovieState state) =>
              _onResetFinished(state),
          builder: (BuildContext context, MovieState state) {
            return switch (state) {
              MovieLoading() => const Center(child: CircularProgressIndicator()),
              MovieLoaded(:final movie, :final remaining) =>
                MovieCardView(
                  key: ValueKey<int>(movie.id),
                  movie: movie,
                  remaining: remaining,
                ),
              MovieEmpty() => const MovieMessageView(
                icon: Icons.movie_filter_outlined,
                message: 'Фильмы закончились! Загляните позже за новой подборкой.',
              ),
              MovieFailure(:final message) => MovieMessageView(
                icon: Icons.error_outline,
                message: message,
                onRetry: () => context.read<MovieBloc>().add(const FetchMovies()),
              ),
            };
          },
        ),
      ),
    );
  }
}
