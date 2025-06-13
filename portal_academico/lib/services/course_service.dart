import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io/students';

  static Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar cursos');
    }
  }
}