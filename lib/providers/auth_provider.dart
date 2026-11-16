import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_helper.dart';
import '../services/session_manager.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _currentUser;
  String? _currentName;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;
  String? get currentName => _currentName;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await SessionManager.isLoggedIn();
    if (_isLoggedIn) {
      final session = await SessionManager.getSessionUser();
      _currentUser = session['username'];
      _currentName = session['name'];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.trim().isEmpty || password.trim().isEmpty) {
        _errorMessage = 'Username dan password tidak boleh kosong.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = await DatabaseHelper.instance.validateCredentials(
        username.trim(),
        password,
      );

      if (user != null) {
        await SessionManager.saveSession(
          username: user.username,
          name: user.name,
        );
        _isLoggedIn = true;
        _currentUser = user.username;
        _currentName = user.name;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Username atau password salah.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (name.trim().isEmpty || username.trim().isEmpty || password.trim().isEmpty) {
        _errorMessage = 'Semua field wajib diisi.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 4) {
        _errorMessage = 'Password minimal harus 4 karakter.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password != confirmPassword) {
        _errorMessage = 'Konfirmasi password tidak cocok.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final isTaken = await DatabaseHelper.instance.isUsernameTaken(username.trim());
      if (isTaken) {
        _errorMessage = 'Username "$username" sudah terdaftar. Gunakan yang lain.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final hashedPassword = DatabaseHelper.hashPassword(password);
      final newUser = UserModel(
        name: name.trim(),
        username: username.trim(),
        passwordHash: hashedPassword,
      );

      await DatabaseHelper.instance.registerUser(newUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    _isLoggedIn = false;
    _currentUser = null;
    _currentName = null;
    _errorMessage = null;
    notifyListeners();
  }
}

