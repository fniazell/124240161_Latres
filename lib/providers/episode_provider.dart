import 'package:flutter/material.dart';
import '../models/episode_model.dart';
import '../services/api_service.dart';

class EpisodeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<EpisodeModel> _episodes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;

  List<EpisodeModel> get episodes => _episodes;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  bool get hasMore => _currentPage < _totalPages;

  EpisodeProvider() {
    fetchEpisodes();
  }

  Future<void> fetchEpisodes({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getEpisodes(page: _currentPage);
      _episodes = response.episodes;
      _totalPages = response.totalPages;
      _totalCount = response.totalCount;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _episodes = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreEpisodes() async {
    if (_isLoading || _isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiService.getEpisodes(page: nextPage);

      _currentPage = nextPage;
      _totalPages = response.totalPages;
      _totalCount = response.totalCount;

      final existingIds = _episodes.map((e) => e.id).toSet();
      for (final ep in response.episodes) {
        if (!existingIds.contains(ep.id)) {
          _episodes.add(ep);
          existingIds.add(ep.id);
        }
      }

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void retry() {
    fetchEpisodes(refresh: true);
  }
}

