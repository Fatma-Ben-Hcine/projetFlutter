import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonthlyCounterWidget extends StatelessWidget {
  final int remainingLessons;
  final int maxLessons;

  const MonthlyCounterWidget({
    super.key,
    required this.remainingLessons,
    required this.maxLessons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = remainingLessons / maxLessons;
    final isLow = percentage <= 0.25;
    final isWarning = percentage <= 0.5 && percentage > 0.25;

    Color getStatusColor() {
      if (isLow) return theme.colorScheme.error;
      if (isWarning) return AppTheme.warningLight;
      return theme.colorScheme.primary;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getStatusColor().withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'event_available',
                    color: getStatusColor(),
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Cours restants ce mois',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$remainingLessons/$maxLessons',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: theme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(getStatusColor()),
            ),
          ),

          if (isLow || isWarning) ...[
            SizedBox(height: 1.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: isLow ? 'warning' : 'info',
                  color: getStatusColor(),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    isLow
                        ? 'Attention : Il ne vous reste que $remainingLessons cours ce mois-ci'
                        : 'Vous avez utilisé plus de la moitié de vos cours mensuels',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
