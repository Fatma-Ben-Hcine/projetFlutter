import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Bottom sheet with quick availability templates
class QuickTemplateSheet extends StatelessWidget {
  final Function(String) onTemplateSelected;

  const QuickTemplateSheet({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final templates = [
      {
        "name": "Matinées seulement",
        "description": "Lundi à Vendredi, 09:00 - 12:00",
        "icon": "wb_sunny",
      },
      {
        "name": "Après-midi",
        "description": "Lundi à Vendredi, 14:00 - 18:00",
        "icon": "wb_twilight",
      },
      {
        "name": "Soirées",
        "description": "Lundi à Vendredi, 18:00 - 21:00",
        "icon": "nights_stay",
      },
      {
        "name": "Week-end complet",
        "description": "Samedi et Dimanche, 10:00 - 18:00",
        "icon": "weekend",
      },
      {
        "name": "Journée complète",
        "description": "Lundi à Vendredi, 09:00 - 18:00",
        "icon": "schedule",
      },
      {
        "name": "Flexible",
        "description": "Tous les jours, horaires variables",
        "icon": "all_inclusive",
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Modèles rapides',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.textTheme.bodyMedium?.color,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Templates list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index] as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                        onTemplateSelected(template["name"] as String);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomIconWidget(
                                iconName: template["icon"] as String,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template["name"] as String,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    template["description"] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'arrow_forward_ios',
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.3),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
