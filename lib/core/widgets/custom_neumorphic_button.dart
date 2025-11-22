import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomNeumorphicButton extends StatelessWidget {
  /// Texto do botão
  final String text;

  /// Callback ao pressionar (obrigatório)
  final VoidCallback onPressed;

  /// Indica se está em estado de loading
  final bool isLoading;

  /// Indica se está desabilitado
  final bool isDisabled;

  /// Ícone opcional (exibido antes do texto)
  final IconData? icon;

  /// Variante do botão
  final NeumorphicButtonVariant variant;

  /// Largura total (se true, ocupa toda a largura disponível)
  final bool isExpanded;

  /// Cor de fundo customizada
  final Color? backgroundColor;

  /// Cor do texto customizada
  final Color? textColor;

  /// Altura do botão
  final double height;

  /// Border radius
  final double borderRadius;

  /// Profundidade Neumorphic
  final double depth;

  const CustomNeumorphicButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.variant = NeumorphicButtonVariant.primary,
    this.isExpanded = true,
    this.backgroundColor,
    this.textColor,
    this.height = 56.0,
    this.borderRadius = 22.0,
    this.depth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading;

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: NeumorphicButton(
        onPressed: isEnabled ? onPressed : null,
        style: _getButtonStyle(isEnabled),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: _buildContent(),
      ),
    );
  }

  /// Retorna o estilo do botão baseado na variante
  NeumorphicStyle _getButtonStyle(bool isEnabled) {
    final baseColor = _getBackgroundColor();

    return NeumorphicStyle(
      shape: NeumorphicShape.flat,
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(borderRadius),
      ),
      depth: isEnabled ? depth : 0,
      intensity: isEnabled ? 0.6 : 0.3,
      lightSource: LightSource.topLeft,
      color: isEnabled ? baseColor : baseColor.withValues(alpha: 0.6),
      shadowLightColor: AppColors.neumorphicLight,
      shadowDarkColor: AppColors.neumorphicDark,
    );
  }

  /// Retorna a cor de fundo baseada na variante
  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    return switch (variant) {
      NeumorphicButtonVariant.primary => AppColors.primary,
      NeumorphicButtonVariant.secondary => AppColors.background,
      NeumorphicButtonVariant.success => AppColors.success,
      NeumorphicButtonVariant.danger => AppColors.error,
      NeumorphicButtonVariant.warning => AppColors.warning,
      NeumorphicButtonVariant.outline => AppColors.background,
    };
  }

  /// Retorna a cor do texto baseada na variante
  Color _getTextColor() {
    if (textColor != null) return textColor!;

    return switch (variant) {
      NeumorphicButtonVariant.primary => AppColors.textOnPrimary,
      NeumorphicButtonVariant.secondary => AppColors.primary,
      NeumorphicButtonVariant.success => AppColors.textOnPrimary,
      NeumorphicButtonVariant.danger => AppColors.textOnPrimary,
      NeumorphicButtonVariant.warning => AppColors.textPrimary,
      NeumorphicButtonVariant.outline => AppColors.primary,
    };
  }

  /// Constrói o conteúdo do botão
  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    final color = _getTextColor();

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyles.buttonPrimary.copyWith(color: color),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyles.buttonPrimary.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}

/// Variantes do botão Neumorphic
enum NeumorphicButtonVariant {
  /// Botão primário (cor principal)
  primary,

  /// Botão secundário (fundo neutro)
  secondary,

  /// Botão de sucesso (verde)
  success,

  /// Botão de perigo/erro (vermelho)
  danger,

  /// Botão de aviso (amarelo)
  warning,

  /// Botão com contorno apenas
  outline,
}

/// Botão de ícone Neumorphic circular
class CustomNeumorphicIconButton extends StatelessWidget {
  /// Ícone do botão
  final IconData icon;

  /// Callback ao pressionar
  final VoidCallback? onPressed;

  /// Tamanho do botão
  final double size;

  /// Cor do ícone
  final Color? iconColor;

  /// Cor de fundo
  final Color? backgroundColor;

  /// Profundidade Neumorphic
  final double depth;

  /// Indica se está desabilitado
  final bool isDisabled;

  const CustomNeumorphicIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.iconColor,
    this.backgroundColor,
    this.depth = 4.0,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && onPressed != null;

    return SizedBox(
      width: size,
      height: size,
      child: NeumorphicButton(
        onPressed: isEnabled ? onPressed : null,
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: const NeumorphicBoxShape.circle(),
          depth: isEnabled ? depth : 0,
          intensity: isEnabled ? 0.5 : 0.3,
          lightSource: LightSource.topLeft,
          color: backgroundColor ?? AppColors.background,
          shadowLightColor: AppColors.neumorphicLight,
          shadowDarkColor: AppColors.neumorphicDark,
        ),
        padding: EdgeInsets.zero,
        child: Center(
          child: Icon(
            icon,
            color: isEnabled
                ? (iconColor ?? AppColors.primary)
                : AppColors.textTertiary,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// Botão de texto Neumorphic (sem fundo elevado)
class CustomNeumorphicTextButton extends StatelessWidget {
  /// Texto do botão
  final String text;

  /// Callback ao pressionar
  final VoidCallback? onPressed;

  /// Cor do texto
  final Color? textColor;

  /// Ícone opcional
  final IconData? icon;

  /// Indica se está desabilitado
  final bool isDisabled;

  const CustomNeumorphicTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.icon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && onPressed != null;
    final color = isEnabled
        ? (textColor ?? AppColors.primary)
        : AppColors.textTertiary;

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyles.link.copyWith(
              color: color,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating Action Button Neumorphic
class CustomNeumorphicFAB extends StatelessWidget {
  /// Ícone do FAB
  final IconData icon;

  /// Callback ao pressionar
  final VoidCallback? onPressed;

  /// Cor de fundo
  final Color? backgroundColor;

  /// Cor do ícone
  final Color? iconColor;

  /// Tamanho do FAB
  final double size;

  /// Tag para Hero animation
  final String? heroTag;

  const CustomNeumorphicFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 56.0,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: size,
      height: size,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: const NeumorphicBoxShape.circle(),
          depth: 6,
          intensity: 0.6,
          lightSource: LightSource.topLeft,
          color: backgroundColor ?? AppColors.primary,
          shadowLightColor: AppColors.neumorphicLight,
          shadowDarkColor: AppColors.neumorphicDark,
        ),
        padding: EdgeInsets.zero,
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textOnPrimary,
            size: size * 0.5,
          ),
        ),
      ),
    );

    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: button,
      );
    }

    return button;
  }
}
