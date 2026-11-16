import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';

class FavoriteProvider extends ChangeNotifier {
  static const String _keyFavorites = 'user_favorite_characters';

  List<CharacterModel> _favorites = [];
  bool _isLoading = false;

  List<CharacterModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  int get count => _favorites.length;

  FavoriteProvider() {
    loadFavorites();
  }

  bool isFavorite(int characterId) {
    return _favorites.any((c) => c.id == characterId);
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_keyFavorites) ?? [];
      _favorites = list.map((item) {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return CharacterModel.fromJson(map);
      }).toList();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favorites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleFavorite(CharacterModel character) async {
    final exists = isFavorite(character.id);
    if (exists) {
      _favorites.removeWhere((c) => c.id == character.id);
    } else {
      // Prevent duplicates
      _favorites.removeWhere((c) => c.id == character.id);
      _favorites.insert(0, character);
    }

    notifyListeners();
    await _saveToPrefs();
    return !exists; // true if added, false if removed
  }

  Future<void> removeFavorite(int characterId) async {
    _favorites.removeWhere((c) => c.id == characterId);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _favorites.map((c) => jsonEncode(c.toJson())).toList();
      await prefs.setStringList(_keyFavorites, list);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
}

