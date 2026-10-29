import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_theme.dart';
import 'liked/liked_cubit.dart';
import 'liked/liked_screen.dart';
import 'movie_swipe_screen.dart';
import 'widgets/aurora_background.dart';
import 'widgets/glass_nav_bar.dart';

/// Нижняя навигация приложения: свайпы и избранное.
class MovieShellScreen extends StatefulWidget {
  const MovieShellScreen({super.key});

  @override
  State<MovieShellScreen> createState() => _MovieShellScreenState();
}

class _MovieShellScreenState extends State<MovieShellScreen> {
  static const int _likedTabIndex = 1;

  int _index = 0;

  void _onDestinationSelected(int index) {
    setState(() => _index = index);

    // Лайки могли измениться на вкладке свайпов — перечитываем их.
    if (index == _likedTabIndex) {
      context.read<LikedCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.transparent,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuroraBackground()),
          Positioned.fill(
            child: IndexedStack(
              index: _index,
              children: const <Widget>[MovieSwipeScreen(), LikedScreen()],
            ),
          ),
          // Парящий стеклянный остров навигации.
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: SafeArea(
              top: false,
              child: GlassNavBar(
                selectedIndex: _index,
                onDestinationSelected: _onDestinationSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
