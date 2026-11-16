import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_state_view.dart';
import 'episode_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 250) {
      final provider = Provider.of<CharacterProvider>(context, listen: false);
      if (provider.hasMore && !provider.isLoadingMore) {
        provider.loadMoreCharacters();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.mortyYellow),
            SizedBox(width: 10),
            Text(
              'Keluar Dimensi?',
              style: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin logout dari sesi portal saat ini?',
          style: TextStyle(color: AppTheme.textDarkSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.statusDead,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final auth = Provider.of<AuthProvider>(context, listen: false);
              await auth.logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, CharacterProvider provider) {
    final isSelected = provider.selectedStatus.toLowerCase() == value.toLowerCase();

    return GestureDetector(
      onTap: () => provider.setFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cardDark : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.cardDark : AppTheme.warmBorder.withValues(alpha: 0.8),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.cardDark.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : AppTheme.softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != 'all') ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (value == 'alive'
                          ? AppTheme.portalGreen
                          : (value == 'dead' ? AppTheme.statusDead : AppTheme.statusUnknown))
                      : (value == 'alive'
                          ? AppTheme.statusAlive
                          : (value == 'dead' ? AppTheme.statusDead : AppTheme.statusUnknown)),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textDark,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final charProvider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.warmBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Illustrated Emblem and Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                children: [
                  // Illustrated Emblem
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.cardLight,
                      boxShadow: AppTheme.softShadow,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.portalGreen,
                            AppTheme.turquoise,
                            AppTheme.cardDark,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.travel_explore_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Titles
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Character Explorer',
                          style: TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          'Explorer: ${auth.currentName ?? "Multiverse Traveler"}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Episode Screen Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardLight,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: IconButton(
                      tooltip: 'Daftar Episode',
                      icon: const Icon(Icons.movie_creation_outlined, color: AppTheme.turquoise, size: 21),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EpisodeScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Logout Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardLight,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: IconButton(
                      tooltip: 'Logout',
                      icon: const Icon(Icons.logout_rounded, color: AppTheme.statusDead, size: 21),
                      onPressed: _showLogoutDialog,
                    ),
                  ),
                ],
              ),
            ),

            // Soft Rounded Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.warmBorder.withValues(alpha: 0.7),
                    width: 1.2,
                  ),
                  boxShadow: AppTheme.softShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari karakter (Rick, Morty, Summer)...',
                    hintStyle: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.mutedBrown,
                      size: 22,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              charProvider.clearSearch();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  ),
                  onSubmitted: (query) {
                    charProvider.search(query);
                  },
                  onChanged: (value) {
                    setState(() {});
                    if (value.isEmpty) {
                      charProvider.clearSearch();
                    }
                  },
                ),
              ),
            ),

            // Filter Tabs: All, Alive, Dead, Unknown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all', charProvider),
                    const SizedBox(width: 8),
                    _buildFilterChip('Alive', 'alive', charProvider),
                    const SizedBox(width: 8),
                    _buildFilterChip('Dead', 'dead', charProvider),
                    const SizedBox(width: 8),
                    _buildFilterChip('Unknown', 'unknown', charProvider),
                  ],
                ),
              ),
            ),

            // Main Content Area: Character Grid / Loading / Error / Empty
            Expanded(
              child: RefreshIndicator(
                color: AppTheme.portalGreen,
                backgroundColor: AppTheme.cardLight,
                onRefresh: () async => await charProvider.fetchCharacters(refresh: true),
                child: Builder(
                  builder: (context) {
                    if (charProvider.isLoading && charProvider.characters.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.portalGreen),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Menghubungkan ke portal data karakter...',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (charProvider.errorMessage != null && charProvider.characters.isEmpty) {
                      return EmptyStateView(
                        icon: Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                        title: 'Koneksi Portal Gagal!',
                        message: charProvider.errorMessage!,
                        buttonText: 'Coba Lagi',
                        onButtonPressed: () => charProvider.retry(),
                      );
                    }

                    if (charProvider.characters.isEmpty) {
                      return EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'Karakter Tidak Ditemukan',
                        message:
                            'Tidak ada karakter yang cocok dengan kriteria pencarian "${charProvider.searchQuery}" atau filter "${charProvider.selectedStatus}".',
                        buttonText: 'Reset Pencarian',
                        onButtonPressed: () {
                          _searchController.clear();
                          charProvider.clearSearch();
                          charProvider.setFilter('all');
                        },
                      );
                    }

                    // 2-Column Responsive Grid with Illustrated Cards
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.70,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final character = charProvider.characters[index];
                                return CharacterCard(character: character);
                              },
                              childCount: charProvider.characters.length,
                            ),
                          ),
                        ),
                        // Loading more indicator at bottom
                        if (charProvider.hasMore)
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.portalGreen),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
