import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_project/features/movies/domain/entities/movie.dart';
import 'package:test_project/features/movies/domain/entities/swipe_direction.dart';
import 'package:test_project/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:test_project/features/movies/presentation/bloc/movie_event.dart';
import 'package:test_project/features/movies/presentation/bloc/movie_state.dart';

import '../../../../helpers/fake_movie_repository.dart';
import '../../../../helpers/movie_fixtures.dart';

void main() {
  const List<Movie> queue = <Movie>[testMovieInception, testMovieDarkKnight];

  group('MovieBloc / FetchMovies', () {
    blocTest<MovieBloc, MovieState>(
      'успешная загрузка → MovieLoaded с первой карточкой',
      build: () => MovieBloc(
        movieRepository: FakeMovieRepository(movies: queue),
      ),
      act: (MovieBloc bloc) => bloc.add(const FetchMovies()),
      expect: () => <Matcher>[
        isA<MovieLoading>(),
        isA<MovieLoaded>()
            .having(
              (MovieLoaded state) => state.movie,
              'movie',
              testMovieInception,
            )
            .having((MovieLoaded state) => state.remaining, 'remaining', 1),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'пустая подборка → MovieEmpty',
      build: () => MovieBloc(movieRepository: FakeMovieRepository()),
      act: (MovieBloc bloc) => bloc.add(const FetchMovies()),
      expect: () => <Matcher>[isA<MovieLoading>(), isA<MovieEmpty>()],
    );

    blocTest<MovieBloc, MovieState>(
      'ошибка репозитория → MovieFailure',
      build: () => MovieBloc(
        movieRepository: FakeMovieRepository(
          fetchError: Exception('network is down'),
        ),
      ),
      act: (MovieBloc bloc) => bloc.add(const FetchMovies()),
      expect: () => <Matcher>[
        isA<MovieLoading>(),
        isA<MovieFailure>().having(
          (MovieFailure state) => state.message,
          'message',
          contains('Не удалось загрузить фильмы'),
        ),
      ],
    );
  });

  group('MovieBloc / MovieSwiped', () {
    late FakeMovieRepository repository;

    setUp(() {
      repository = FakeMovieRepository(movies: queue);
    });

    blocTest<MovieBloc, MovieState>(
      'свайп вправо сохраняет лайк и открывает следующую карточку',
      build: () => MovieBloc(movieRepository: repository),
      act: (MovieBloc bloc) {
        bloc
          ..add(const FetchMovies())
          ..add(
            MovieSwiped(
              movie: testMovieInception,
              direction: SwipeDirection.right,
            ),
          );
      },
      skip: 2,
      expect: () => <Matcher>[
        isA<MovieLoaded>()
            .having(
              (MovieLoaded state) => state.movie,
              'movie',
              testMovieDarkKnight,
            )
            .having(
              (MovieLoaded state) => state.lastDirection,
              'lastDirection',
              SwipeDirection.right,
            )
            .having((MovieLoaded state) => state.isLike, 'isLike', isTrue),
      ],
      verify: (_) {
        expect(repository.savedMovies, <Movie>[testMovieInception]);
        expect(repository.savedDirections, <SwipeDirection>[
          SwipeDirection.right,
        ]);
      },
    );

    blocTest<MovieBloc, MovieState>(
      'после последнего свайпа → MovieEmpty',
      build: () => MovieBloc(movieRepository: repository),
      act: (MovieBloc bloc) {
        bloc
          ..add(const FetchMovies())
          ..add(
            MovieSwiped(
              movie: testMovieInception,
              direction: SwipeDirection.left,
            ),
          )
          ..add(
            MovieSwiped(
              movie: testMovieDarkKnight,
              direction: SwipeDirection.left,
            ),
          );
      },
      skip: 3,
      expect: () => <Matcher>[isA<MovieEmpty>()],
      verify: (_) {
        expect(repository.savedDirections, <SwipeDirection>[
          SwipeDirection.left,
          SwipeDirection.left,
        ]);
      },
    );

    blocTest<MovieBloc, MovieState>(
      'свайп без загруженной карточки игнорируется',
      build: () => MovieBloc(movieRepository: repository),
      act: (MovieBloc bloc) => bloc.add(
        MovieSwiped(movie: testMovieInception, direction: SwipeDirection.right),
      ),
      expect: () => <Matcher>[],
      verify: (_) => expect(repository.savedMovies, isEmpty),
    );

    blocTest<MovieBloc, MovieState>(
      'ошибка сохранения свайпа → MovieFailure',
      build: () => MovieBloc(
        movieRepository: FakeMovieRepository(
          movies: queue,
          saveError: Exception('disk is full'),
        ),
      ),
      act: (MovieBloc bloc) {
        bloc
          ..add(const FetchMovies())
          ..add(
            MovieSwiped(
              movie: testMovieInception,
              direction: SwipeDirection.right,
            ),
          );
      },
      skip: 2,
      expect: () => <Matcher>[
        isA<MovieFailure>().having(
          (MovieFailure state) => state.message,
          'message',
          contains('Не удалось сохранить свайп'),
        ),
      ],
    );
  });

  group('MovieBloc / ResetMovieHistory', () {
    late FakeMovieRepository repository;

    setUp(() {
      repository = FakeMovieRepository(movies: queue);
    });

    blocTest<MovieBloc, MovieState>(
      'сброс очищает историю и заново отдаёт подборку',
      build: () => MovieBloc(movieRepository: repository),
      act: (MovieBloc bloc) => bloc.add(const ResetMovieHistory()),
      expect: () => <Matcher>[
        isA<MovieLoading>(),
        isA<MovieLoaded>()
            .having(
              (MovieLoaded state) => state.movie,
              'movie',
              testMovieInception,
            )
            .having((MovieLoaded state) => state.remaining, 'remaining', 1),
      ],
      verify: (_) => expect(repository.clearHistoryCalls, 1),
    );

    blocTest<MovieBloc, MovieState>(
      'ошибка очистки → MovieFailure',
      build: () => MovieBloc(
        movieRepository: FakeMovieRepository(
          movies: queue,
          clearError: Exception('storage error'),
        ),
      ),
      act: (MovieBloc bloc) => bloc.add(const ResetMovieHistory()),
      expect: () => <Matcher>[
        isA<MovieLoading>(),
        isA<MovieFailure>().having(
          (MovieFailure state) => state.message,
          'message',
          contains('Не удалось сбросить историю'),
        ),
      ],
    );
  });
}
