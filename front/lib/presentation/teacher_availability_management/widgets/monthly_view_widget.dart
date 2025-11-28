import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Monthly calendar view showing booked lessons overlaid on availability
class MonthlyViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> availabilityBlocks;
  final List<Map<String, dynamic>> bookedLessons;

  const MonthlyViewWidget({
    super.key,
    required this.availabilityBlocks,
    required this.bookedLessons,
  });

  @override
  State<MonthlyViewWidget> createState() => _MonthlyViewWidgetState();
}

class _MonthlyViewWidgetState extends State<MonthlyViewWidget> {
  DateTime _selectedMonth = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final days = <DateTime>[];

    for (int i = 0; i < lastDay.day; i++) {
      days.add(firstDay.add(Duration(days: i)));
    }

    return days;
  }

  List<Map<String, dynamic>> _getLessonsForDay(DateTime day) {
    return widget.bookedLessons.where((lesson) {
      final lessonDate = lesson["date"] as DateTime;
      return lessonDate.year == day.year &&
          lessonDate.month == day.month &&
          lessonDate.day == day.day;
    }).toList();
  }

  bool _hasAvailabilityForDay(DateTime day) {
    final dayIndex = day.weekday - 1;
    return widget.availabilityBlocks
        .any((block) => block["dayIndex"] == dayIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _getDaysInMonth();
    final monthName = _getMonthName(_selectedMonth.month);

    return Column(
      children: [
        // Month navigation
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: CustomIconWidget(
                  iconName: 'chevron_left',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              Expanded(
                child: Text(
                  '$monthName ${_selectedMonth.year}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),

        // Legend
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(
                theme,
                'Disponible',
                theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
              _buildLegendItem(
                theme,
                'Réservé',
                theme.colorScheme.secondary.withValues(alpha: 0.2),
              ),
              _buildLegendItem(
                theme,
                'Conflit',
                theme.colorScheme.error.withValues(alpha: 0.2),
              ),
            ],
          ),
        ),

        // Calendar grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(4.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final lessons = _getLessonsForDay(day);
              final hasAvailability = _hasAvailabilityForDay(day);
              final isToday = DateTime.now().year == day.year &&
                  DateTime.now().month == day.month &&
                  DateTime.now().day == day.day;

              return _buildDayCell(
                theme,
                day,
                lessons,
                hasAvailability,
                isToday,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDayCell(
    ThemeData theme,
    DateTime day,
    List<Map<String, dynamic>> lessons,
    bool hasAvailability,
    bool isToday,
  ) {
    Color backgroundColor = theme.colorScheme.surface;
    Color borderColor = theme.dividerColor;

    if (lessons.isNotEmpty && hasAvailability) {
      backgroundColor = theme.colorScheme.secondary.withValues(alpha: 0.2);
      borderColor = theme.colorScheme.secondary;
    } else if (lessons.isNotEmpty && !hasAvailability) {
      backgroundColor = theme.colorScheme.error.withValues(alpha: 0.2);
      borderColor = theme.colorScheme.error;
    } else if (hasAvailability) {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.2);
      borderColor = theme.colorScheme.primary.withValues(alpha: 0.5);
    }

    return InkWell(
      onTap: lessons.isNotEmpty
          ? () => _showLessonsDialog(theme, day, lessons)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isToday ? theme.colorScheme.primary : borderColor,
            width: isToday ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                color: isToday ? theme.colorScheme.primary : null,
              ),
            ),
            if (lessons.isNotEmpty) ...[
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: lessons.isNotEmpty && !hasAvailability
                      ? theme.colorScheme.error
                      : theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${lessons.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLessonsDialog(
    ThemeData theme,
    DateTime day,
    List<Map<String, dynamic>> lessons,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cours du ${day.day}/${day.month}/${day.year}'),
        content: SizedBox(
          width: 80.w,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              final lessonDate = lesson["date"] as DateTime;
              final timeStr =
                  '${lessonDate.hour.toString().padLeft(2, '0')}:${lessonDate.minute.toString().padLeft(2, '0')}';

              return Card(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              lesson["studentName"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6),
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '$timeStr (${lesson["duration"]} min)',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'music_note',
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6),
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            lesson["instrument"] as String,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return months[month - 1];
  }
}
