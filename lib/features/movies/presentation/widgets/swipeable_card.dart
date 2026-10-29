import 'package:flutter/material.dart';

import '../../domain/entities/swipe_direction.dart';
import 'swipe_card_animator.dart';
import 'swipe_stamp.dart';

/// Оборачивает карточку фильма и реализует Tinder-свайп.
class SwipeableCard extends StatefulWidget {
  const SwipeableCard({
    required this.child,
    required this.onSwipe,
    super.key,
  });

  final Widget child;

  /// Вызывается, когда свайп подтверждён жестом.
  final ValueChanged<SwipeDirection> onSwipe;

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late final SwipeCardAnimator _animator;
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animator = SwipeCardAnimator(
      vsync: this,
      onOffsetChanged: _handleOffsetChanged,
      onSwiped: widget.onSwipe,
    );
  }

  @override
  void dispose() {
    _animator.dispose();
    super.dispose();
  }

  void _handleOffsetChanged(Offset offset) {
    if (!mounted) return;
    setState(() => _offset = offset);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        _animator.width = width;

        final double progress = (_offset.dx.abs() / (width * 0.5))
            .clamp(0.0, 1.0)
            .toDouble();
        final double rotation =
            (_offset.dx / width).clamp(-1.0, 1.0).toDouble() *
            SwipeCardAnimator.maxRotation;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (DragUpdateDetails details) =>
              _animator.onDragUpdate(details.delta),
          onPanEnd: (DragEndDetails details) =>
              _animator.onDragEnd(details.velocity.pixelsPerSecond.dx),
          onPanCancel: _animator.springBack,
          child: Transform.translate(
            offset: _offset,
            child: Transform.rotate(
              angle: rotation,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  widget.child,
                  SwipeStamp(
                    label: 'ЛАЙК',
                    color: theme.colorScheme.primary,
                    opacity: _offset.dx > 0 ? progress : 0,
                    alignment: Alignment.topRight,
                  ),
                  SwipeStamp(
                    label: 'ДИЗЛАЙК',
                    color: theme.colorScheme.error,
                    opacity: _offset.dx < 0 ? progress : 0,
                    alignment: Alignment.topLeft,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
