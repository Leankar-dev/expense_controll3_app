import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

/// A customizable Neumorphic styled TextFormField widget.
class NeumorphicTextFormField extends StatefulWidget {
  final TextEditingController? controller;

  final String? labelText;

  final String? hintText;

  final String? helperText;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onFieldSubmitted;

  final FormFieldSetter<String>? onSaved;

  final TextInputType keyboardType;

  final TextInputAction textInputAction;

  final bool obscureText;

  final IconData? prefixIcon;

  final Widget? suffixWidget;

  final IconData? suffixIcon;

  final VoidCallback? onSuffixTap;

  final int maxLines;

  final int minLines;

  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final TextCapitalization textCapitalization;

  final String? initialValue;

  final FocusNode? focusNode;

  final double depth;

  final double borderRadius;

  final bool showCounter;

  const NeumorphicTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixWidget,
    this.suffixIcon,
    this.onSuffixTap,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
    this.focusNode,
    this.depth = -3.0,
    this.borderRadius = 12.0,
    this.showCounter = false,
  });

  @override
  State<NeumorphicTextFormField> createState() =>
      _NeumorphicTextFormFieldState();
}

class _NeumorphicTextFormFieldState extends State<NeumorphicTextFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: TextStyles.inputLabel.copyWith(
              color: _hasError
                  ? AppColors.error
                  : (_isFocused ? AppColors.primary : AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 8),
        ],

        Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(widget.borderRadius),
            ),
            depth: widget.depth,
            intensity: 0.5,
            lightSource: LightSource.topLeft,
            color: AppColors.background,
            shadowLightColor: AppColors.neumorphicLight,
            shadowDarkColor: AppColors.neumorphicDark,
            border: _getBorder(),
          ),
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.controller == null
                ? widget.initialValue
                : null,
            focusNode: _focusNode,
            decoration: _buildDecoration(),
            style: TextStyles.inputText.copyWith(
              color: widget.enabled
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            ),
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onSaved: widget.onSaved,
            validator: (value) {
              final error = widget.validator?.call(value);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _hasError = error != null;
                    _errorText = error;
                  });
                }
              });
              return error;
            },
            buildCounter: widget.showCounter
                ? null
                : (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => null,
          ),
        ),

        if (_errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorText ?? widget.helperText ?? '',
            style: TextStyles.inputError.copyWith(
              color: _hasError ? AppColors.error : AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  NeumorphicBorder _getBorder() {
    if (_hasError) {
      return const NeumorphicBorder(
        color: AppColors.error,
        width: 1.5,
      );
    }

    if (_isFocused) {
      return const NeumorphicBorder(
        color: AppColors.primary,
        width: 1.5,
      );
    }

    return const NeumorphicBorder.none();
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyles.inputHint,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: widget.maxLines > 1 ? 16 : 0,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _isFocused ? AppColors.primary : AppColors.icon,
              size: 22,
            )
          : null,
      suffixIcon: _buildSuffix(),
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffixWidget != null) {
      return widget.suffixWidget;
    }

    if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(
          widget.suffixIcon,
          color: _isFocused ? AppColors.primary : AppColors.icon,
          size: 22,
        ),
      );
    }

    return null;
  }
}

class NeumorphicPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;
  final FocusNode? focusNode;

  const NeumorphicPasswordField({
    super.key,
    this.controller,
    this.labelText = 'Palavra-passe',
    this.hintText = 'Introduza a sua palavra-passe',
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<NeumorphicPasswordField> createState() =>
      _NeumorphicPasswordFieldState();
}

class _NeumorphicPasswordFieldState extends State<NeumorphicPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicTextFormField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      prefixIcon: Icons.lock_outline,
      suffixIcon: _obscureText ? Icons.visibility_off : Icons.visibility,
      onSuffixTap: _toggleVisibility,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}

class NeumorphicEmailField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;
  final FocusNode? focusNode;

  const NeumorphicEmailField({
    super.key,
    this.controller,
    this.labelText = 'Email',
    this.hintText = 'Introduza o seu email',
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicTextFormField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      focusNode: focusNode,
      prefixIcon: Icons.email_outlined,
      textCapitalization: TextCapitalization.none,
    );
  }
}

class NeumorphicCurrencyField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final bool enabled;
  final FocusNode? focusNode;

  const NeumorphicCurrencyField({
    super.key,
    this.controller,
    this.labelText = 'Valor',
    this.hintText = '0,00',
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicTextFormField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: enabled,
      focusNode: focusNode,
      prefixIcon: Icons.euro,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
      ],
    );
  }
}

class NeumorphicSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final bool autofocus;

  const NeumorphicSearchField({
    super.key,
    this.controller,
    this.hintText = 'Pesquisar...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
        depth: -3,
        intensity: 0.5,
        lightSource: LightSource.topLeft,
        color: AppColors.background,
        shadowLightColor: AppColors.neumorphicLight,
        shadowDarkColor: AppColors.neumorphicDark,
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: TextStyles.inputText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyles.inputHint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.icon,
            size: 22,
          ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? GestureDetector(
                  onTap: () {
                    controller?.clear();
                    onClear?.call();
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.icon,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
