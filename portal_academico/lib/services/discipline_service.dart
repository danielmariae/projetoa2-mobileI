import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/discipline.dart';

class DisciplineService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io/disciplines';

  static Future<List<Discipline>> getDisciplinasByAluno(String studentId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?studentId=$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Discipline.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar disciplinas. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }

  static Future<List<Discipline>> getDisciplinasPorPeriodo(String studentId, int period) async {
    final response = await http.get(Uri.parse('$baseUrl?studentId=$studentId&period=$period'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Discipline.fromJson(json)).toList();
    } else {
      throw Exception('Error when trying to find disciplines by period!');
    }
  }


  static Future<void> sendReenrollment(String studentId, int period, List<Discipline> disciplines) async {
    final List<Map<String, dynamic>> payload = disciplines.map((disc) {
      return {
        "studentid": studentId,
        "code": disc.code,
        "name": disc.name,
        "period": disc.toString(),
        "workload": disc.workload ?? 0,
        "faults": 0,
        "test1": 0,
        "test2": 0,
        "finalExam": 0,
        "finalMedia": 0,
        "status": "Matriculado",
      };
    }).toList();

    final response = await http.post(
      Uri.parse('$baseUrl/reenrollment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error when trying to reenrollment');
    }
  }
}