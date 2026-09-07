import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/purchase.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class PurchaseService {
  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<Map<String, dynamic>> buy(int resourceId, int quantity) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/purchases/buy'),
      headers: await _authHeaders(),
      body: jsonEncode({'resource_id': resourceId, 'quantity': quantity}),
    );
    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  static Future<List<Purchase>> getHistory() async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/purchases/history'),
      headers: await _authHeaders(),
    );
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Purchase.fromJson(e)).toList();
    }
    throw Exception('Failed to load purchase history');
  }
}