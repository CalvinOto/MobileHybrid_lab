import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_theme.dart';

class AuthService {
  static const _tokenKey = 'token';
  static const _roleKey = 'role';
  static const _usernameKey = 'username';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      await _saveSession(data['token'], data['role'], data['username']);
    }

    return {'status': res.statusCode, 'data': data};
  }

  static Future<Map<String, dynamic>> register(
      String username,
      String email,
      String password,
      ) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  static Future<Map<String, dynamic>> googleLogin(
      String googleId,
      String email,
      String username,
      ) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'google_id': googleId,
        'email': email,
        'username': username,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      await _saveSession(data['token'], data['role'], data['username']);
    }

    return {'status': res.statusCode, 'data': data};
  }

  static Future<void> _saveSession(String token, String role, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}