import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import 'glass_container.dart';

/// Парящий стеклянный остров навигации в стиле iOS.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem(
      label: 'Свайпы',
      icon: Icons.style_outlined,
      selectedIcon: Icons.style,
    ),
    _NavItem(
      label: 'Избранное',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: AppTheme.navRadius,
      padding: const EdgeInsets.all(6),
      child: Row(
        children: <Widget>[
          for (int index = 0; index < _items.length; index++)
            Expanded(
              child: _NavBarItem(
                item: _items[index],
                isSelected: index == selectedIndex,
                onTap: () => onDestinationSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color foreground = isSelected
        ? colors.onPrimaryContainer
        : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.navRadius),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primaryContainer.withValues(alpha: 0.55)
                  : AppTheme.transparent,
              borderRadius: BorderRadius.circular(AppTheme.navRadius - 6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 22,
                  color: foreground,
                ),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
