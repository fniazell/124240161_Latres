import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../models/character_model.dart';
import '../providers/favorite_provider.dart';
import '../widgets/status_badge.dart';

class DetailScreen extends StatelessWidget {
  final CharacterModel character;

  const DetailScreen({
    super.key,
    required this.character,
  });

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.warmBorder.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? 'Unknown' : value,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmBg,
      body: Consumer<FavoriteProvider>(
        builder: (context, favProvider, child) {
          final isFav = favProvider.isFavorite(character.id);

          return CustomScrollView(
            slivers: [
              // Custom Illustrated Sliver AppBar with Big Portrait
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                backgroundColor: AppTheme.warmBg,
                surfaceTintColor: Colors.transparent,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.cardLight,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 17),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardLight,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppTheme.statusDead : AppTheme.textMuted,
                        size: 22,
                      ),
                      onPressed: () async {
                        final added = await favProvider.toggleFavorite(character);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Row(
                                children: [
                                  Icon(
                                    added ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: added ? AppTheme.statusDead : AppTheme.textMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      added
                                          ? '${character.name} ditambahkan ke daftar favorit!'
                                          : '${character.name} dihapus dari daftar favorit.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBE4DA),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              character.image,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.portalGreen),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFFE8E2D8),
                                  child: const Center(
                                    child: Icon(Icons.broken_image_rounded, size: 64, color: AppTheme.textMuted),
                                  ),
                                );
                              },
                            ),
                            // Subtle bottom gradient for smooth readability
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.35),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Status Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              character.name,
                              style: const TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          StatusBadge(status: character.status),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ID & Dimension subtitle
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.mutedBrownLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'DIMENSION REGISTRY #${character.id}',
                          style: const TextStyle(
                            color: AppTheme.mutedBrown,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Information Section Header
                      const Text(
                        'CHARACTER SPECIFICATIONS',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Information Cards in Warm Illustrated Aesthetic
                      _buildInfoRow(
                        icon: Icons.fingerprint_rounded,
                        label: 'Spesies (Species)',
                        value: character.species,
                        iconColor: AppTheme.portalGreen,
                        iconBg: AppTheme.portalGreenLight,
                      ),
                      _buildInfoRow(
                        icon: Icons.transgender_rounded,
                        label: 'Gender',
                        value: character.gender,
                        iconColor: AppTheme.dimensionPurple,
                        iconBg: AppTheme.dimensionPurpleLight,
                      ),
                      if (character.type.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.category_rounded,
                          label: 'Tipe (Sub-type)',
                          value: character.type,
                          iconColor: AppTheme.mortyYellow,
                          iconBg: AppTheme.mortyYellowLight,
                        ),
                      _buildInfoRow(
                        icon: Icons.public_rounded,
                        label: 'Asal (Origin)',
                        value: character.originName,
                        iconColor: AppTheme.turquoise,
                        iconBg: AppTheme.turquoiseLight,
                      ),
                      _buildInfoRow(
                        icon: Icons.pin_drop_rounded,
                        label: 'Lokasi Terakhir (Location)',
                        value: character.locationName,
                        iconColor: AppTheme.mutedBrown,
                        iconBg: AppTheme.mutedBrownLight,
                      ),
                      _buildInfoRow(
                        icon: Icons.movie_filter_rounded,
                        label: 'Kemunculan Episode',
                        value: '${character.episode.length} Episode',
                        iconColor: AppTheme.dimensionPurple,
                        iconBg: AppTheme.dimensionPurpleLight,
                      ),

                      const SizedBox(height: 20),

                      // Favorite Action Button Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.cardLight,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isFav
                                ? AppTheme.statusDead.withValues(alpha: 0.5)
                                : AppTheme.warmBorder.withValues(alpha: 0.8),
                            width: 1.5,
                          ),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isFav
                                    ? const Color(0xFFFEE2E2)
                                    : AppTheme.warmSurface.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? AppTheme.statusDead : AppTheme.textMuted,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isFav ? 'Tersimpan di Favorit' : 'Simpan ke Favorit',
                                    style: TextStyle(
                                      color: isFav ? AppTheme.statusDead : AppTheme.textDark,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isFav
                                        ? 'Karakter ini tersimpan di portal favorit Anda'
                                        : 'Tekan untuk menyimpan ke daftar favorit',
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: isFav ? const Color(0xFFFEE2E2) : AppTheme.portalGreenLight,
                              ),
                              icon: Icon(
                                isFav ? Icons.heart_broken_rounded : Icons.add_rounded,
                                color: isFav ? AppTheme.statusDead : AppTheme.portalGreen,
                              ),
                              onPressed: () async {
                                final added = await favProvider.toggleFavorite(character);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Row(
                                        children: [
                                          Icon(
                                            added ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                            color: added ? AppTheme.statusDead : AppTheme.textMuted,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              added
                                                  ? '${character.name} ditambahkan ke favorit!'
                                                  : '${character.name} dihapus dari favorit.',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
