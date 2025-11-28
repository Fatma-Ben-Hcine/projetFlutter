import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDate;
  final Map<DateTime, List<String>> availabilityData;
  final Map<DateTime, List<String>> bookedSlots;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDate,
    required this.availabilityData,
    required this.bookedSlots,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          // Calendar header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_month',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Sélectionnez une date',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Calendar
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) {
              if (selectedDate == null) return false;
              return isSameDay(selectedDate, day);
            },
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            locale: 'fr_FR',
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: theme.colorScheme.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.primary,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              weekendStyle: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: theme.textTheme.bodyMedium!,
              weekendTextStyle: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.error,
              ),
              disabledTextStyle: theme.textTheme.bodyMedium!.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, false);
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, true);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, false, isSelected: true);
              },
            ),
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
          ),

          SizedBox(height: 2.h),

          // Legend
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime day, bool isToday,
      {bool isSelected = false}) {
    final theme = Theme.of(context);

    // Normalize date for comparison
    final normalizedDay = DateTime(day.year, day.month, day.day);

    // Check availability
    final hasAvailability = availabilityData.keys.any((date) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      return normalizedDate.isAtSameMomentAs(normalizedDay);
    });

    // Check if fully booked
    final matchingDate = availabilityData.keys.firstWhere(
      (d) => DateTime(d.year, d.month, d.day).isAtSameMomentAs(normalizedDay),
      orElse: () => normalizedDay,
    );

    final availableSlots = availabilityData[matchingDate] ?? [];
    final bookedSlotsForDay = bookedSlots[matchingDate] ?? [];
    final isFullyBooked =
        hasAvailability && availableSlots.length == bookedSlotsForDay.length;

    Color? backgroundColor;
    Color? textColor;
    Widget? indicator;

    if (isSelected) {
      backgroundColor = theme.colorScheme.primary;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.2);
      textColor = theme.colorScheme.primary;
    } else if (hasAvailability && !isFullyBooked) {
      backgroundColor = AppTheme.successLight.withValues(alpha: 0.1);
      textColor = theme.textTheme.bodyMedium?.color;
      indicator = Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          shape: BoxShape.circle,
        ),
      );
    } else if (isFullyBooked) {
      backgroundColor =
          theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1);
      textColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              '${day.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight:
                    isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (indicator != null)
            Positioned(
              bottom: 4,
              child: indicator,
            ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Légende',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildLegendItem(
                context,
                AppTheme.successLight,
                'Disponible',
              ),
              SizedBox(width: 4.w),
              _buildLegendItem(
                context,
                theme.colorScheme.onSurfaceVariant,
                'Complet',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
