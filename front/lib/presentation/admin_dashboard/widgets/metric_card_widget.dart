import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Metric Card Widget
/// Displays key performance metrics with trend indicators
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final String icon;
  final Color color;
  final bool isLoading;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositiveTrend = trend.startsWith('+');

    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: isLoading
            ? _buildLoadingSkeleton(theme)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: icon,
                          color: color,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: isPositiveTrend
                              ? Color(0xFF4A7C59).withValues(alpha: 0.1)
                              : Color(0xFFA0522D).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: isPositiveTrend
                                  ? 'trending_up'
                                  : 'trending_down',
                              color: isPositiveTrend
                                  ? Color(0xFF4A7C59)
                                  : Color(0xFFA0522D),
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              trend,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isPositiveTrend
                                    ? Color(0xFF4A7C59)
                                    : Color(0xFFA0522D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              width: 15.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: 20.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: 30.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
