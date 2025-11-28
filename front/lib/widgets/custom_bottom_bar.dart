import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Navigation item configuration for the bottom bar
class CustomBottomBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;
  final int? badgeCount;

  const CustomBottomBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
    this.badgeCount,
  });
}

/// User role enum for role-based navigation
enum UserRole {
  student,
  teacher,
  admin,
}

/// Custom bottom navigation bar with role-adaptive content
/// Implements thumb-reachable navigation optimized for mobile usage
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final UserRole userRole;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.userRole,
  });

  /// Get navigation items based on user role
  List<CustomBottomBarItem> _getNavigationItems() {
    switch (userRole) {
      case UserRole.student:
        return [
          CustomBottomBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Accueil',
            route: '/student-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.music_note_outlined,
            activeIcon: Icons.music_note,
            label: 'Instruments',
            route: '/teacher-selection',
          ),
          CustomBottomBarItem(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Professeurs',
            route: '/teacher-selection',
          ),
          CustomBottomBarItem(
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
            label: 'Réservations',
            route: '/lesson-booking',
          ),
          CustomBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profil',
            route: '/student-dashboard',
          ),
        ];

      case UserRole.teacher:
        return [
          CustomBottomBarItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Tableau de bord',
            route: '/teacher-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.event_available_outlined,
            activeIcon: Icons.event_available,
            label: 'Planning',
            route: '/teacher-availability-management',
          ),
          CustomBottomBarItem(
            icon: Icons.schedule_outlined,
            activeIcon: Icons.schedule,
            label: 'Disponibilités',
            route: '/teacher-availability-management',
          ),
          CustomBottomBarItem(
            icon: Icons.book_outlined,
            activeIcon: Icons.book,
            label: 'Cours',
            route: '/lesson-booking',
          ),
          CustomBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profil',
            route: '/teacher-dashboard',
          ),
        ];

      case UserRole.admin:
        return [
          CustomBottomBarItem(
            icon: Icons.admin_panel_settings_outlined,
            activeIcon: Icons.admin_panel_settings,
            label: 'Gestion',
            route: '/admin-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Utilisateurs',
            route: '/admin-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.calendar_month_outlined,
            activeIcon: Icons.calendar_month,
            label: 'Calendrier',
            route: '/lesson-booking',
          ),
          CustomBottomBarItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
            label: 'Statistiques',
            route: '/admin-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: 'Paramètres',
            route: '/admin-dashboard',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _getNavigationItems();

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavigationItem(
                context: context,
                item: items[index],
                index: index,
                isSelected: currentIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required CustomBottomBarItem item,
    required int index,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor!;
    final unselectedColor = theme.bottomNavigationBarTheme.unselectedItemColor!;

    return Expanded(
      child: InkWell(
        onTap: () {
          // Provide haptic feedback for better mobile UX
          HapticFeedback.lightImpact();
          onTap(index);
        },
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with badge support
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      key: ValueKey(isSelected),
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 24,
                    ),
                  ),
                  // Badge indicator
                  if (item.badgeCount != null && item.badgeCount! > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                theme.bottomNavigationBarTheme.backgroundColor!,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          item.badgeCount! > 99 ? '99+' : '${item.badgeCount}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              // Label with animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: (isSelected
                        ? theme.bottomNavigationBarTheme.selectedLabelStyle
                        : theme.bottomNavigationBarTheme.unselectedLabelStyle)!
                    .copyWith(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontSize: 11,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              // Selection indicator
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: 2,
                width: isSelected ? 24 : 0,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example usage widget demonstrating role-based navigation
class CustomBottomBarExample extends StatefulWidget {
  final UserRole userRole;

  const CustomBottomBarExample({
    super.key,
    this.userRole = UserRole.student,
  });

  @override
  State<CustomBottomBarExample> createState() => _CustomBottomBarExampleState();
}

class _CustomBottomBarExampleState extends State<CustomBottomBarExample> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the corresponding route
    final items = _getNavigationItems();
    if (index < items.length) {
      Navigator.pushNamed(context, items[index].route);
    }
  }

  List<CustomBottomBarItem> _getNavigationItems() {
    switch (widget.userRole) {
      case UserRole.student:
        return [
          CustomBottomBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Accueil',
            route: '/student-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.music_note_outlined,
            activeIcon: Icons.music_note,
            label: 'Instruments',
            route: '/teacher-selection',
          ),
          CustomBottomBarItem(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Professeurs',
            route: '/teacher-selection',
          ),
          CustomBottomBarItem(
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
            label: 'Réservations',
            route: '/lesson-booking',
            badgeCount: 2, // Example badge
          ),
          CustomBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profil',
            route: '/student-dashboard',
          ),
        ];

      case UserRole.teacher:
        return [
          CustomBottomBarItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Tableau de bord',
            route: '/teacher-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.event_available_outlined,
            activeIcon: Icons.event_available,
            label: 'Planning',
            route: '/teacher-availability-management',
          ),
          CustomBottomBarItem(
            icon: Icons.schedule_outlined,
            activeIcon: Icons.schedule,
            label: 'Disponibilités',
            route: '/teacher-availability-management',
          ),
          CustomBottomBarItem(
            icon: Icons.book_outlined,
            activeIcon: Icons.book,
            label: 'Cours',
            route: '/lesson-booking',
            badgeCount: 5, // Example badge
          ),
          CustomBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profil',
            route: '/teacher-dashboard',
          ),
        ];

      case UserRole.admin:
        return [
          CustomBottomBarItem(
            icon: Icons.admin_panel_settings_outlined,
            activeIcon: Icons.admin_panel_settings,
            label: 'Gestion',
            route: '/admin-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            label: 'Utilisateurs',
            route: '/admin-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.calendar_month_outlined,
            activeIcon: Icons.calendar_month,
            label: 'Calendrier',
            route: '/lesson-booking',
          ),
          CustomBottomBarItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
            label: 'Statistiques',
            route: '/admin-dashboard',
          ),
          CustomBottomBarItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: 'Paramètres',
            route: '/admin-dashboard',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Current Index: $_currentIndex'),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        userRole: widget.userRole,
      ),
    );
  }
}
