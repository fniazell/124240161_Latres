import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../providers/episode_provider.dart';
import '../widgets/empty_state_view.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<EpisodeProvider>(context, listen: false);
      if (provider.hasMore && !provider.isLoadingMore) {
        provider.loadMoreEpisodes();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmBg,
      appBar: AppBar(
        title: const Text('DIMENSION EPISODES'),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.cardLight,
            shape: BoxShape.circle,
            boxShadow: AppTheme.softShadow,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Consumer<EpisodeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.episodes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.portalGreen),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mengunduh data transmisi episode...',
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

          if (provider.errorMessage != null && provider.episodes.isEmpty) {
            return EmptyStateView(
              icon: Icons.wifi_off_rounded,
              title: 'Transmisi Terputus!',
              message: provider.errorMessage!,
              buttonText: 'Coba Lagi',
              onButtonPressed: () => provider.retry(),
            );
          }

          if (provider.episodes.isEmpty) {
            return EmptyStateView(
              icon: Icons.movie_outlined,
              title: 'Tidak Ada Episode',
              message: 'Tidak ada transmisi episode yang ditemukan saat ini.',
              buttonText: 'Muat Ulang',
              onButtonPressed: () => provider.retry(),
            );
          }

          return RefreshIndicator(
            color: AppTheme.portalGreen,
            backgroundColor: AppTheme.cardLight,
            onRefresh: () async => await provider.fetchEpisodes(refresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: provider.episodes.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.episodes.length) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.portalGreen),
                      ),
                    ),
                  );
                }

                final ep = provider.episodes[index];

                return Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Episode Code Stamp Container
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.dimensionPurpleLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.tv_rounded,
                                color: AppTheme.dimensionPurple,
                                size: 18,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ep.episode,
                                style: const TextStyle(
                                  color: AppTheme.dimensionPurple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Episode Title and Air Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ep.name,
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 14,
                                    color: AppTheme.mutedBrown,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    ep.airDate,
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Episode index chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.warmSurface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '#${ep.id}',
                            style: const TextStyle(
                              color: AppTheme.mutedBrown,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
