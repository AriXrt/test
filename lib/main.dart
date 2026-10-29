import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/theme/app_theme.dart';
import 'features/movies/data/adapters/movie_adapter.dart';
import 'features/movies/data/datasources/movie_local_data_source.dart';
import 'features/movies/data/repositories/hive_movie_repository.dart';
import 'features/movies/data/repositories/mock_movie_repository.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/presentation/bloc/movie_bloc.dart';
import 'features/movies/presentation/bloc/movie_event.dart';
import 'features/movies/presentation/liked/liked_cubit.dart';
import 'features/movies/presentation/movie_shell_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());

  final MovieLocalDataSource localDataSource = await MovieLocalDataSource.open();

  runApp(
    MovieMoodApp(
      repository: HiveMovieRepository(
        movieRepository: MockMovieRepository(),
        localDataSource: localDataSource,
      ),
    ),
  );
}

/// Корневой виджет приложения MovieMood.
class MovieMoodApp extends StatelessWidget {
  const MovieMoodApp({required this.repository, super.key});

  /// Репозиторий фильмов. В тестах подменяется на собранный вручную.
  final MovieRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MovieRepository>.value(
      value: repository,
      child: BlocProvider<MovieBloc>(
        create: (BuildContext context) =>
            MovieBloc(movieRepository: context.read<MovieRepository>())
              ..add(const FetchMovies()),
        child: BlocProvider<LikedCubit>(
          create: (BuildContext context) =>
              LikedCubit(movieRepository: context.read<MovieRepository>())
                ..load(),
          child: MaterialApp(
            title: 'MovieMood',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const MovieShellScreen(),
          ),
        ),
      ),
    );
  }
}
