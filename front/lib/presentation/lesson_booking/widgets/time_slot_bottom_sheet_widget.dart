import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimeSlotBottomSheetWidget extends StatelessWidget {
  final DateTime date;
  final List<String> availableSlots;
  final List<String> bookedSlots;
  final Function(String) onSlotSelected;

  const TimeSlotBottomSheetWidget({
    super.key,
    required this.date,
    required this.availableSlots,
    required this.bookedSlots,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 2.h),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Créneaux disponibles',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  dateFormat.format(date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Time slots grid
          Container(
            constraints: BoxConstraints(maxHeight: 50.h),
            child: availableSlots.isEmpty
                ? _buildEmptyState(context)
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: availableSlots.map((slot) {
                        final isBooked = bookedSlots.contains(slot);
                        return _buildTimeSlotChip(context, slot, isBooked);
                      }).toList(),
                    ),
                  ),
          ),

          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildTimeSlotChip(BuildContext context, String slot, bool isBooked) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isBooked
          ? null
          : () {
              HapticFeedback.selectionClick();
              onSlotSelected(slot);
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 28.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isBooked
              ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1)
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isBooked
                ? theme.dividerColor
                : theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isBooked ? 'block' : 'access_time',
              color: isBooked
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.primary,
              size: 18,
            ),
            SizedBox(width: 1.w),
            Flexible(
              child: Text(
                slot,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isBooked
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  decoration: isBooked ? TextDecoration.lineThrough : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'event_busy',
              color: theme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Aucun créneau disponible',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Veuillez sélectionner une autre date',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
