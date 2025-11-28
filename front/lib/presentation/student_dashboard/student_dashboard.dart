import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/lesson_counter_card_widget.dart';
import './widgets/quick_action_cards_widget.dart';
import './widgets/recent_bookings_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock data for student
  final Map<String, dynamic> studentData = {
    "name": "Sophie Martin",
    "profilePhoto":
        "https://img.rocket.new/generatedImages/rocket_gen_img_103b528db-1763293982935.png",
    "profilePhotoSemanticLabel":
        "Young woman with long brown hair smiling at camera, wearing casual white shirt against neutral background",
    "lessonsRemaining": 5,
    "totalLessonsPerMonth": 8,
  };

  // Mock data for recent bookings
  final List<Map<String, dynamic>> recentBookings = [
    {
      "id": 1,
      "teacherName": "Marie Dubois",
      "teacherPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_198f087b3-1763295718469.png",
      "teacherPhotoSemanticLabel":
          "Professional woman with short blonde hair in elegant black attire, smiling warmly in studio setting",
      "instrument": "Piano",
      "date": DateTime(2025, 12, 2, 14, 0),
      "duration": 60,
      "status": "confirmed"
    },
    {
      "id": 2,
      "teacherName": "Jean Lefebvre",
      "teacherPhoto":
          "https://img.rocket.new/generatedImages/rocket_gen_img_11128a371-1763296764772.png",
      "teacherPhotoSemanticLabel":
          "Middle-aged man with short dark hair and beard, wearing navy blue shirt, professional headshot with neutral background",
      "instrument": "Guitare",
      "date": DateTime(2025, 12, 5, 16, 30),
      "duration": 45,
      "status": "confirmed"
    },
    {
      "id": 3,
      "teacherName": "Claire Rousseau",
      "teacherPhoto":
          "https://images.unsplash.com/photo-1646602950743-fdb63d23244f",
      "teacherPhotoSemanticLabel":
          "Young woman with curly brown hair wearing glasses and casual sweater, smiling in bright indoor setting",
      "instrument": "Violon",
      "date": DateTime(2025, 12, 8, 10, 0),
      "duration": 60,
      "status": "pending"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  Future<void> _handleRefresh() async {
    await _loadDashboardData();
  }

  void _handleBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    // Navigate based on index
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/teacher-selection');
        break;
      case 2:
        Navigator.pushNamed(context, '/teacher-selection');
        break;
      case 3:
        Navigator.pushNamed(context, '/lesson-booking');
        break;
      case 4:
        // Profile - stay on dashboard
        break;
    }
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'book':
        Navigator.pushNamed(context, '/lesson-booking');
        break;
      case 'instruments':
        Navigator.pushNamed(context, '/teacher-selection');
        break;
      case 'teachers':
        Navigator.pushNamed(context, '/teacher-selection');
        break;
    }
  }

  void _handleBookingTap(Map<String, dynamic> booking) {
    Navigator.pushNamed(
      context,
      '/lesson-booking',
      arguments: booking,
    );
  }

  void _handleBookingAction(Map<String, dynamic> booking, String action) {
    final theme = Theme.of(context);

    switch (action) {
      case 'cancel':
        _showCancelDialog(booking);
        break;
      case 'reschedule':
        Navigator.pushNamed(
          context,
          '/lesson-booking',
          arguments: {'reschedule': true, 'booking': booking},
        );
        break;
      case 'contact':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contacter ${booking["teacherName"]}'),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        break;
    }
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Annuler le cours',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir annuler ce cours avec ${booking["teacherName"]} ?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                recentBookings.removeWhere((b) => b["id"] == booking["id"]);
                studentData["lessonsRemaining"] =
                    (studentData["lessonsRemaining"] as int) + 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cours annulé avec succès'),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            },
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }

  void _handleNewLesson() {
    Navigator.pushNamed(context, '/lesson-booking');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasBookings = recentBookings.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Mes Cours de Musique',
        variant: CustomAppBarVariant.standard,
        onSearchTap: () {
          Navigator.pushNamed(context, '/teacher-selection');
        },
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notifications'),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
        },
        notificationCount: 2,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                color: theme.colorScheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Header
                      GreetingHeaderWidget(
                        studentName: studentData["name"] as String,
                        profilePhoto: studentData["profilePhoto"] as String,
                        profilePhotoSemanticLabel:
                            studentData["profilePhotoSemanticLabel"] as String,
                      ),

                      SizedBox(height: 2.h),

                      // Lesson Counter Card
                      LessonCounterCardWidget(
                        lessonsRemaining:
                            studentData["lessonsRemaining"] as int,
                        totalLessons:
                            studentData["totalLessonsPerMonth"] as int,
                      ),

                      SizedBox(height: 3.h),

                      // Quick Action Cards
                      QuickActionCardsWidget(
                        onActionTap: _handleQuickAction,
                      ),

                      SizedBox(height: 3.h),

                      // Recent Bookings or Empty State
                      hasBookings
                          ? RecentBookingsWidget(
                              bookings: recentBookings,
                              onBookingTap: _handleBookingTap,
                              onBookingAction: _handleBookingAction,
                            )
                          : EmptyStateWidget(
                              onBookNow: _handleNewLesson,
                            ),

                      SizedBox(height: 2.h),

                      // Last Updated Timestamp
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          'Dernière mise à jour: ${_formatTimestamp(_lastUpdated)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleNewLesson,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onSecondary,
          size: 24,
        ),
        label: Text(
          'Nouveau cours',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        userRole: UserRole.student,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
