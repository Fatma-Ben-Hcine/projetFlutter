import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String instrument;
  final VoidCallback onChangeInstrument;

  const EmptyStateWidget({
    super.key,
    required this.instrument,
    required this.onChangeInstrument,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'music_note',
                  color: theme.colorScheme.primary,
                  size: 80,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Aucun professeur disponible',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              instrument.isNotEmpty
                  ? 'Nous n\'avons pas encore de professeur de $instrument disponible.\nEssayez un autre instrument ou revenez plus tard.'
                  : 'Aucun professeur ne correspond à votre recherche.\nEssayez de modifier vos critères de recherche.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (instrument.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onChangeInstrument();
                  },
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: const Text('Choisir un autre instrument'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            SizedBox(height: 2.h),
            OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/student-dashboard');
              },
              icon: CustomIconWidget(
                iconName: 'home',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              label: const Text('Retour à l\'accueil'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
