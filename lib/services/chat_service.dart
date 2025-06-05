//lib\services\chat_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final _endpoint = 'https://api.openai.com/v1/chat/completions';
  final _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${dotenv.env["OPENAI_API_KEY"]}',
  };

  Future<String> sendMessage(List<Map<String, String>> history) async {
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': history,
      'temperature': 0.7,
    });

    final res = await http.post(Uri.parse(_endpoint), headers: _headers, body: body);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json['choices'][0]['message']['content'];
    } else {
      throw Exception('OpenAI Error: ${res.body}');
    }
  }
}
