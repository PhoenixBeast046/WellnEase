//lib\services\api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchQuote() async {
    const url = 'https://zenquotes.io/api/random';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.first as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch quote');
    }
  }
}
