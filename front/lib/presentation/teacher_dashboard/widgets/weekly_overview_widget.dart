import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

/// Weekly overview with horizontal calendar strip
class WeeklyOverviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeeklyOverviewWidget({
    super.key,
    required this.weeklyData,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vue hebdomadaire',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Navigate to full calendar
                  },
                  child: Text('Voir tout'),
                ),
              ],
            ),
          ),

          // Horizontal calendar strip
          SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: weeklyData.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final dayData = weeklyData[index];
                final date = dayData["date"] as DateTime;
                final lessonCount = dayData["lessonCount"] as int;
                final isSelected = DateUtils.isSameDay(date, selectedDate);
                final isToday = DateUtils.isSameDay(date, DateTime.now());

                return _buildDateCard(
                  context,
                  date,
                  lessonCount,
                  isSelected,
                  isToday,
                );
              },
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDateCard(
    BuildContext context,
    DateTime date,
    int lessonCount,
    bool isSelected,
    bool isToday,
  ) {
    final theme = Theme.of(context);
    final dayFormat = DateFormat('EEE', 'fr_FR');
    final dateFormat = DateFormat('d');

    final backgroundColor = isSelected
        ? theme.colorScheme.primary
        : isToday
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
            : theme.colorScheme.surface;

    final textColor =
        isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onDateSelected(date);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 18.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday && !isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: isToday && !isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayFormat.format(date).toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              dateFormat.format(date),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.2)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$lessonCount cours',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
