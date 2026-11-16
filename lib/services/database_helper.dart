import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String _webUsersKey = 'web_users_db';

  DatabaseHelper._init();

  /// Utility to hash password with SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rick_and_morty_users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // If running on desktop platforms (Windows, Linux, macOS), initialize sqflite_common_ffi
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        passwordHash TEXT NOT NULL
      )
    ''');
  }

  /// Register user. Checks for duplicates and saves hashed password.
  Future<int> registerUser(UserModel user) async {
    if (kIsWeb) {
      return await _registerUserWeb(user);
    }

    final db = await database;
    try {
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      if (e.toString().contains('UNIQUE') || e.toString().contains('19')) {
        throw Exception('Username atau email sudah terdaftar.');
      }
      throw Exception('Gagal menyimpan data akun: ${e.toString()}');
    }
  }

  /// Check if username or email is already taken
  Future<bool> isUsernameTaken(String username) async {
    if (kIsWeb) {
      final user = await _getUserByUsernameWeb(username);
      return user != null;
    }

    final db = await database;
    final result = await db.query(
      'users',
      where: 'LOWER(username) = ?',
      whereArgs: [username.trim().toLowerCase()],
    );
    return result.isNotEmpty;
  }

  /// Get user by username or email
  Future<UserModel?> getUserByUsername(String username) async {
    if (kIsWeb) {
      return await _getUserByUsernameWeb(username);
    }

    final db = await database;
    final maps = await db.query(
      'users',
      where: 'LOWER(username) = ?',
      whereArgs: [username.trim().toLowerCase()],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  /// Validate login credentials
  Future<UserModel?> validateCredentials(String username, String password) async {
    final passwordHash = hashPassword(password);

    if (kIsWeb) {
      final user = await _getUserByUsernameWeb(username);
      if (user != null && user.passwordHash == passwordHash) {
        return user;
      }
      return null;
    }

    final db = await database;
    final maps = await db.query(
      'users',
      where: 'LOWER(username) = ? AND passwordHash = ?',
      whereArgs: [username.trim().toLowerCase(), passwordHash],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // --- Web Compatibility Fallback using SharedPreferences ---
  Future<int> _registerUserWeb(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_webUsersKey) ?? [];

    for (final raw in usersJson) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['username'].toString().toLowerCase() == user.username.trim().toLowerCase()) {
        throw Exception('Username atau email sudah terdaftar.');
      }
    }

    final newId = usersJson.length + 1;
    final newUser = UserModel(
      id: newId,
      name: user.name,
      username: user.username,
      passwordHash: user.passwordHash,
    );
    usersJson.add(jsonEncode(newUser.toMap()));
    await prefs.setStringList(_webUsersKey, usersJson);
    return newId;
  }

  Future<UserModel?> _getUserByUsernameWeb(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_webUsersKey) ?? [];

    for (final raw in usersJson) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['username'].toString().toLowerCase() == username.trim().toLowerCase()) {
        return UserModel.fromMap(map);
      }
    }
    return null;
  }
}
