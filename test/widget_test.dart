// Тесты UI (свайпы, стекло, Кинопоиск) и локальной базы Hive.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:test_project/features/movies/data/adapters/movie_adapter.dart';
import 'package:test_project/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:test_project/features/movies/data/repositories/hive_movie_repository.dart';
import 'package:test_project/features/movies/data/repositories/mock_movie_repository.dart';
import 'package:test_project/features/movies/domain/entities/movie.dart';
import 'package:test_project/features/movies/domain/entities/swipe_direction.dart';
import 'package:test_project/features/movies/domain/repositories/movie_repository.dart';
import 'package:test_project/features/movies/presentation/widgets/glass_nav_bar.dart';
import 'package:test_project/features/movies/presentation/widgets/kinopoisk_button.dart';
import 'package:test_project/features/movies/presentation/widgets/poster_placeholder.dart';
import 'package:test_project/features/movies/presentation/widgets/swipeable_card.dart';
import 'package:test_project/main.dart';

/// Репозиторий в памяти: UI-тестам не нужен реальный дисковый I/O Hive.
class _InMemoryMovieRepository implements MovieRepository {
  _InMemoryMovieRepository(List<Movie> movies)
    : _movies = List<Movie>.of(movies);

  final List<Movie> _movies;
  final Set<int> _swipedIds = <int>{};
  final List<Movie> _liked = <Movie>[];

  @override
  Future<List<Movie>> fetchMovies() async => List<Movie>.unmodifiable(
    _movies.where((Movie movie) => !_swipedIds.contains(movie.id)),
  );

  @override
  Future<List<Movie>> fetchLikedMovies() async =>
      List<Movie>.unmodifiable(_liked);

  @override
  Future<void> saveSwipe({
    required Movie movie,
    required SwipeDirection direction,
  }) async {
    _swipedIds.add(movie.id);
    if (direction.isLike) _liked.add(movie);
  }

  @override
  Future<void> clearHistory() async {
    _swipedIds.clear();
    _liked.clear();
  }
}

const String _firstTitle = 'Побег из Шоушенка';
const String _secondTitle = 'Зелёная миля';
const int _totalMovies = 35;

void main() {
  group('Экран свайпов', () {
    late _InMemoryMovieRepository repository;

    setUp(() async {
      final List<Movie> movies = await MockMovieRepository(
        latency: Duration.zero,
      ).fetchMovies();
      repository = _InMemoryMovieRepository(movies);
    });

    testWidgets('Показывает лоадер, затем карточку первого фильма', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text(_firstTitle), findsOneWidget);
      expect(find.text('Дизлайк'), findsOneWidget);
      expect(find.text('Лайк'), findsOneWidget);
      expect(find.text('Осталось карточек: ${_totalMovies - 1}'), findsOneWidget);
    });

    testWidgets('Лайк переключает карточку на следующий фильм', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Лайк'));
      await tester.pumpAndSettle();

      expect(find.text(_secondTitle), findsOneWidget);
      expect(find.text('Осталось карточек: ${_totalMovies - 2}'), findsOneWidget);
    });

    testWidgets('Свайп вправо переключает карточку на следующий фильм', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SwipeableCard), const Offset(400, 0));
      await tester.pumpAndSettle();

      expect(find.text(_secondTitle), findsOneWidget);
    });

    testWidgets('Свайп влево отправляет дизлайк и меняет карточку', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SwipeableCard), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text(_secondTitle), findsOneWidget);
    });

    testWidgets('Постер: офлайн-основа и сетевая картинка Кинопоиска', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      expect(find.byType(PosterPlaceholder), findsWidgets);
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('На панели фильма есть кнопка Кинопоиска', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      expect(find.byType(KinopoiskButton), findsWidgets);
      expect(find.byTooltip(KinopoiskButton.tooltip), findsWidgets);
    });

    testWidgets('Нижняя навигация — стеклянный остров', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      expect(find.byType(GlassNavBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('После последней карточки показывается MovieEmpty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      for (var i = 0; i < _totalMovies; i++) {
        await tester.tap(find.text('Дизлайк'));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Фильмы закончились'), findsOneWidget);
    });

    testWidgets('Кнопка сброса истории возвращает фильмы в очередь', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Сбросить историю'), findsOneWidget);

      await tester.tap(find.text('Дизлайк'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Дизлайк'));
      await tester.pumpAndSettle();
      expect(find.text('Осталось карточек: ${_totalMovies - 3}'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.restart_alt));
      await tester.pumpAndSettle();

      expect(find.text(_firstTitle), findsOneWidget);
      expect(find.text('Осталось карточек: ${_totalMovies - 1}'), findsOneWidget);
    });

    testWidgets('Лайкнутый фильм появляется во вкладке «Избранное»', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Лайк'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite_outline));
      await tester.pumpAndSettle();

      expect(find.text(_firstTitle), findsOneWidget);
    });

    testWidgets('Пустое избранное показывает заглушку', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MovieMoodApp(repository: repository));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite_outline));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Пока нет лайкнутых фильмов'),
        findsOneWidget,
      );
    });
  });

  group('Hive-хранилище', () {
    late Directory tempDir;
    late MovieLocalDataSource local;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('moviemood_hive_test');
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(MovieAdapter());
      }
      local = await MovieLocalDataSource.open();
      await local.clearHistory();
    });

    tearDown(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('Лайк сохраняется и фильм не возвращается после перезапуска', () async {
      final HiveMovieRepository repository = HiveMovieRepository(
        movieRepository: MockMovieRepository(latency: Duration.zero),
        localDataSource: local,
      );

      final List<Movie> before = await repository.fetchMovies();
      expect(before, hasLength(_totalMovies));

      await repository.saveSwipe(
        movie: before.first,
        direction: SwipeDirection.right,
      );

      // Эмулируем перезапуск: закрываем и заново открываем боксы v2.
      await Hive.close();
      final MovieLocalDataSource reopened = await MovieLocalDataSource.open();
      final HiveMovieRepository restarted = HiveMovieRepository(
        movieRepository: MockMovieRepository(latency: Duration.zero),
        localDataSource: reopened,
      );

      final List<Movie> after = await restarted.fetchMovies();
      expect(after, hasLength(_totalMovies - 1));
      expect(after.any((Movie movie) => movie.id == before.first.id), isFalse);

      final List<Movie> liked = await reopened.likedMovies();
      expect(liked, hasLength(1));
      // Ручной MovieAdapter сохранил и kinopoiskUrl.
      expect(liked.first, before.first);
    });

    test('Дизлайк скрывает фильм, но не попадает в избранное', () async {
      final HiveMovieRepository repository = HiveMovieRepository(
        movieRepository: MockMovieRepository(latency: Duration.zero),
        localDataSource: local,
      );

      final List<Movie> movies = await repository.fetchMovies();
      await repository.saveSwipe(
        movie: movies.first,
        direction: SwipeDirection.left,
      );

      expect(await local.swipedMovieIds(), contains(movies.first.id));
      expect(await local.likedMovies(), isEmpty);
      expect(await repository.fetchMovies(), hasLength(_totalMovies - 1));
    });

    test('clearHistory возвращает фильмы в очередь и чистит избранное', () async {
      final HiveMovieRepository repository = HiveMovieRepository(
        movieRepository: MockMovieRepository(latency: Duration.zero),
        localDataSource: local,
      );

      final List<Movie> movies = await repository.fetchMovies();
      await repository.saveSwipe(
        movie: movies.first,
        direction: SwipeDirection.right,
      );

      expect(await repository.fetchMovies(), hasLength(_totalMovies - 1));
      expect(await repository.fetchLikedMovies(), hasLength(1));

      await repository.clearHistory();

      expect(await repository.fetchMovies(), hasLength(_totalMovies));
      expect(await repository.fetchLikedMovies(), isEmpty);
      expect(await local.swipedMovieIds(), isEmpty);
    });
  });
}
