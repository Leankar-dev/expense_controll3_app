import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  final Widget? titleWidget;

  final bool centerTitle;

  final bool showBackButton;

  final VoidCallback? onBackPressed;

  final List<Widget>? actions;

  final Widget? leading;

  final Color? backgroundColor;

  final double elevation;

  final bool transparent;

  final Brightness? statusBarBrightness;

  final double height;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
    this.transparent = false,
    this.statusBarBrightness,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final showBack = showBackButton && canPop && leading == null;

    return AppBar(
      backgroundColor: transparent
          ? Colors.transparent
          : (backgroundColor ?? AppColors.background),
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: statusBarBrightness ?? Brightness.dark,
        statusBarBrightness: statusBarBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      leading: leading ?? (showBack ? _buildBackButton(context) : null),
      title: titleWidget ?? _buildTitle(),
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8),
            ]
          : null,
    );
  }

  Widget? _buildTitle() {
    if (title == null) return null;

    return Text(
      title!,
      style: TextStyles.appBarTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: NeumorphicButton(
            onPressed: () {
              if (onBackPressed != null) {
                onBackPressed!();
              } else {
                Navigator.of(context).pop();
              }
            },
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: const NeumorphicBoxShape.circle(),
              depth: 3,
              intensity: 0.5,
              lightSource: LightSource.topLeft,
              color: backgroundColor ?? AppColors.background,
              shadowLightColor: AppColors.neumorphicLight,
              shadowDarkColor: AppColors.neumorphicDark,
            ),
            padding: EdgeInsets.zero,
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSliverAppBar extends StatelessWidget {
  final String? title;

  final Widget? titleWidget;

  final Widget? expandedWidget;

  final double expandedHeight;

  final double collapsedHeight;

  final bool showTitleWhenCollapsed;

  final bool showBackButton;

  final List<Widget>? actions;

  final bool floating;

  final bool pinned;

  final Color? backgroundColor;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.expandedWidget,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight,
    this.showTitleWhenCollapsed = true,
    this.showBackButton = true,
    this.actions,
    this.floating = false,
    this.pinned = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      floating: floating,
      pinned: pinned,
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton && canPop ? _buildBackButton(context) : null,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: showTitleWhenCollapsed
            ? Text(
                title ?? '',
                style: TextStyles.appBarTitle.copyWith(fontSize: 16),
              )
            : null,
        background: expandedWidget ?? _buildDefaultBackground(),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8),
      child: SizedBox(
        width: 40,
        height: 40,
        child: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: const NeumorphicBoxShape.circle(),
            depth: 3,
            intensity: 0.5,
            color: AppColors.background.withValues(alpha: 0.9),
            shadowLightColor: AppColors.neumorphicLight,
            shadowDarkColor: AppColors.neumorphicDark,
          ),
          padding: EdgeInsets.zero,
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child:
            titleWidget ??
            Text(
              title ?? '',
              style: TextStyles.headlineMedium.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
      ),
    );
  }
}

class AppBarActionButton extends StatelessWidget {
  final IconData icon;

  final VoidCallback? onPressed;

  final Color? iconColor;

  final double iconSize;

  final bool useNeumorphic;

  final int badgeCount;

  const AppBarActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize = 22,
    this.useNeumorphic = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final button = useNeumorphic
        ? _buildNeumorphicButton()
        : _buildStandardButton();

    if (badgeCount > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
                style: TextStyles.badge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }

  Widget _buildNeumorphicButton() {
    return SizedBox(
      width: 40,
      height: 40,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: const NeumorphicBoxShape.circle(),
          depth: 3,
          intensity: 0.5,
          color: AppColors.background,
          shadowLightColor: AppColors.neumorphicLight,
          shadowDarkColor: AppColors.neumorphicDark,
        ),
        padding: EdgeInsets.zero,
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _buildStandardButton() {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
        size: iconSize,
      ),
      splashRadius: 24,
    );
  }
}

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Brightness? statusBarBrightness;

  const TransparentAppBar({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
    this.statusBarBrightness,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      transparent: true,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      statusBarBrightness: statusBarBrightness,
    );
  }
}
