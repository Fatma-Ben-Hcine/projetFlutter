import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/management_section_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/quick_action_button_widget.dart';

/// Admin Dashboard Screen
/// Provides comprehensive oversight of music school operations
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRefreshing = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for dashboard metrics
  final Map<String, dynamic> _dashboardMetrics = {
    "totalStudents": 156,
    "studentsTrend": "+12%",
    "activeTeachers": 24,
    "teachersTrend": "+3",
    "monthlyBookings": 892,
    "bookingsTrend": "+18%",
    "monthlyRevenue": "45,280",
    "revenueTrend": "+22%",
    "currency": "€",
  };

  // Mock data for management sections
  final List<Map<String, dynamic>> _managementSections = [
    {
      "id": 1,
      "title": "Gestion utilisateurs",
      "description": "Gérer les étudiants et professeurs",
      "icon": "people",
      "count": 180,
      "color": Color(0xFF2C5F7C),
      "route": "/admin-dashboard",
    },
    {
      "id": 2,
      "title": "Catalogue instruments",
      "description": "Ajouter, modifier ou supprimer des instruments",
      "icon": "music_note",
      "count": 12,
      "color": Color(0xFF8B4B6B),
      "route": "/admin-dashboard",
    },
    {
      "id": 3,
      "title": "Réservations système",
      "description": "Vue d'ensemble de toutes les réservations",
      "icon": "calendar_today",
      "count": 892,
      "color": Color(0xFF4A7C59),
      "route": "/lesson-booking",
    },
    {
      "id": 4,
      "title": "Rapports mensuels",
      "description": "Accéder aux analyses et statistiques",
      "icon": "analytics",
      "count": 8,
      "color": Color(0xFFB8860B),
      "route": "/admin-dashboard",
    },
  ];

  // Mock data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "type": "approval",
      "title": "Nouveau professeur en attente",
      "message": "Marie Dubois attend l'approbation",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "isRead": false,
    },
    {
      "id": 2,
      "type": "conflict",
      "title": "Conflit de réservation",
      "message": "Deux réservations pour le même créneau",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "isRead": false,
    },
    {
      "id": 3,
      "type": "system",
      "title": "Mise à jour système disponible",
      "message": "Version 2.1.0 prête à installer",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "isRead": true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Données mises à jour'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showQuickActions() {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Actions rapides',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            QuickActionButton(
              icon: 'person_add',
              label: 'Ajouter utilisateur',
              onTap: () {
                Navigator.pop(context);
                _showAddUserDialog();
              },
            ),
            SizedBox(height: 1.h),
            QuickActionButton(
              icon: 'library_music',
              label: 'Nouvel instrument',
              onTap: () {
                Navigator.pop(context);
                _showAddInstrumentDialog();
              },
            ),
            SizedBox(height: 1.h),
            QuickActionButton(
              icon: 'file_download',
              label: 'Exporter rapport',
              onTap: () {
                Navigator.pop(context);
                _exportReport();
              },
            ),
            SizedBox(height: 1.h),
            QuickActionButton(
              icon: 'settings',
              label: 'Paramètres système',
              onTap: () {
                Navigator.pop(context);
                _showSystemSettings();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un utilisateur'),
        content: const Text('Fonctionnalité d\'ajout d\'utilisateur'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utilisateur ajouté')),
              );
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddInstrumentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvel instrument'),
        content: const Text('Fonctionnalité d\'ajout d\'instrument'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Instrument ajouté')),
              );
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rapport exporté avec succès'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSystemSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paramètres système'),
        content: const Text('Fonctionnalité de paramètres système'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      // Mark all as read
                    },
                    child: const Text('Tout marquer comme lu'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => Divider(height: 1.h),
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return _buildNotificationItem(notification);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final theme = Theme.of(context);
    final isRead = notification["isRead"] as bool;

    IconData iconData;
    Color iconColor;

    switch (notification["type"]) {
      case "approval":
        iconData = Icons.person_add;
        iconColor = theme.colorScheme.primary;
        break;
      case "conflict":
        iconData = Icons.warning;
        iconColor = theme.colorScheme.error;
        break;
      case "system":
        iconData = Icons.info;
        iconColor = theme.colorScheme.secondary;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      color: isRead
          ? Colors.transparent
          : theme.colorScheme.primary.withValues(alpha: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconData.codePoint.toRadixString(16),
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification["title"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  notification["message"] as String,
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatTimestamp(notification["timestamp"] as DateTime),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else {
      return 'Il y a ${difference.inDays} j';
    }
  }

  Widget _buildDrawer() {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'admin_panel_settings',
                    color: theme.colorScheme.onPrimary,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Administration',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Tableau de bord',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildDrawerSection(
                    'Utilisateurs',
                    [
                      _DrawerItem('Étudiants', 'school', '/student-dashboard'),
                      _DrawerItem(
                          'Professeurs', 'person', '/teacher-dashboard'),
                      _DrawerItem('Gestion des rôles', 'admin_panel_settings',
                          '/admin-dashboard'),
                    ],
                  ),
                  Divider(height: 2.h),
                  _buildDrawerSection(
                    'Contenu',
                    [
                      _DrawerItem(
                          'Instruments', 'music_note', '/admin-dashboard'),
                      _DrawerItem('Cours', 'book', '/lesson-booking'),
                      _DrawerItem('Horaires', 'schedule',
                          '/teacher-availability-management'),
                    ],
                  ),
                  Divider(height: 2.h),
                  _buildDrawerSection(
                    'Système',
                    [
                      _DrawerItem('Paramètres', 'settings', '/admin-dashboard'),
                      _DrawerItem('Sécurité', 'security', '/admin-dashboard'),
                      _DrawerItem('Sauvegardes', 'backup', '/admin-dashboard'),
                    ],
                  ),
                  Divider(height: 2.h),
                  _buildDrawerSection(
                    'Rapports',
                    [
                      _DrawerItem(
                          'Statistiques', 'analytics', '/admin-dashboard'),
                      _DrawerItem('Finances', 'euro', '/admin-dashboard'),
                      _DrawerItem('Activité', 'timeline', '/admin-dashboard'),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 0),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'logout',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Déconnexion',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<_DrawerItem> items) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ...items.map((item) => ListTile(
              leading: CustomIconWidget(
                iconName: item.icon,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text(item.title),
              onTap: () {
                Navigator.pop(context);
                if (item.route != '/admin-dashboard') {
                  Navigator.pushNamed(context, item.route);
                }
              },
            )),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Déconnecté avec succès')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount =
        (_notifications.where((n) => !(n["isRead"] as bool)).length);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Administration',
        variant: CustomAppBarVariant.standard,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'menu',
            color: theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        onNotificationTap: _showNotifications,
        notificationCount: unreadCount,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showSearchDialog();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metrics Section
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vue d\'ensemble',
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            title: 'Étudiants',
                            value:
                                _dashboardMetrics["totalStudents"].toString(),
                            trend: _dashboardMetrics["studentsTrend"] as String,
                            icon: 'school',
                            color: theme.colorScheme.primary,
                            isLoading: _isRefreshing,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: MetricCard(
                            title: 'Professeurs',
                            value:
                                _dashboardMetrics["activeTeachers"].toString(),
                            trend: _dashboardMetrics["teachersTrend"] as String,
                            icon: 'person',
                            color: theme.colorScheme.secondary,
                            isLoading: _isRefreshing,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.w),
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            title: 'Réservations',
                            value:
                                _dashboardMetrics["monthlyBookings"].toString(),
                            trend: _dashboardMetrics["bookingsTrend"] as String,
                            icon: 'calendar_today',
                            color: Color(0xFF4A7C59),
                            isLoading: _isRefreshing,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: MetricCard(
                            title: 'Revenus',
                            value:
                                '${_dashboardMetrics["monthlyRevenue"]} ${_dashboardMetrics["currency"]}',
                            trend: _dashboardMetrics["revenueTrend"] as String,
                            icon: 'euro',
                            color: Color(0xFFB8860B),
                            isLoading: _isRefreshing,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Management Sections
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Gestion',
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 2.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _managementSections.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final section = _managementSections[index];
                        return ManagementSection(
                          title: section["title"] as String,
                          description: section["description"] as String,
                          icon: section["icon"] as String,
                          count: section["count"] as int,
                          color: section["color"] as Color,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            final route = section["route"] as String;
                            if (route != '/admin-dashboard') {
                              Navigator.pushNamed(context, route);
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickActions,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.floatingActionButtonTheme.foregroundColor ??
              theme.colorScheme.onSecondary,
          size: 24,
        ),
        label: const Text('Actions'),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechercher'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Rechercher utilisateurs, réservations...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recherche: $_searchQuery')),
              );
            },
            child: const Text('Rechercher'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final String title;
  final String icon;
  final String route;

  _DrawerItem(this.title, this.icon, this.route);
}
