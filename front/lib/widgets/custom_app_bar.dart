import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different contexts
enum CustomAppBarVariant {
  standard,
  search,
  profile,
  detail,
}

/// Custom app bar with role-adaptive content and contextual actions
/// Implements minimal elevation design with clean visual hierarchy
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? flexibleSpace;
  final String? subtitle;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final int? notificationCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 1.0,
    this.centerTitle = false,
    this.flexibleSpace,
    this.subtitle,
    this.onSearchTap,
    this.onNotificationTap,
    this.notificationCount,
  });

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      elevation: elevation,
      shadowColor: appBarTheme.shadowColor,
      centerTitle: centerTitle,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.search:
        return InkWell(
          onTap: onSearchTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 20,
                  color:
                      theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rechercher...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case CustomAppBarVariant.profile:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.appBarTheme.titleTextStyle,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.appBarTheme.foregroundColor?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        );

      case CustomAppBarVariant.detail:
        return Text(
          title,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        );

      case CustomAppBarVariant.standard:
      default:
        return Text(
          title,
          style: theme.appBarTheme.titleTextStyle,
        );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
        tooltip: 'Retour',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> actionWidgets = [];

    // Add search action for standard variant
    if (variant == CustomAppBarVariant.standard && onSearchTap != null) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            HapticFeedback.lightImpact();
            onSearchTap!();
          },
          tooltip: 'Rechercher',
        ),
      );
    }

    // Add notification action with badge
    if (onNotificationTap != null) {
      actionWidgets.add(
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                onNotificationTap!();
              },
              tooltip: 'Notifications',
            ),
            if (notificationCount != null && notificationCount! > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.appBarTheme.backgroundColor ??
                          theme.colorScheme.surface,
                      width: 1.5,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount! > 9 ? '9+' : '$notificationCount',
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
      );
    }

    // Add custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }
}

/// Example usage demonstrating different app bar variants
class CustomAppBarExample extends StatelessWidget {
  const CustomAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mes Cours de Musique',
        variant: CustomAppBarVariant.standard,
        onSearchTap: () {
          // Handle search
        },
        onNotificationTap: () {
          // Handle notifications
        },
        notificationCount: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show menu
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildVariantExample(
            context,
            'Standard App Bar',
            CustomAppBarVariant.standard,
          ),
          const SizedBox(height: 16),
          _buildVariantExample(
            context,
            'Search App Bar',
            CustomAppBarVariant.search,
          ),
          const SizedBox(height: 16),
          _buildVariantExample(
            context,
            'Profile App Bar',
            CustomAppBarVariant.profile,
          ),
          const SizedBox(height: 16),
          _buildVariantExample(
            context,
            'Detail App Bar',
            CustomAppBarVariant.detail,
          ),
        ],
      ),
    );
  }

  Widget _buildVariantExample(
    BuildContext context,
    String description,
    CustomAppBarVariant variant,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Variant: ${variant.name}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _VariantDemoScreen(variant: variant),
                  ),
                );
              },
              child: const Text('Voir l\'exemple'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantDemoScreen extends StatelessWidget {
  final CustomAppBarVariant variant;

  const _VariantDemoScreen({required this.variant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(),
        subtitle: variant == CustomAppBarVariant.profile ? 'Étudiant' : null,
        variant: variant,
        showBackButton: true,
        onSearchTap: variant == CustomAppBarVariant.search
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recherche activée')),
                );
              }
            : null,
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications ouvertes')),
          );
        },
        notificationCount: 5,
        actions: [
          if (variant == CustomAppBarVariant.detail)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Partager')),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu ouvert')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(),
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Exemple de ${variant.name}',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _getDescription(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (variant) {
      case CustomAppBarVariant.search:
        return 'Rechercher';
      case CustomAppBarVariant.profile:
        return 'Jean Dupont';
      case CustomAppBarVariant.detail:
        return 'Cours de Piano';
      case CustomAppBarVariant.standard:
      default:
        return 'Mes Cours de Musique';
    }
  }

  IconData _getIcon() {
    switch (variant) {
      case CustomAppBarVariant.search:
        return Icons.search;
      case CustomAppBarVariant.profile:
        return Icons.person;
      case CustomAppBarVariant.detail:
        return Icons.music_note;
      case CustomAppBarVariant.standard:
      default:
        return Icons.home;
    }
  }

  String _getDescription() {
    switch (variant) {
      case CustomAppBarVariant.search:
        return 'Barre d\'application avec champ de recherche intégré pour une découverte rapide des professeurs et instruments.';
      case CustomAppBarVariant.profile:
        return 'Barre d\'application de profil avec titre et sous-titre pour afficher les informations utilisateur.';
      case CustomAppBarVariant.detail:
        return 'Barre d\'application de détail avec actions contextuelles pour les pages de contenu spécifique.';
      case CustomAppBarVariant.standard:
      default:
        return 'Barre d\'application standard avec recherche et notifications pour la navigation principale.';
    }
  }
}
