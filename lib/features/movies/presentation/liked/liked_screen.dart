import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_message_view.dart';
import 'liked_cubit.dart';
import 'liked_state.dart';
import 'widgets/liked_movie_card.dart';

/// Экран «Избранное»: сетка лайкнутых фильмов.
class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: SafeArea(
        child: BlocBuilder<LikedCubit, LikedState>(
          builder: (BuildContext context, LikedState state) {
            return switch (state) {
              LikedLoading() => const Center(child: CircularProgressIndicator()),
              LikedEmpty() => const MovieMessageView(
                icon: Icons.movie_filter_outlined,
                message:
                    'Пока нет лайкнутых фильмов.\n'
                    'Свайпните вправо — и они появятся здесь.',
              ),
              LikedFailure(:final message) => MovieMessageView(
                icon: Icons.error_outline,
                message: message,
                onRetry: () => context.read<LikedCubit>().load(),
              ),
              LikedLoaded(:final movies) => _LikedGrid(movies: movies),
            };
          },
        ),
      ),
    );
  }
}

/// Сетка избранных фильмов с pull-to-refresh.
class _LikedGrid extends StatelessWidget {
  const _LikedGrid({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<LikedCubit>().load(),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, AppTheme.navBarInset),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.62,
        ),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) =>
            LikedMovieCard(movie: movies[index]),
      ),
    );
  }
}
