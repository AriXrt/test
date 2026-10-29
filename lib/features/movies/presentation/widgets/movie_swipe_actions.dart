import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/swipe_direction.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';

/// Кнопки «Дизлайк» / «Лайк» — альтернатива свайпу для доступности.
class MovieSwipeActions extends StatelessWidget {
  const MovieSwipeActions({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final MovieBloc bloc = context.read<MovieBloc>();
    const Size buttonSize = Size.fromHeight(52);

    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => bloc.add(
              MovieSwiped(movie: movie, direction: SwipeDirection.left),
            ),
            icon: const Icon(Icons.close),
            label: const Text('Дизлайк'),
            style: OutlinedButton.styleFrom(minimumSize: buttonSize),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => bloc.add(
              MovieSwiped(movie: movie, direction: SwipeDirection.right),
            ),
            icon: const Icon(Icons.favorite),
            label: const Text('Лайк'),
            style: FilledButton.styleFrom(minimumSize: buttonSize),
          ),
        ),
      ],
    );
  }
}
