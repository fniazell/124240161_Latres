import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/episode_model.dart';

class CharacterResponse {
  final List<CharacterModel> characters;
  final int totalPages;
  final int totalCount;
  final String? nextUrl;

  CharacterResponse({
    required this.characters,
    required this.totalPages,
    required this.totalCount,
    this.nextUrl,
  });
}

class EpisodeResponse {
  final List<EpisodeModel> episodes;
  final int totalPages;
  final int totalCount;
  final String? nextUrl;

  EpisodeResponse({
    required this.episodes,
    required this.totalPages,
    required this.totalCount,
    this.nextUrl,
  });
}

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch characters with optional page, status filter (alive, dead, unknown), and search query (name)
  Future<CharacterResponse> getCharacters({
    int page = 1,
    String? status,
    String? name,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
    };

    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      queryParams['status'] = status.toLowerCase();
    }

    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    final uri = Uri.parse('$baseUrl/character').replace(queryParameters: queryParams);

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final info = data['info'] ?? {};
        final results = data['results'] as List? ?? [];

        final characters = results.map((item) => CharacterModel.fromJson(item)).toList();
        return CharacterResponse(
          characters: characters,
          totalPages: info['pages'] ?? 1,
          totalCount: info['count'] ?? characters.length,
          nextUrl: info['next'],
        );
      } else if (response.statusCode == 404) {
        // Rick & Morty API returns 404 when no results match the filter/search
        return CharacterResponse(
          characters: [],
          totalPages: 0,
          totalCount: 0,
          nextUrl: null,
        );
      } else {
        throw Exception('Gagal memuat karakter (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Gagal memuat')) {
        rethrow;
      }
      throw Exception('Gagal terhubung ke server Rick & Morty. Periksa koneksi internet Anda.');
    }
  }

  /// Fetch single character detail by ID
  Future<CharacterModel> getCharacterDetail(int id) async {
    final uri = Uri.parse('$baseUrl/character/$id');

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CharacterModel.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail karakter (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: ${e.toString()}');
    }
  }

  /// Fetch episodes list with pagination
  Future<EpisodeResponse> getEpisodes({int page = 1}) async {
    final uri = Uri.parse('$baseUrl/episode?page=$page');

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final info = data['info'] ?? {};
        final results = data['results'] as List? ?? [];

        final episodes = results.map((item) => EpisodeModel.fromJson(item)).toList();
        return EpisodeResponse(
          episodes: episodes,
          totalPages: info['pages'] ?? 1,
          totalCount: info['count'] ?? episodes.length,
          nextUrl: info['next'],
        );
      } else if (response.statusCode == 404) {
        return EpisodeResponse(
          episodes: [],
          totalPages: 0,
          totalCount: 0,
          nextUrl: null,
        );
      } else {
        throw Exception('Gagal memuat episode (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server episode: ${e.toString()}');
    }
  }
}

