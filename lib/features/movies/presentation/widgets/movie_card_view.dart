import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import 'movie_info_panel.dart';
import 'movie_poster.dart';
import 'movie_swipe_actions.dart';
import 'swipeable_card.dart';

/// Карточка фильма: постер, информация и управление свайпами.
class MovieCardView extends StatelessWidget {
  const MovieCardView({
    required this.movie,
    required this.remaining,
    super.key,
  });

  final Movie movie;

  /// Сколько фильмов осталось после текущей карточки.
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final MovieBloc bloc = context.read<MovieBloc>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, AppTheme.navBarInset),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTheme.cardMaxWidth),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SwipeableCard(
                  onSwipe: (SwipeDirection direction) => bloc.add(
                    MovieSwiped(movie: movie, direction: direction),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        MoviePoster(movie: movie),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: MovieInfoPanel(
                            movie: movie,
                            remaining: remaining,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MovieSwipeActions(movie: movie),
            ],
          ),
        ),
      ),
    );
  }
}
