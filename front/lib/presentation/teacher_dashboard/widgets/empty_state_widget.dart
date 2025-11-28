import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty state widget when no lessons are scheduled
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onManageAvailability;

  const EmptyStateWidget({
    super.key,
    required this.onManageAvailability,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.primary,
                  size: 80,
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Title
            Text(
              'Aucun cours prévu',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Description
            Text(
              'Définissez vos disponibilités pour permettre aux étudiants de réserver des cours avec vous.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // CTA Button
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onManageAvailability();
              },
              icon: CustomIconWidget(
                iconName: 'calendar_month',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Définir mes disponibilités'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
            SizedBox(height: 2.h),

            // Secondary action
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Navigate to profile
              },
              child: Text('Modifier mon profil'),
            ),
          ],
        ),
      ),
    );
  }
}
