/// Направление свайпа карточки фильма.
enum SwipeDirection {
  /// Свайп влево — фильм не понравился.
  left,

  /// Свайп вправо — фильм понравился.
  right;

  /// `true`, если свайп означает лайк.
  bool get isLike => this == SwipeDirection.right;
}
