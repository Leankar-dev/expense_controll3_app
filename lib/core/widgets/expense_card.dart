import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/text_styles.dart';
import '../utils/formatters.dart';

class ExpenseCard extends StatelessWidget {
  final String id;

  final double amount;

  final String category;

  final String? categoryIcon;

  final Color? categoryColor;

  final String description;

  final DateTime date;

  final String? paymentMethod;

  final bool isIncome;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final VoidCallback? onDismiss;

  final bool dismissible;

  final bool isSelected;

  const ExpenseCard({
    super.key,
    required this.id,
    required this.amount,
    required this.category,
    this.categoryIcon,
    this.categoryColor,
    required this.description,
    required this.date,
    this.paymentMethod,
    required this.isIncome,
    this.onTap,
    this.onLongPress,
    this.onDismiss,
    this.dismissible = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Hero(
      tag: 'transaction_$id',
      child: Material(
        color: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(AppTheme.radiusLarge),
            ),
            depth: isSelected ? 1 : 4,
            intensity: 0.5,
            lightSource: LightSource.topLeft,
            color: isSelected
                ? AppColors.primaryLight.withValues(alpha: 0.3)
                : AppColors.background,
            shadowLightColor: AppColors.neumorphicLight,
            shadowDarkColor: AppColors.neumorphicDark,
            border: isSelected
                ? const NeumorphicBorder(
                    color: AppColors.primary,
                    width: 2,
                  )
                : const NeumorphicBorder.none(),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildCategoryIcon(),
                  const SizedBox(width: 14),

                  Expanded(
                    child: _buildInfo(),
                  ),

                  _buildAmount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (dismissible && onDismiss != null) {
      card = Dismissible(
        key: Key('dismissible_$id'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismiss?.call(),
        confirmDismiss: (_) => _confirmDismiss(context),
        background: _buildDismissBackground(),
        child: card,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: card,
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: (categoryColor ?? AppColors.getCategoryColor(category))
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: categoryIcon != null
            ? Text(
                categoryIcon!,
                style: const TextStyle(fontSize: 22),
              )
            : Icon(
                _getCategoryIconData(),
                color: categoryColor ?? AppColors.getCategoryColor(category),
                size: 24,
              ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          description,
          style: TextStyles.cardTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (categoryColor ?? AppColors.getCategoryColor(category))
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                category,
                style: TextStyles.labelSmall.copyWith(
                  color: categoryColor ?? AppColors.getCategoryColor(category),
                ),
              ),
            ),
            const SizedBox(width: 8),

            Text(
              Formatters.formatRelativeDate(date),
              style: TextStyles.listItemDescription,
            ),
          ],
        ),

        if (paymentMethod != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                _getPaymentMethodIcon(),
                size: 12,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                paymentMethod!,
                style: TextStyles.listItemDescription,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isIncome
              ? Formatters.formatIncome(amount)
              : Formatters.formatExpense(amount),
          style: TextStyles.currencySmall.copyWith(
            color: isIncome ? AppColors.income : AppColors.expense,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
          size: 16,
          color: isIncome ? AppColors.income : AppColors.expense,
        ),
      ],
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete_outline,
        color: AppColors.textOnDark,
        size: 28,
      ),
    );
  }

  Future<bool> _confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminar transação'),
            content: const Text(
              'Tem a certeza que deseja eliminar esta transação?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  IconData _getCategoryIconData() {
    return switch (category.toLowerCase()) {
      'alimentação' => Icons.restaurant,
      'transporte' => Icons.directions_car,
      'saúde' => Icons.medical_services,
      'lazer' => Icons.sports_esports,
      'habitação' => Icons.home,
      'educação' => Icons.school,
      'compras' => Icons.shopping_bag,
      _ => Icons.category,
    };
  }

  IconData _getPaymentMethodIcon() {
    return switch (paymentMethod?.toLowerCase()) {
      'cartão de crédito' => Icons.credit_card,
      'cartão de débito' => Icons.credit_card,
      'mbway' => Icons.phone_android,
      'pix' => Icons.pix,
      'dinheiro' => Icons.money,
      _ => Icons.payment,
    };
  }
}

class ExpenseCardCompact extends StatelessWidget {
  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final bool isIncome;
  final VoidCallback? onTap;

  const ExpenseCardCompact({
    super.key,
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.isIncome,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: isIncome ? AppColors.income : AppColors.expense,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    description,
                    style: TextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$category • ${Formatters.formatDateShort(date)}',
                    style: TextStyles.listItemDescription,
                  ),
                ],
              ),
            ),

            Text(
              isIncome
                  ? Formatters.formatIncome(amount)
                  : Formatters.formatExpense(amount),
              style: TextStyles.bodyMedium.copyWith(
                color: isIncome ? AppColors.income : AppColors.expense,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseGroupHeader extends StatelessWidget {
  final String title;
  final double totalAmount;
  final bool isIncome;

  const ExpenseGroupHeader({
    super.key,
    required this.title,
    required this.totalAmount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            Formatters.formatCurrency(totalAmount),
            style: TextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
