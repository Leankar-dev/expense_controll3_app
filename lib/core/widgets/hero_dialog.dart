import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/text_styles.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final String heroTag;

  HeroDialogRoute({
    required this.builder,
    required this.heroTag,
    super.settings,
    super.fullscreenDialog = false,
  });

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => AppTheme.animationRoute;

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }
}

class HeroDialogContent extends StatelessWidget {
  final String heroTag;

  final String? title;

  final Widget child;

  final bool showCloseButton;

  final VoidCallback? onClose;

  final EdgeInsets contentPadding;

  final double maxWidth;

  final double? maxHeight;

  const HeroDialogContent({
    super.key,
    required this.heroTag,
    this.title,
    required this.child,
    this.showCloseButton = true,
    this.onClose,
    this.contentPadding = const EdgeInsets.all(20),
    this.maxWidth = 400,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Hero(
          tag: heroTag,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            ),
            elevation: 8,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight:
                    maxHeight ?? MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null || showCloseButton) _buildHeader(context),

                    Padding(
                      padding: contentPadding,
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
      child: Row(
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: TextStyles.titleLarge,
              ),
            ),
          if (showCloseButton)
            IconButton(
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}

class CustomRectTween extends RectTween {
  CustomRectTween({required Rect begin, required Rect end})
    : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final curvedT = Curves.easeInOutCubic.transform(t);
    return Rect.lerp(begin, end, curvedT)!;
  }
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.confirmColor,
    this.icon,
    this.isDestructive = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
    IconData? icon,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveConfirmColor =
        confirmColor ?? (isDestructive ? AppColors.error : AppColors.primary);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      backgroundColor: AppColors.background,
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: effectiveConfirmColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: effectiveConfirmColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyles.titleLarge,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: TextStyles.buttonSecondary.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveConfirmColor,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData? icon;
  final Color? iconColor;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.icon,
    this.iconColor,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
    Color? iconColor,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      backgroundColor: AppColors.background,
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyles.titleLarge,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }
}

class InputDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String? initialValue;
  final String? hintText;
  final String confirmText;
  final String cancelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const InputDialog({
    super.key,
    required this.title,
    this.message,
    this.initialValue,
    this.hintText,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? message,
    String? initialValue,
    String? hintText,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => InputDialog(
        title: title,
        message: message,
        initialValue: initialValue,
        hintText: hintText,
        confirmText: confirmText,
        cancelText: cancelText,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      backgroundColor: AppColors.background,
      title: Text(widget.title, style: TextStyles.titleLarge),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message != null) ...[
              Text(
                widget.message!,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              autofocus: true,
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            widget.cancelText,
            style: TextStyles.buttonSecondary.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showDragHandle;
  final bool showCloseButton;
  final double? maxHeight;

  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.maxHeight,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool showDragHandle = true,
    bool showCloseButton = false,
    double? maxHeight,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      builder: (context) => CustomBottomSheet(
        title: title,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        maxHeight: maxHeight,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          if (title != null || showCloseButton)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(title!, style: TextStyles.titleLarge),
                    ),
                  if (showCloseButton)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
