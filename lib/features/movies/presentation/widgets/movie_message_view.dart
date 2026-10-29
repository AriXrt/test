import 'package:flutter/material.dart';

/// Универсальный экран-заглушка: пустой список или ошибка.
class MovieMessageView extends StatelessWidget {
  const MovieMessageView({
    required this.message,
    required this.icon,
    this.onRetry,
    super.key,
  });

  final String message;
  final IconData icon;

  /// Если передан, показывается кнопка повтора.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Повторить'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
