import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Monthly statistics card with growth indicators
class MonthlyStatisticsWidget extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const MonthlyStatisticsWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalLessons = statistics["totalLessons"] as int;
    final lessonsGrowth = statistics["lessonsGrowth"] as double;
    final revenue = statistics["revenue"] as double;
    final revenueGrowth = statistics["revenueGrowth"] as double;
    final studentCount = statistics["studentCount"] as int;
    final studentGrowth = statistics["studentGrowth"] as double;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Statistiques mensuelles',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Statistics grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                _buildStatItem(
                  context,
                  'Cours enseignés',
                  '$totalLessons',
                  lessonsGrowth,
                  Icons.school_outlined,
                ),
                SizedBox(height: 2.h),
                _buildStatItem(
                  context,
                  'Revenus',
                  '${revenue.toStringAsFixed(2)} €',
                  revenueGrowth,
                  Icons.euro_outlined,
                ),
                SizedBox(height: 2.h),
                _buildStatItem(
                  context,
                  'Étudiants',
                  '$studentCount',
                  studentGrowth,
                  Icons.people_outline,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    double growth,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isPositive = growth >= 0;
    final growthColor =
        isPositive ? const Color(0xFF4A7C59) : const Color(0xFFA0522D);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon
                  .toString()
                  .split('.')
                  .last
                  .replaceAll('IconData(U+', '')
                  .replaceAll(')', ''),
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),

          // Label and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Growth indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: growthColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: isPositive ? 'arrow_upward' : 'arrow_downward',
                  color: growthColor,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${growth.abs().toStringAsFixed(1)}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: growthColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
