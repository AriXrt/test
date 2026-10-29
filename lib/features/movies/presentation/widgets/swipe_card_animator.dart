import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/swipe_direction.dart';

/// Анимационная логика свайпа: смещение карточки, вылет за край и возврат.
///
/// Отделена от виджета, чтобы UI-файл оставался компактным.
class SwipeCardAnimator {
  SwipeCardAnimator({
    required TickerProvider vsync,
    required this.onOffsetChanged,
    required this.onSwiped,
  }) : _controller = AnimationController(
         vsync: vsync,
         duration: SwipeCardAnimator.flyOutDuration,
       ) {
    _controller.addListener(_handleTick);
  }

  /// Свайп засчитывается при смещении на 28% ширины карточки.
  static const double swipeThresholdFactor = 0.28;

  /// ...или при резком броске (px/s).
  static const double velocityThreshold = 800;

  /// Максимальный угол поворота карточки в радианах.
  static const double maxRotation = 0.35;

  static const Duration flyOutDuration = Duration(milliseconds: 250);
  static const Duration springBackDuration = Duration(milliseconds: 300);

  /// Вызывается на каждый кадр изменения смещения.
  final ValueChanged<Offset> onOffsetChanged;

  /// Вызывается после завершения анимации вылета.
  final ValueChanged<SwipeDirection> onSwiped;

  final AnimationController _controller;
  Animation<Offset>? _tween;
  Offset _offset = Offset.zero;
  double _width = 0;
  bool _isDismissing = false;
  bool _isDisposed = false;

  /// Текущее смещение карточки.
  Offset get offset => _offset;

  /// Ширина карточки из последнего layout-прохода.
  set width(double value) => _width = value;

  bool get _isIdle => !_isDismissing && !_controller.isAnimating;

  /// Обрабатывает перемещение пальца.
  void onDragUpdate(Offset delta) {
    if (!_isIdle) return;
    _offset += delta;
    onOffsetChanged(_offset);
  }

  /// Решает, завершить свайп или вернуть карточку на место.
  void onDragEnd(double velocity) {
    if (!_isIdle) return;

    final bool isBeyondThreshold =
        _offset.dx.abs() > _width * swipeThresholdFactor;
    final bool isFlicked = velocity.abs() > velocityThreshold;

    if (!isBeyondThreshold && !isFlicked) {
      springBack();
      return;
    }

    final double directionSource = isBeyondThreshold ? _offset.dx : velocity;
    flyOut(directionSource > 0 ? SwipeDirection.right : SwipeDirection.left);
  }

  /// Возвращает карточку в исходное положение пружиной.
  void springBack() {
    if (_isDismissing || _controller.isAnimating) return;

    _tween = Tween<Offset>(begin: _offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller
      ..duration = springBackDuration
      ..forward(from: 0);
  }

  /// Уводит карточку за край и сообщает о подтверждённом свайпе.
  void flyOut(SwipeDirection direction) {
    if (_isDismissing || _width <= 0) return;

    _isDismissing = true;
    HapticFeedback.lightImpact();

    final double targetX = (direction.isLike ? 1.4 : -1.4) * _width;
    _tween = Tween<Offset>(
      begin: _offset,
      end: Offset(targetX, _offset.dy),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward(from: 0).whenCompleteOrCancel(() {
      if (_isDisposed || !_isDismissing) return;
      onSwiped(direction);
    });
  }

  void dispose() {
    _isDisposed = true;
    _controller.dispose();
  }

  void _handleTick() {
    final Animation<Offset>? tween = _tween;
    if (tween == null) return;
    _offset = tween.value;
    onOffsetChanged(_offset);
  }
}
