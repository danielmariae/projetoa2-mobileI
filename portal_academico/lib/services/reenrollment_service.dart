import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reenrollment.dart';

class RematriculaService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io/students';

  static Future<List<Reenrollment>> getReenrollments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Reenrollment.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar rematrículas');
    }
  }

  static Future<void> addReenrollment(Reenrollment rematricula) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rematricula.toJson()),
    );
  }

  static Future<void> updateReenrollment(String id, Reenrollment rematricula) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rematricula.toJson()),
    );
  }

  static Future<void> deleteReenrollment(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}