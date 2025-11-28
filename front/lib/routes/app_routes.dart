import 'package:flutter/material.dart';
import '../presentation/teacher_selection/teacher_selection.dart';
import '../presentation/teacher_dashboard/teacher_dashboard.dart';
import '../presentation/student_dashboard/student_dashboard.dart';
import '../presentation/teacher_availability_management/teacher_availability_management.dart';
import '../presentation/lesson_booking/lesson_booking.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String teacherSelection = '/teacher-selection';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String teacherAvailabilityManagement =
      '/teacher-availability-management';
  static const String lessonBooking = '/lesson-booking';
  static const String adminDashboard = '/admin-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const StudentDashboard(),
    teacherSelection: (context) => const TeacherSelection(),
    teacherDashboard: (context) => const TeacherDashboard(),
    studentDashboard: (context) => const StudentDashboard(),
    teacherAvailabilityManagement: (context) =>
        const TeacherAvailabilityManagement(),
    lessonBooking: (context) => const LessonBooking(),
    adminDashboard: (context) => const AdminDashboard(),
    // TODO: Add your other routes here
  };
}
