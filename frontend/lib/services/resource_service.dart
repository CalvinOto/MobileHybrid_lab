import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/resource.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class ResourceService {

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  static Future<List<Resource>> getAll() async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/resources'),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Resource.fromJson(e)).toList();
    }

    throw Exception('Failed to load resources');
  }

  static Future<Resource> getById(int id) async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/resources/$id'),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      return Resource.fromJson(jsonDecode(res.body));
    }

    throw Exception('Resource not found');
  }

  static Future<Map<String, dynamic>> create({
    required String name,
    required String type,
    required String description,
    required int stock,
    required double price,
    File? imageFile,
  }) async {
    final token = await AuthService.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/resources'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['type'] = type;
    request.fields['description'] = description;
    request.fields['stock'] = stock.toString();
    request.fields['price'] = price.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  static Future<Map<String, dynamic>> update({
    required int id,
    required String name,
    required String type,
    required String description,
    required int stock,
    required double price,
    File? imageFile,
    String? existingImage,
  }) async {
    final token = await AuthService.getToken();

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${AppConstants.baseUrl}/resources/$id'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['type'] = type;
    request.fields['description'] = description;
    request.fields['stock'] = stock.toString();
    request.fields['price'] = price.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    } else if (existingImage != null) {
      request.fields['image'] = existingImage;
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  static Future<Map<String, dynamic>> delete(int id) async {
    final res = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/resources/$id'),
      headers: await _authHeaders(),
    );

    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }
}