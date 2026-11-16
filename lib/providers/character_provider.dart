import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';

class CharacterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CharacterModel> _characters = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  
  String _selectedStatus = 'all'; // all, alive, dead, unknown
  String _searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;

  List<CharacterModel> get characters => _characters;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  bool get hasMore => _currentPage < _totalPages;

  CharacterProvider() {
    fetchCharacters();
  }

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getCharacters(
        page: _currentPage,
        status: _selectedStatus == 'all' ? null : _selectedStatus,
        name: _searchQuery.isEmpty ? null : _searchQuery,
      );

      _characters = response.characters;
      _totalPages = response.totalPages;
      _totalCount = response.totalCount;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _characters = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCharacters() async {
    if (_isLoading || _isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiService.getCharacters(
        page: nextPage,
        status: _selectedStatus == 'all' ? null : _selectedStatus,
        name: _searchQuery.isEmpty ? null : _searchQuery,
      );

      _currentPage = nextPage;
      _totalPages = response.totalPages;
      _totalCount = response.totalCount;

      // Filter duplicates by id just in case API shifts items
      final existingIds = _characters.map((c) => c.id).toSet();
      for (final char in response.characters) {
        if (!existingIds.contains(char.id)) {
          _characters.add(char);
          existingIds.add(char.id);
        }
      }

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setFilter(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchCharacters();
  }

  void search(String query) {
    _searchQuery = query;
    _currentPage = 1;
    fetchCharacters();
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _currentPage = 1;
    fetchCharacters();
  }

  void retry() {
    fetchCharacters(refresh: true);
  }
}

