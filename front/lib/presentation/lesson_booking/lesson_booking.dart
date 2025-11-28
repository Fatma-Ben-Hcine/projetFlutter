import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import './widgets/booking_confirmation_card_widget.dart';
import './widgets/calendar_widget.dart';
import './widgets/monthly_counter_widget.dart';
import './widgets/teacher_info_card_widget.dart';
import './widgets/time_slot_bottom_sheet_widget.dart';

class LessonBooking extends StatefulWidget {
  const LessonBooking({super.key});

  @override
  State<LessonBooking> createState() => _LessonBookingState();
}

class _LessonBookingState extends State<LessonBooking> {
  // Mock teacher data
  final Map<String, dynamic> teacherData = {
    "id": 1,
    "name": "Sophie Martin",
    "photo":
        "https://img.rocket.new/generatedImages/rocket_gen_img_159d2c8f8-1763294679735.png",
    "semanticLabel":
        "Professional photo of a woman with long brown hair wearing a white blouse, smiling warmly in a bright studio setting",
    "instrument": "Piano",
    "pricePerLesson": 45.0,
    "currency": "€",
  };

  // Booking state
  int remainingLessons = 5;
  final int maxLessonsPerMonth = 8;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDate;
  String? selectedTimeSlot;
  bool isLoading = false;

  // Mock availability data - dates with available time slots
  final Map<DateTime, List<String>> availabilityData = {
    DateTime(2025, 11, 29): ["09:00", "10:30", "14:00", "15:30"],
    DateTime(2025, 11, 30): ["10:00", "11:30", "16:00"],
    DateTime(2025, 12, 2): ["09:00", "10:30", "13:00", "14:30", "16:00"],
    DateTime(2025, 12, 3): ["11:00", "14:00", "15:30"],
    DateTime(2025, 12, 5): ["09:30", "11:00", "13:30", "15:00"],
    DateTime(2025, 12, 6): ["10:00", "14:00", "16:30"],
    DateTime(2025, 12, 9): ["09:00", "10:30", "14:00", "15:30"],
    DateTime(2025, 12, 10): ["11:00", "13:00", "15:00"],
  };

  // Mock booked slots
  final Map<DateTime, List<String>> bookedSlots = {
    DateTime(2025, 11, 29): ["10:30"],
    DateTime(2025, 12, 2): ["14:30"],
    DateTime(2025, 12, 5): ["11:00"],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Réserver un cours',
        variant: CustomAppBarVariant.detail,
        showBackButton: true,
        onBackPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAvailability,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Teacher info card
              TeacherInfoCardWidget(
                teacherData: teacherData,
              ),

              SizedBox(height: 2.h),

              // Monthly lesson counter
              MonthlyCounterWidget(
                remainingLessons: remainingLessons,
                maxLessons: maxLessonsPerMonth,
              ),

              SizedBox(height: 3.h),

              // Calendar widget
              CalendarWidget(
                focusedDay: focusedDay,
                selectedDate: selectedDate,
                availabilityData: availabilityData,
                bookedSlots: bookedSlots,
                onDaySelected: _onDaySelected,
                onPageChanged: _onPageChanged,
              ),

              SizedBox(height: 3.h),

              // Booking confirmation card (shown when date and time selected)
              if (selectedDate != null && selectedTimeSlot != null)
                BookingConfirmationCardWidget(
                  teacherData: teacherData,
                  selectedDate: selectedDate!,
                  selectedTimeSlot: selectedTimeSlot!,
                  onConfirm: _confirmBooking,
                  isLoading: isLoading,
                ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Normalize dates to compare only year, month, and day
    final normalizedSelectedDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    // Check if day has availability
    final hasAvailability = availabilityData.keys.any((date) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      return normalizedDate.isAtSameMomentAs(normalizedSelectedDay);
    });

    if (!hasAvailability) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aucune disponibilité pour cette date'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      this.focusedDay = focusedDay;
      selectedDate = selectedDay;
      selectedTimeSlot = null; // Reset time slot when date changes
    });

    HapticFeedback.selectionClick();
    _showTimeSlotBottomSheet(selectedDay);
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  void _showTimeSlotBottomSheet(DateTime date) {
    // Normalize date for lookup
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Find matching date in availability data
    final matchingDate = availabilityData.keys.firstWhere(
      (d) => DateTime(d.year, d.month, d.day).isAtSameMomentAs(normalizedDate),
      orElse: () => normalizedDate,
    );

    final availableSlots = availabilityData[matchingDate] ?? [];
    final bookedSlotsForDate = bookedSlots[matchingDate] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimeSlotBottomSheetWidget(
        date: date,
        availableSlots: availableSlots,
        bookedSlots: bookedSlotsForDate,
        onSlotSelected: (slot) {
          setState(() {
            selectedTimeSlot = slot;
          });
          Navigator.pop(context);
          HapticFeedback.mediumImpact();
        },
      ),
    );
  }

  Future<void> _confirmBooking() async {
    if (selectedDate == null || selectedTimeSlot == null) return;

    // Check monthly limit
    if (remainingLessons <= 0) {
      HapticFeedback.heavyImpact();
      _showErrorDialog(
        'Limite mensuelle atteinte',
        'Vous avez atteint la limite de 8 cours par mois. Veuillez attendre le mois prochain pour réserver d\'autres cours.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Check for conflicts (simulate)
    final normalizedDate =
        DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
    final matchingDate = bookedSlots.keys.firstWhere(
      (d) => DateTime(d.year, d.month, d.day).isAtSameMomentAs(normalizedDate),
      orElse: () => normalizedDate,
    );

    if (bookedSlots[matchingDate]?.contains(selectedTimeSlot) ?? false) {
      setState(() {
        isLoading = false;
      });
      HapticFeedback.heavyImpact();
      _showErrorDialog(
        'Créneau déjà réservé',
        'Ce créneau horaire a déjà été réservé. Veuillez en choisir un autre.',
      );
      return;
    }

    // Success - update state
    setState(() {
      isLoading = false;
      remainingLessons--;
      // Add to booked slots
      if (bookedSlots[matchingDate] == null) {
        bookedSlots[matchingDate] = [];
      }
      bookedSlots[matchingDate]!.add(selectedTimeSlot!);
    });

    HapticFeedback.heavyImpact();
    _showSuccessDialog();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'fr_FR');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            SizedBox(width: 2.w),
            const Text('Réservation confirmée'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Votre cours a été réservé avec succès !',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context,
                    Icons.calendar_today,
                    'Date',
                    dateFormat.format(selectedDate!),
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    Icons.access_time,
                    'Heure',
                    selectedTimeSlot!,
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    Icons.person,
                    'Professeur',
                    teacherData['name'] as String,
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    Icons.music_note,
                    'Instrument',
                    teacherData['instrument'] as String,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selectedDate = null;
                selectedTimeSlot = null;
              });
            },
            child: const Text('Fermer'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _addToCalendar();
            },
            icon: const Icon(Icons.calendar_month, size: 18),
            label: const Text('Ajouter au calendrier'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 2.w),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _addToCalendar() {
    // This would integrate with system calendar
    // For now, show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cours ajouté au calendrier'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Voir',
          onPressed: () {
            // Open calendar app
          },
        ),
      ),
    );
  }

  Future<void> _refreshAvailability() async {
    // Simulate API call to refresh availability
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // In real app, this would fetch fresh data from API
    });

    HapticFeedback.lightImpact();
  }
}
