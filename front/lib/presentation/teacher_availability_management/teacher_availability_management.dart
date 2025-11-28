import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/monthly_view_widget.dart';
import './widgets/quick_template_sheet.dart';
import './widgets/weekly_calendar_widget.dart';

/// Teacher Availability Management Screen
/// Allows instructors to set and modify their teaching schedule with efficient mobile controls
class TeacherAvailabilityManagement extends StatefulWidget {
  const TeacherAvailabilityManagement({super.key});

  @override
  State<TeacherAvailabilityManagement> createState() =>
      _TeacherAvailabilityManagementState();
}

class _TeacherAvailabilityManagementState
    extends State<TeacherAvailabilityManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 1;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  // Mock availability data
  final List<Map<String, dynamic>> _availabilityBlocks = [
    {
      "id": 1,
      "day": "Lundi",
      "dayIndex": 0,
      "startTime": "09:00",
      "endTime": "12:00",
      "isRecurring": true,
    },
    {
      "id": 2,
      "day": "Lundi",
      "dayIndex": 0,
      "startTime": "14:00",
      "endTime": "18:00",
      "isRecurring": true,
    },
    {
      "id": 3,
      "day": "Mardi",
      "dayIndex": 1,
      "startTime": "10:00",
      "endTime": "13:00",
      "isRecurring": true,
    },
    {
      "id": 4,
      "day": "Mercredi",
      "dayIndex": 2,
      "startTime": "09:00",
      "endTime": "12:00",
      "isRecurring": true,
    },
    {
      "id": 5,
      "day": "Mercredi",
      "dayIndex": 2,
      "startTime": "15:00",
      "endTime": "19:00",
      "isRecurring": true,
    },
    {
      "id": 6,
      "day": "Jeudi",
      "dayIndex": 3,
      "startTime": "14:00",
      "endTime": "17:00",
      "isRecurring": true,
    },
    {
      "id": 7,
      "day": "Vendredi",
      "dayIndex": 4,
      "startTime": "09:00",
      "endTime": "12:00",
      "isRecurring": true,
    },
    {
      "id": 8,
      "day": "Samedi",
      "dayIndex": 5,
      "startTime": "10:00",
      "endTime": "14:00",
      "isRecurring": false,
    },
  ];

  // Mock booked lessons data
  final List<Map<String, dynamic>> _bookedLessons = [
    {
      "id": 1,
      "studentName": "Marie Dubois",
      "date": DateTime(2025, 11, 28, 10, 0),
      "duration": 60,
      "instrument": "Piano",
    },
    {
      "id": 2,
      "studentName": "Pierre Martin",
      "date": DateTime(2025, 11, 28, 15, 0),
      "duration": 60,
      "instrument": "Guitare",
    },
    {
      "id": 3,
      "studentName": "Sophie Laurent",
      "date": DateTime(2025, 11, 29, 11, 0),
      "duration": 60,
      "instrument": "Violon",
    },
    {
      "id": 4,
      "studentName": "Lucas Bernard",
      "date": DateTime(2025, 11, 30, 16, 0),
      "duration": 60,
      "instrument": "Piano",
    },
  ];

  // Weekday toggle states
  final Map<int, bool> _weekdayEnabled = {
    0: true, // Lundi
    1: true, // Mardi
    2: true, // Mercredi
    3: true, // Jeudi
    4: true, // Vendredi
    5: true, // Samedi
    6: false, // Dimanche
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/teacher-dashboard');
        break;
      case 1:
        // Current screen
        break;
      case 2:
        Navigator.pushNamed(context, '/teacher-availability-management');
        break;
      case 3:
        Navigator.pushNamed(context, '/lesson-booking');
        break;
      case 4:
        Navigator.pushNamed(context, '/teacher-dashboard');
        break;
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate save operation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSaving = false;
      _hasUnsavedChanges = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Disponibilités enregistrées avec succès'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _cancelChanges() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Annuler les modifications'),
          content: const Text(
              'Voulez-vous vraiment annuler vos modifications non enregistrées ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Oui'),
            ),
          ],
        ),
      );

      if (shouldDiscard == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _refreshAvailability() async {
    HapticFeedback.lightImpact();

    // Simulate refresh operation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Disponibilités synchronisées'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showQuickTemplates() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickTemplateSheet(
        onTemplateSelected: (template) {
          setState(() {
            _hasUnsavedChanges = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Modèle "$template" appliqué'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _copyPreviousWeek() {
    HapticFeedback.mediumImpact();
    setState(() {
      _hasUnsavedChanges = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Semaine précédente copiée'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addAvailabilityBlock(int dayIndex, String day) {
    HapticFeedback.lightImpact();
    setState(() {
      _hasUnsavedChanges = true;
      _availabilityBlocks.add({
        "id": _availabilityBlocks.length + 1,
        "day": day,
        "dayIndex": dayIndex,
        "startTime": "09:00",
        "endTime": "10:00",
        "isRecurring": true,
      });
    });
  }

  void _editAvailabilityBlock(Map<String, dynamic> block) {
    HapticFeedback.lightImpact();
    // Show edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la disponibilité'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Jour: ${block["day"]}'),
            const SizedBox(height: 8),
            Text('Horaire: ${block["startTime"]} - ${block["endTime"]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _hasUnsavedChanges = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Disponibilité modifiée'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _deleteAvailabilityBlock(Map<String, dynamic> block) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la disponibilité'),
        content: Text(
            'Voulez-vous vraiment supprimer cette disponibilité ?\n\n${block["day"]} ${block["startTime"]} - ${block["endTime"]}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _hasUnsavedChanges = true;
                _availabilityBlocks.remove(block);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Disponibilité supprimée'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Supprimer',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _duplicateAvailabilityBlock(Map<String, dynamic> block) {
    HapticFeedback.lightImpact();
    setState(() {
      _hasUnsavedChanges = true;
      _availabilityBlocks.add({
        "id": _availabilityBlocks.length + 1,
        "day": block["day"],
        "dayIndex": block["dayIndex"],
        "startTime": block["startTime"],
        "endTime": block["endTime"],
        "isRecurring": block["isRecurring"],
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Disponibilité dupliquée'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleWeekday(int dayIndex) {
    HapticFeedback.lightImpact();
    setState(() {
      _hasUnsavedChanges = true;
      _weekdayEnabled[dayIndex] = !(_weekdayEnabled[dayIndex] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gestion des disponibilités',
        variant: CustomAppBarVariant.standard,
        showBackButton: true,
        onBackPressed: _cancelChanges,
        actions: [
          if (_hasUnsavedChanges)
            TextButton(
              onPressed: _cancelChanges,
              child: Text(
                'Annuler',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: _isSaving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Enregistrer',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Semaine'),
            Tab(text: 'Mois'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAvailability,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Weekly view
            WeeklyCalendarWidget(
              availabilityBlocks: _availabilityBlocks,
              weekdayEnabled: _weekdayEnabled,
              onAddBlock: _addAvailabilityBlock,
              onEditBlock: _editAvailabilityBlock,
              onDeleteBlock: _deleteAvailabilityBlock,
              onDuplicateBlock: _duplicateAvailabilityBlock,
              onToggleWeekday: _toggleWeekday,
            ),
            // Monthly view
            MonthlyViewWidget(
              availabilityBlocks: _availabilityBlocks,
              bookedLessons: _bookedLessons,
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  onPressed: _showQuickTemplates,
                  icon: CustomIconWidget(
                    iconName: 'schedule',
                    color: theme.colorScheme.onSecondary,
                    size: 20,
                  ),
                  label: const Text('Modèles rapides'),
                  backgroundColor: theme.colorScheme.secondary,
                ),
                SizedBox(height: 2.h),
                FloatingActionButton.extended(
                  onPressed: _copyPreviousWeek,
                  icon: CustomIconWidget(
                    iconName: 'content_copy',
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: const Text('Copier semaine'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              ],
            )
          : null,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        userRole: UserRole.teacher,
      ),
    );
  }
}
