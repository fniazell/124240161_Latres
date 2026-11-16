import 'package:flutter_test/flutter_test.dart';
import 'package:latihan_responsi/constants/app_theme.dart';
import 'package:latihan_responsi/models/character_model.dart';
import 'package:latihan_responsi/models/episode_model.dart';
import 'package:latihan_responsi/models/user_model.dart';
import 'package:latihan_responsi/services/database_helper.dart';

void main() {
  group('Model & Serialization Tests', () {
    test('UserModel serialization and deserialization', () {
      final user = UserModel(
        id: 1,
        name: 'Rick Sanchez',
        username: 'rick_c137',
        passwordHash: DatabaseHelper.hashPassword('wubbalubba'),
      );

      final map = user.toMap();
      expect(map['id'], 1);
      expect(map['name'], 'Rick Sanchez');
      expect(map['username'], 'rick_c137');

      final deserialized = UserModel.fromMap(map);
      expect(deserialized.id, 1);
      expect(deserialized.name, 'Rick Sanchez');
      expect(deserialized.username, 'rick_c137');
      expect(deserialized.passwordHash, user.passwordHash);
    });

    test('Password hashing produces consistent SHA-256', () {
      final hash1 = DatabaseHelper.hashPassword('portal_gun_123');
      final hash2 = DatabaseHelper.hashPassword('portal_gun_123');
      final hash3 = DatabaseHelper.hashPassword('different_password');

      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(hash3)));
      expect(hash1.length, 64); // SHA-256 hex string length
    });

    test('CharacterModel parses JSON from API properly', () {
      final apiJson = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {'name': 'Earth (C-137)', 'url': 'https://rickandmortyapi.com/api/location/1'},
        'location': {'name': 'Citadel of Ricks', 'url': 'https://rickandmortyapi.com/api/location/3'},
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'episode': ['https://rickandmortyapi.com/api/episode/1'],
      };

      final char = CharacterModel.fromJson(apiJson);
      expect(char.id, 1);
      expect(char.name, 'Rick Sanchez');
      expect(char.status, 'Alive');
      expect(char.species, 'Human');
      expect(char.originName, 'Earth (C-137)');
      expect(char.locationName, 'Citadel of Ricks');
      expect(char.image, 'https://rickandmortyapi.com/api/character/avatar/1.jpeg');
      expect(char.episode.length, 1);

      final serialized = char.toJson();
      expect(serialized['name'], 'Rick Sanchez');
      expect(serialized['originName'], 'Earth (C-137)');
    });

    test('EpisodeModel parses JSON from API properly', () {
      final episodeJson = {
        'id': 1,
        'name': 'Pilot',
        'air_date': 'December 2, 2013',
        'episode': 'S01E01',
        'characters': ['https://rickandmortyapi.com/api/character/1'],
      };

      final ep = EpisodeModel.fromJson(episodeJson);
      expect(ep.id, 1);
      expect(ep.name, 'Pilot');
      expect(ep.airDate, 'December 2, 2013');
      expect(ep.episode, 'S01E01');
      expect(ep.characters.length, 1);
    });
  });

  group('AppTheme Tests', () {
    test('AppTheme colors and themeData are initialized', () {
      final theme = AppTheme.themeData;
      expect(theme.scaffoldBackgroundColor, AppTheme.warmBg);
      expect(theme.primaryColor, AppTheme.portalGreen);
    });
  });
}

