import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../models/character_model.dart';
import '../providers/favorite_provider.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/status_badge.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  final VoidCallback? onExplorePressed;

  const FavoriteScreen({super.key, this.onExplorePressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmBg,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_rounded,
              color: AppTheme.statusDead,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text('PORTAL FAVORITES'),
            const SizedBox(width: 8),
            Consumer<FavoriteProvider>(
              builder: (context, favProvider, child) {
                if (favProvider.count == 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${favProvider.count}',
                    style: const TextStyle(
                      color: AppTheme.statusDead,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favProvider, child) {
          if (favProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.portalGreen),
              ),
            );
          }

          if (favProvider.favorites.isEmpty) {
            return EmptyStateView(
              icon: Icons.heart_broken_rounded,
              title: 'Your portal is empty!',
              message: 'Belum ada karakter yang disimpan ke dimensi favorit.\nJelajahi multiverse dan simpan karakter favoritmu sekarang!',
              buttonText: 'Jelajahi Karakter',
              onButtonPressed: onExplorePressed,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: favProvider.favorites.length,
            itemBuilder: (context, index) {
              final character = favProvider.favorites[index];
              return _buildDismissibleItem(context, favProvider, character);
            },
          );
        },
      ),
    );
  }

  Widget _buildDismissibleItem(
    BuildContext context,
    FavoriteProvider favProvider,
    CharacterModel character,
  ) {
    return Dismissible(
      key: Key('fav_${character.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppTheme.statusDead,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_forever_rounded, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) async {
        await favProvider.removeFavorite(character.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_rounded,
                    color: AppTheme.statusDead,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${character.name} telah dihapus dari favorit.',
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.warmBorder.withValues(alpha: 0.7),
            width: 1.2,
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(character: character),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Illustrated Character Thumbnail
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE4DA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        character.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image_rounded,
                              color: AppTheme.textMuted,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${character.species} • ${character.gender}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 7),
                        StatusBadge(status: character.status, compact: true),
                      ],
                    ),
                  ),
                  // Heart button with tap to remove
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.statusDead,
                    ),
                    onPressed: () async {
                      await favProvider.removeFavorite(character.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                              '${character.name} dihapus dari favorit.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
