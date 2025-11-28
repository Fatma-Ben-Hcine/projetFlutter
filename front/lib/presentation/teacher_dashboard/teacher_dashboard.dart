import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/header_section_widget.dart';
import './widgets/monthly_statistics_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/today_schedule_card_widget.dart';
import './widgets/weekly_overview_widget.dart';

/// Teacher Dashboard Screen
/// Enables efficient schedule management and student interaction for music instructors
class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  // Mock teacher data
  final Map<String, dynamic> _teacherData = {
    "id": 1,
    "name": "Sophie Martin",
    "specializations": ["Piano", "Solfège"],
    "notificationCount": 3,
    "avatar":
        "https://img.rocket.new/generatedImages/rocket_gen_img_103b528db-1763293982935.png",
    "avatarSemanticLabel":
        "Professional photo of a woman with brown hair wearing a white blouse, smiling at the camera against a neutral background",
  };

  // Mock today's lessons
  final List<Map<String, dynamic>> _todayLessons = [
    {
      "id": 1,
      "studentName": "Lucas Dubois",
      "studentAvatar":
          "https://images.unsplash.com/photo-1500677404910-8a5f28009d75",
      "studentAvatarSemanticLabel":
          "Young man with short brown hair wearing a grey t-shirt, smiling outdoors",
      "time": "09:00",
      "duration": 60,
      "instrument": "Piano",
      "instrumentIcon": "piano",
      "status": "confirmed",
    },
    {
      "id": 2,
      "studentName": "Emma Rousseau",
      "studentAvatar":
          "https://images.unsplash.com/photo-1552334588-6c2511e9f2cf",
      "studentAvatarSemanticLabel":
          "Young woman with long blonde hair wearing a denim jacket, smiling in natural lighting",
      "time": "11:00",
      "duration": 45,
      "instrument": "Solfège",
      "instrumentIcon": "music_note",
      "status": "confirmed",
    },
    {
      "id": 3,
      "studentName": "Thomas Bernard",
      "studentAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_196b228cd-1763296925913.png",
      "studentAvatarSemanticLabel":
          "Man with short dark hair and beard wearing a black shirt, professional headshot",
      "time": "14:30",
      "duration": 60,
      "instrument": "Piano",
      "instrumentIcon": "piano",
      "status": "pending",
    },
    {
      "id": 4,
      "studentName": "Chloé Petit",
      "studentAvatar":
          "https://images.unsplash.com/photo-1649963383990-eec337af5f08",
      "studentAvatarSemanticLabel":
          "Young woman with curly brown hair wearing a striped shirt, smiling outdoors",
      "time": "16:00",
      "duration": 45,
      "instrument": "Piano",
      "instrumentIcon": "piano",
      "status": "confirmed",
    },
  ];

  // Mock weekly data
  final List<Map<String, dynamic>> _weeklyData = [
    {
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "lessonCount": 4,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "lessonCount": 5,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "lessonCount": 3,
    },
    {
      "date": DateTime.now(),
      "lessonCount": 4,
    },
    {
      "date": DateTime.now().add(const Duration(days: 1)),
      "lessonCount": 6,
    },
    {
      "date": DateTime.now().add(const Duration(days: 2)),
      "lessonCount": 4,
    },
    {
      "date": DateTime.now().add(const Duration(days: 3)),
      "lessonCount": 5,
    },
  ];

  // Mock monthly statistics
  final Map<String, dynamic> _monthlyStats = {
    "totalLessons": 87,
    "lessonsGrowth": 12.5,
    "revenue": 2610.00,
    "revenueGrowth": 8.3,
    "studentCount": 24,
    "studentGrowth": 4.2,
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    HapticFeedback.mediumImpact();
    await _loadDashboardData();
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    // Navigate based on index
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/teacher-availability-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/teacher-availability-management');
        break;
      case 3:
        Navigator.pushNamed(context, '/lesson-booking');
        break;
      case 4:
        // Profile - stay on current screen
        break;
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    HapticFeedback.selectionClick();
    // Load lessons for selected date
  }

  void _onLessonAction(int lessonId, String action) {
    HapticFeedback.mediumImpact();
    final theme = Theme.of(context);

    String message = '';
    switch (action) {
      case 'mark_present':
        message = 'Présence marquée';
        break;
      case 'cancel':
        message = 'Cours annulé';
        break;
      case 'contact':
        message = 'Contacter l\'étudiant';
        break;
      default:
        message = 'Action effectuée';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onManageAvailability() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/teacher-availability-management');
  }

  void _onQuickAction(String action) {
    HapticFeedback.lightImpact();

    switch (action) {
      case 'edit_profile':
        // Navigate to profile edit
        break;
      case 'view_requests':
        // Navigate to requests
        break;
      case 'lesson_history':
        Navigator.pushNamed(context, '/lesson-booking');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLessons = _todayLessons.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: HeaderSectionWidget(
                  teacherName: _teacherData["name"] as String,
                  specializations:
                      (_teacherData["specializations"] as List).cast<String>(),
                  notificationCount: _teacherData["notificationCount"] as int,
                  avatarUrl: _teacherData["avatar"] as String,
                  avatarSemanticLabel:
                      _teacherData["avatarSemanticLabel"] as String,
                ),
              ),

              // Content based on lessons availability
              if (_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              else if (!hasLessons)
                SliverFillRemaining(
                  child: EmptyStateWidget(
                    onManageAvailability: _onManageAvailability,
                  ),
                )
              else ...[
                // Today's Schedule Card
                SliverToBoxAdapter(
                  child: TodayScheduleCardWidget(
                    lessons: _todayLessons,
                    onLessonAction: _onLessonAction,
                  ),
                ),

                // Weekly Overview
                SliverToBoxAdapter(
                  child: WeeklyOverviewWidget(
                    weeklyData: _weeklyData,
                    selectedDate: _selectedDate,
                    onDateSelected: _onDateSelected,
                  ),
                ),

                // Monthly Statistics
                SliverToBoxAdapter(
                  child: MonthlyStatisticsWidget(
                    statistics: _monthlyStats,
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: QuickActionsWidget(
                    onActionTap: _onQuickAction,
                  ),
                ),

                // Bottom spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.h),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: hasLessons
          ? FloatingActionButton.extended(
              onPressed: _onManageAvailability,
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                color: theme.colorScheme.onSecondary,
                size: 20,
              ),
              label: Text(
                'Gérer disponibilités',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              backgroundColor: theme.colorScheme.secondary,
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
