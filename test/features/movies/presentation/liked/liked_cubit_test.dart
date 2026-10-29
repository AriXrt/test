import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_project/features/movies/domain/entities/movie.dart';
import 'package:test_project/features/movies/presentation/liked/liked_cubit.dart';
import 'package:test_project/features/movies/presentation/liked/liked_state.dart';

import '../../../../helpers/fake_movie_repository.dart';
import '../../../../helpers/movie_fixtures.dart';

void main() {
  group('LikedCubit', () {
    const List<Movie> liked = <Movie>[
      testMovieInception,
      testMovieInterstellar,
    ];

    blocTest<LikedCubit, LikedState>(
      'load с лайками → LikedLoaded',
      build: () => LikedCubit(
        movieRepository: FakeMovieRepository(likedMovies: liked),
      ),
      act: (LikedCubit cubit) => cubit.load(),
      expect: () => <Matcher>[
        isA<LikedLoading>(),
        isA<LikedLoaded>()
            .having(
              (LikedLoaded state) => state.movies.length,
              'movies.length',
              2,
            )
            .having(
              (LikedLoaded state) => state.movies.first,
              'movies.first',
              testMovieInception,
            ),
      ],
    );

    blocTest<LikedCubit, LikedState>(
      'load без лайков → LikedEmpty',
      build: () => LikedCubit(movieRepository: FakeMovieRepository()),
      act: (LikedCubit cubit) => cubit.load(),
      expect: () => <Matcher>[isA<LikedLoading>(), isA<LikedEmpty>()],
    );

    blocTest<LikedCubit, LikedState>(
      'ошибка чтения избранного → LikedFailure',
      build: () => LikedCubit(
        movieRepository: FakeMovieRepository(
          likedError: Exception('hive is closed'),
        ),
      ),
      act: (LikedCubit cubit) => cubit.load(),
      expect: () => <Matcher>[
        isA<LikedLoading>(),
        isA<LikedFailure>().having(
          (LikedFailure state) => state.message,
          'message',
          contains('Не удалось загрузить избранное'),
        ),
      ],
    );

    blocTest<LikedCubit, LikedState>(
      'повторный load перечитывает данные',
      build: () => LikedCubit(
        movieRepository: FakeMovieRepository(likedMovies: liked),
      ),
      act: (LikedCubit cubit) async {
        await cubit.load();
        await cubit.load();
      },
      expect: () => <Matcher>[
        isA<LikedLoading>(),
        isA<LikedLoaded>(),
        isA<LikedLoading>(),
        isA<LikedLoaded>(),
      ],
    );
  });
}
