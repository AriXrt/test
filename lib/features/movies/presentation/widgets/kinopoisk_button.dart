import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_theme.dart';
import 'glass_container.dart';

/// Стеклянная кнопка «Смотреть на Кинопоиске».
class KinopoiskButton extends StatelessWidget {
  const KinopoiskButton({
    required this.url,
    this.showLabel = true,
    super.key,
  });

  /// Ссылка на страницу фильма.
  final String url;

  /// `false` — компактная иконка без подписи.
  final bool showLabel;

  /// Подсказка и семантическая подпись кнопки.
  static const String tooltip = 'Смотреть на Кинопоиске';

  Future<void> _open(BuildContext context) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    try {
      final bool opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        messenger.showSnackBar(_failureSnackBar);
      }
    } on Object catch (error, stackTrace) {
      developer.log(
        'Не удалось открыть ссылку на Кинопоиск',
        name: 'KinopoiskButton',
        error: error,
        stackTrace: stackTrace,
      );
      messenger.showSnackBar(_failureSnackBar);
    }
  }

  static const SnackBar _failureSnackBar = SnackBar(
    content: Text('Не удалось открыть браузер'),
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: GlassContainer(
        radius: AppTheme.navRadius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.navRadius),
            onTap: () => _open(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showLabel ? 16 : 10,
                vertical: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: colors.primary,
                    semanticLabel: tooltip,
                  ),
                  if (showLabel) ...<Widget>[
                    const SizedBox(width: 8),
                    Text(
                      'Смотреть на Кинопоиске',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
