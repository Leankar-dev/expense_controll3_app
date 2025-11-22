import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../theme/app_theme.dart';

abstract final class CustomSnackBar {
  static const Duration _defaultDuration = Duration(seconds: 3);

  static const Duration _longDuration = Duration(seconds: 5);

  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      type: _SnackBarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      type: _SnackBarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? _longDuration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      type: _SnackBarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      type: _SnackBarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? textColor,
    Color? iconColor,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    _showCustom(
      context,
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      textColor: textColor ?? AppColors.textOnDark,
      iconColor: iconColor ?? AppColors.textOnDark,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? _defaultDuration,
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void clearAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  static void _show(
    BuildContext context, {
    required String message,
    required _SnackBarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    final config = _getConfig(type);

    _showCustom(
      context,
      message: message,
      backgroundColor: config.backgroundColor,
      icon: config.icon,
      textColor: config.textColor,
      iconColor: config.iconColor,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration ?? _defaultDuration,
    );
  }

  static void _showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color textColor,
    required Color iconColor,
    String? actionLabel,
    VoidCallback? onAction,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              message,
              style: TextStyles.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      elevation: 6,
      duration: duration,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onAction?.call();
              },
            )
          : null,
      dismissDirection: DismissDirection.horizontal,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static _SnackBarConfig _getConfig(_SnackBarType type) {
    return switch (type) {
      _SnackBarType.success => const _SnackBarConfig(
        backgroundColor: AppColors.success,
        icon: Icons.check_circle_outline,
        textColor: AppColors.textOnDark,
        iconColor: AppColors.textOnDark,
      ),
      _SnackBarType.error => const _SnackBarConfig(
        backgroundColor: AppColors.error,
        icon: Icons.error_outline,
        textColor: AppColors.textOnDark,
        iconColor: AppColors.textOnDark,
      ),
      _SnackBarType.warning => const _SnackBarConfig(
        backgroundColor: AppColors.warning,
        icon: Icons.warning_amber_outlined,
        textColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
      ),
      _SnackBarType.info => const _SnackBarConfig(
        backgroundColor: AppColors.info,
        icon: Icons.info_outline,
        textColor: AppColors.textOnDark,
        iconColor: AppColors.textOnDark,
      ),
    };
  }
}

enum _SnackBarType {
  success,
  error,
  warning,
  info,
}

class _SnackBarConfig {
  final Color backgroundColor;
  final IconData icon;
  final Color textColor;
  final Color iconColor;

  const _SnackBarConfig({
    required this.backgroundColor,
    required this.icon,
    required this.textColor,
    required this.iconColor,
  });
}

class InlineMessageWidget extends StatelessWidget {
  final String message;
  final InlineMessageType type;
  final VoidCallback? onDismiss;
  final bool showIcon;

  const InlineMessageWidget({
    super.key,
    required this.message,
    this.type = InlineMessageType.info,
    this.onDismiss,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: config.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(
              config.icon,
              color: config.iconColor,
              size: 20,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyles.bodySmall.copyWith(
                color: config.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                color: config.iconColor,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _InlineMessageConfig _getConfig() {
    return switch (type) {
      InlineMessageType.success => const _InlineMessageConfig(
        backgroundColor: AppColors.successLight,
        borderColor: AppColors.success,
        textColor: AppColors.incomeDark,
        iconColor: AppColors.success,
        icon: Icons.check_circle_outline,
      ),
      InlineMessageType.error => const _InlineMessageConfig(
        backgroundColor: AppColors.errorLight,
        borderColor: AppColors.error,
        textColor: AppColors.expenseDark,
        iconColor: AppColors.error,
        icon: Icons.error_outline,
      ),
      InlineMessageType.warning => const _InlineMessageConfig(
        backgroundColor: AppColors.warningLight,
        borderColor: AppColors.warning,
        textColor: AppColors.textPrimary,
        iconColor: AppColors.warning,
        icon: Icons.warning_amber_outlined,
      ),
      InlineMessageType.info => const _InlineMessageConfig(
        backgroundColor: AppColors.infoLight,
        borderColor: AppColors.info,
        textColor: AppColors.textPrimary,
        iconColor: AppColors.info,
        icon: Icons.info_outline,
      ),
    };
  }
}

enum InlineMessageType {
  success,
  error,
  warning,
  info,
}

class _InlineMessageConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;

  const _InlineMessageConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
  });
}
