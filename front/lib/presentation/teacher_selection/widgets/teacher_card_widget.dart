import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TeacherCardWidget extends StatelessWidget {
  final Map<String, dynamic> teacher;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;
  final VoidCallback onBookLesson;

  const TeacherCardWidget({
    super.key,
    required this.teacher,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
    required this.onBookLesson,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = teacher["isAvailable"] as bool;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(teacher["id"]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onTap();
              },
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              icon: Icons.person,
              label: 'Profil',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onBookLesson();
              },
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              icon: Icons.calendar_today,
              label: 'Réserver',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onFavoriteToggle();
              },
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              label: 'Favoris',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            _showContextMenu(context, theme);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileImage(theme),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildTeacherInfo(theme, isAvailable),
                  ),
                  _buildFavoriteButton(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(ThemeData theme) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomImageWidget(
          imageUrl: teacher["profileImage"] as String,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
          semanticLabel: teacher["semanticLabel"] as String,
        ),
      ),
    );
  }

  Widget _buildTeacherInfo(ThemeData theme, bool isAvailable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                teacher["name"] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        _buildInstrumentBadge(theme),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'star',
              color: Colors.amber,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              '${teacher["rating"]} (${teacher["totalReviews"]} avis)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'work',
              color: theme.textTheme.bodySmall?.color,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              '${teacher["experience"]} ans',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 1.h),
        _buildAvailabilityStatus(theme, isAvailable),
        SizedBox(height: 0.5.h),
        Text(
          teacher["hourlyRate"] as String,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInstrumentBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'music_note',
            color: theme.colorScheme.primary,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            teacher["instrument"] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityStatus(ThemeData theme, bool isAvailable) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            isAvailable
                ? 'Disponible - ${teacher["nextAvailableSlot"]}'
                : 'Occupé - ${teacher["nextAvailableSlot"]}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isAvailable ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(ThemeData theme) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: isFavorite ? 'favorite' : 'favorite_border',
        color: isFavorite
            ? theme.colorScheme.error
            : theme.textTheme.bodySmall?.color,
        size: 24,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        onFavoriteToggle();
      },
    );
  }

  void _showContextMenu(BuildContext context, ThemeData theme) {
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
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Voir profil complet',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calendar_today',
                color: theme.colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Réserver un cours',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onBookLesson();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: isFavorite ? 'favorite' : 'favorite_border',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onFavoriteToggle();
              },
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}
