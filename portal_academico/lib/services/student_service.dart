import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io/students';

  static Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Student.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar alunos');
    }
  }

  static Future<Student> getStudentById(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/$studentId'));
    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    }
    throw Exception('Erro ao carregar aluno');
  }
  
  static Future<void> addStudent(Student student) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );
  }

  static Future<void> updateStudent(String id, Student student) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );
  }

  static Future<void> deleteStudent(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}