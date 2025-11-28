import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './availability_block_widget.dart';

/// Weekly calendar view displaying availability blocks
class WeeklyCalendarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> availabilityBlocks;
  final Map<int, bool> weekdayEnabled;
  final Function(int, String) onAddBlock;
  final Function(Map<String, dynamic>) onEditBlock;
  final Function(Map<String, dynamic>) onDeleteBlock;
  final Function(Map<String, dynamic>) onDuplicateBlock;
  final Function(int) onToggleWeekday;

  const WeeklyCalendarWidget({
    super.key,
    required this.availabilityBlocks,
    required this.weekdayEnabled,
    required this.onAddBlock,
    required this.onEditBlock,
    required this.onDeleteBlock,
    required this.onDuplicateBlock,
    required this.onToggleWeekday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: weekdays.length,
      itemBuilder: (context, index) {
        final day = weekdays[index];
        final dayBlocks = availabilityBlocks
            .where((block) => block["dayIndex"] == index)
            .toList();
        final isEnabled = weekdayEnabled[index] ?? false;

        return Card(
          margin: EdgeInsets.only(bottom: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day header with toggle
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        day,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? theme.colorScheme.primary
                              : theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Switch(
                      value: isEnabled,
                      onChanged: (value) => onToggleWeekday(index),
                    ),
                  ],
                ),
              ),

              // Availability blocks
              if (isEnabled) ...[
                if (dayBlocks.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Center(
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'event_busy',
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.3),
                            size: 48,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Aucune disponibilité',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          OutlinedButton.icon(
                            onPressed: () => onAddBlock(index, day),
                            icon: CustomIconWidget(
                              iconName: 'add',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            label: const Text('Ajouter une disponibilité'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        ...dayBlocks.map((block) => AvailabilityBlockWidget(
                              block: block,
                              onEdit: () => onEditBlock(block),
                              onDelete: () => onDeleteBlock(block),
                              onDuplicate: () => onDuplicateBlock(block),
                            )),
                        SizedBox(height: 2.h),
                        OutlinedButton.icon(
                          onPressed: () => onAddBlock(index, day),
                          icon: CustomIconWidget(
                            iconName: 'add',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          label: const Text('Ajouter une disponibilité'),
                        ),
                      ],
                    ),
                  ),
              ] else
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Center(
                    child: Text(
                      'Jour désactivé',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
