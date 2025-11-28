import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Today's schedule card with timeline format and swipe actions
class TodayScheduleCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lessons;
  final Function(int, String) onLessonAction;

  const TodayScheduleCardWidget({
    super.key,
    required this.lessons,
    required this.onLessonAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE d MMMM', 'fr_FR');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aujourd\'hui',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      dateFormat.format(now),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${lessons.length} cours',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lessons timeline
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: lessons.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return _buildLessonItem(context, lesson);
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildLessonItem(BuildContext context, Map<String, dynamic> lesson) {
    final theme = Theme.of(context);
    final lessonId = lesson["id"] as int;
    final studentName = lesson["studentName"] as String;
    final studentAvatar = lesson["studentAvatar"] as String;
    final studentAvatarSemanticLabel =
        lesson["studentAvatarSemanticLabel"] as String;
    final time = lesson["time"] as String;
    final duration = lesson["duration"] as int;
    final instrument = lesson["instrument"] as String;
    final instrumentIcon = lesson["instrumentIcon"] as String;
    final status = lesson["status"] as String;

    final statusColor = status == 'confirmed'
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return Slidable(
      key: ValueKey(lessonId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onLessonAction(lessonId, 'mark_present');
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.check_circle_outline,
            label: 'Présent',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context) {
              onLessonAction(lessonId, 'cancel');
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.cancel_outlined,
            label: 'Annuler',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context) {
              onLessonAction(lessonId, 'contact');
            },
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            icon: Icons.message_outlined,
            label: 'Contact',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          // Navigate to lesson details
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showContextMenu(context, lessonId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Time indicator
              Container(
                width: 16.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      '${duration}min',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical divider
              Container(
                width: 2,
                height: 12.w,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),

              // Student info
              Expanded(
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: studentAvatar,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                          semanticLabel: studentAvatarSemanticLabel,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: instrumentIcon,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                instrument,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Status indicator
              CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, int lessonId) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle_outline',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Marquer présent'),
              onTap: () {
                Navigator.pop(context);
                onLessonAction(lessonId, 'mark_present');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'cancel_outlined',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text('Annuler le cours'),
              onTap: () {
                Navigator.pop(context);
                onLessonAction(lessonId, 'cancel');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message_outlined',
                color: theme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Contacter l\'étudiant'),
              onTap: () {
                Navigator.pop(context);
                onLessonAction(lessonId, 'contact');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info_outline',
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text('Voir les détails'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to details
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
