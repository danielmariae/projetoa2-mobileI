import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io';

  static Future<Map<String, dynamic>?> getStudentByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.firstWhere(
            (user) => user['email'] == email,
        orElse: () => null,
      );
    } else {
      throw Exception('Erro ao buscar alunos');
    }
  }
}