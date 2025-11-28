import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/teacher_card_widget.dart';

class TeacherSelection extends StatefulWidget {
  final String? selectedInstrument;

  const TeacherSelection({
    super.key,
    this.selectedInstrument,
  });

  @override
  State<TeacherSelection> createState() => _TeacherSelectionState();
}

class _TeacherSelectionState extends State<TeacherSelection> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Disponibilité';
  List<String> _favoriteTeacherIds = [];
  bool _isRefreshing = false;
  String _searchQuery = '';

  // Mock data for teachers
  final List<Map<String, dynamic>> _allTeachers = [
    {
      "id": "1",
      "name": "Sophie Martin",
      "instrument": "Piano",
      "experience": 12,
      "rating": 4.9,
      "totalReviews": 156,
      "isAvailable": true,
      "nextAvailableSlot": "Lundi 14:00",
      "hourlyRate": "45€",
      "profileImage":
          "https://images.unsplash.com/photo-1546222625-a0f09ed85ab5",
      "semanticLabel":
          "Portrait d'une femme souriante aux cheveux bruns mi-longs portant un pull beige",
      "specializations": ["Piano classique", "Jazz", "Débutants"],
      "bio":
          "Professeure passionnée avec 12 ans d'expérience dans l'enseignement du piano classique et jazz.",
    },
    {
      "id": "2",
      "name": "Marc Dubois",
      "instrument": "Guitare",
      "experience": 8,
      "rating": 4.7,
      "totalReviews": 98,
      "isAvailable": true,
      "nextAvailableSlot": "Mardi 10:00",
      "hourlyRate": "40€",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19ebb83b8-1763295792840.png",
      "semanticLabel":
          "Portrait d'un homme aux cheveux bruns courts portant une chemise blanche",
      "specializations": ["Guitare acoustique", "Rock", "Blues"],
      "bio":
          "Guitariste professionnel spécialisé dans le rock et le blues avec une approche pédagogique moderne.",
    },
    {
      "id": "3",
      "name": "Claire Rousseau",
      "instrument": "Violon",
      "experience": 15,
      "rating": 5.0,
      "totalReviews": 203,
      "isAvailable": false,
      "nextAvailableSlot": "Vendredi 16:00",
      "hourlyRate": "55€",
      "profileImage":
          "https://images.unsplash.com/photo-1612058078343-aec0f8fac008",
      "semanticLabel":
          "Portrait d'une femme aux cheveux blonds longs avec un sourire chaleureux",
      "specializations": ["Violon classique", "Musique de chambre", "Avancés"],
      "bio":
          "Violoniste concertiste et professeure reconnue, spécialisée dans le répertoire classique.",
    },
    {
      "id": "4",
      "name": "Thomas Bernard",
      "instrument": "Batterie",
      "experience": 10,
      "rating": 4.8,
      "totalReviews": 134,
      "isAvailable": true,
      "nextAvailableSlot": "Mercredi 15:00",
      "hourlyRate": "42€",
      "profileImage":
          "https://images.unsplash.com/photo-1679966749348-51a43e0ac460",
      "semanticLabel":
          "Portrait d'un homme aux cheveux noirs courts avec une barbe légère",
      "specializations": ["Batterie rock", "Jazz", "Technique"],
      "bio":
          "Batteur professionnel avec une expérience scénique internationale et une passion pour l'enseignement.",
    },
    {
      "id": "5",
      "name": "Émilie Lefebvre",
      "instrument": "Chant",
      "experience": 9,
      "rating": 4.6,
      "totalReviews": 87,
      "isAvailable": true,
      "nextAvailableSlot": "Jeudi 11:00",
      "hourlyRate": "38€",
      "profileImage":
          "https://images.unsplash.com/photo-1651130391069-3dd8c10c7b89",
      "semanticLabel":
          "Portrait d'une femme aux cheveux châtains ondulés avec un regard expressif",
      "specializations": ["Technique vocale", "Pop", "Lyrique"],
      "bio":
          "Chanteuse lyrique et coach vocale spécialisée dans le développement de la voix et l'interprétation.",
    },
    {
      "id": "6",
      "name": "Pierre Moreau",
      "instrument": "Piano",
      "experience": 20,
      "rating": 4.9,
      "totalReviews": 245,
      "isAvailable": false,
      "nextAvailableSlot": "Lundi 09:00",
      "hourlyRate": "60€",
      "profileImage":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19158bc20-1763300218404.png",
      "semanticLabel":
          "Portrait d'un homme aux cheveux gris courts avec des lunettes",
      "specializations": ["Piano classique", "Composition", "Maîtres"],
      "bio":
          "Pianiste concertiste et compositeur avec plus de 20 ans d'expérience dans l'enseignement supérieur.",
    },
  ];

  List<Map<String, dynamic>> get _filteredTeachers {
    List<Map<String, dynamic>> filtered = _allTeachers;

    // Filter by selected instrument if provided
    if (widget.selectedInstrument != null &&
        widget.selectedInstrument!.isNotEmpty) {
      filtered = filtered
          .where((teacher) =>
              (teacher["instrument"] as String).toLowerCase() ==
              widget.selectedInstrument!.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((teacher) {
        final name = (teacher["name"] as String).toLowerCase();
        final instrument = (teacher["instrument"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || instrument.contains(query);
      }).toList();
    }

    // Sort based on selected filter
    switch (_selectedFilter) {
      case 'Disponibilité':
        filtered.sort((a, b) {
          if (a["isAvailable"] == b["isAvailable"]) return 0;
          return (a["isAvailable"] as bool) ? -1 : 1;
        });
        break;
      case 'Note':
        filtered.sort(
            (a, b) => (b["rating"] as double).compareTo(a["rating"] as double));
        break;
      case 'Expérience':
        filtered.sort((a, b) =>
            (b["experience"] as int).compareTo(a["experience"] as int));
        break;
      case 'Prix':
        filtered.sort((a, b) {
          final priceA =
              int.parse((a["hourlyRate"] as String).replaceAll('€', ''));
          final priceB =
              int.parse((b["hourlyRate"] as String).replaceAll('€', ''));
          return priceA.compareTo(priceB);
        });
        break;
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _favoriteTeachers {
    return _filteredTeachers
        .where((teacher) => _favoriteTeacherIds.contains(teacher["id"]))
        .toList();
  }

  void _toggleFavorite(String teacherId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_favoriteTeacherIds.contains(teacherId)) {
        _favoriteTeacherIds.remove(teacherId);
      } else {
        _favoriteTeacherIds.add(teacherId);
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Disponibilités mises à jour'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query);
  }

  void _handleVoiceSearch() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recherche vocale non disponible'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleFilterChange(String filter) {
    HapticFeedback.selectionClick();
    setState(() => _selectedFilter = filter);
  }

  void _navigateToTeacherProfile(Map<String, dynamic> teacher) {
    HapticFeedback.lightImpact();
    // Navigation to teacher profile would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture du profil de ${teacher["name"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToBooking(Map<String, dynamic> teacher) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/lesson-booking');
  }

  void _handleChangeInstrument() {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasResults = _filteredTeachers.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.selectedInstrument ?? 'Tous les professeurs',
        variant: CustomAppBarVariant.standard,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: hasResults
            ? _buildTeacherList(theme)
            : EmptyStateWidget(
                instrument: widget.selectedInstrument ?? '',
                onChangeInstrument: _handleChangeInstrument,
              ),
      ),
    );
  }

  Widget _buildTeacherList(ThemeData theme) {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: _buildSearchBar(theme),
          ),
        ),

        // Filter chips
        SliverToBoxAdapter(
          child: FilterChipsWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: _handleFilterChange,
          ),
        ),

        // Favorites section
        if (_favoriteTeachers.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'favorite',
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Mes favoris',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final teacher = _favoriteTeachers[index];
                return TeacherCardWidget(
                  teacher: teacher,
                  isFavorite: true,
                  onFavoriteToggle: () =>
                      _toggleFavorite(teacher["id"] as String),
                  onTap: () => _navigateToTeacherProfile(teacher),
                  onBookLesson: () => _navigateToBooking(teacher),
                );
              },
              childCount: _favoriteTeachers.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Divider(color: theme.dividerColor),
            ),
          ),
        ],

        // All teachers section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
            child: Text(
              _favoriteTeachers.isEmpty
                  ? 'Tous les professeurs'
                  : 'Autres professeurs',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final teacher = _filteredTeachers[index];
              final isFavorite = _favoriteTeacherIds.contains(teacher["id"]);

              return TeacherCardWidget(
                teacher: teacher,
                isFavorite: isFavorite,
                onFavoriteToggle: () =>
                    _toggleFavorite(teacher["id"] as String),
                onTap: () => _navigateToTeacherProfile(teacher),
                onBookLesson: () => _navigateToBooking(teacher),
              );
            },
            childCount: _filteredTeachers.length,
          ),
        ),

        // Bottom padding
        SliverToBoxAdapter(
          child: SizedBox(height: 2.h),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _handleSearch,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Rechercher un professeur...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _handleSearch('');
                  },
                )
              : IconButton(
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: _handleVoiceSearch,
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
        ),
      ),
    );
  }
}
