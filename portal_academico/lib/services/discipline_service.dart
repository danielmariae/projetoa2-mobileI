import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/discipline.dart';

class DisciplineService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io/disciplines';

  static Future<List<Discipline>> getDisciplinasByAluno(String studentId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?studentId=$studentId'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => Discipline.fromJson(json)).toList();
      }
      throw Exception('Falha ao carregar: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }


  static Future<List<Discipline>> getDisciplinasPorPeriodo(
    String studentId, 
    int period
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?studentId=$studentId&period=$period')
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => Discipline.fromJson(json)).toList();
      }
      throw Exception('Falha ao carregar: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }


  static Future<void> sendReenrollment(String studentId, int period, List<Discipline> disciplines) async {
    try {
      // Lista para armazenar todas as requisições
      final List<Future<http.Response>> requests = [];
      
      for (final disc in disciplines) {
        final payload = {
          "studentId": studentId,
          "code": disc.code,
          "name": disc.name,
          "period": period,  // Usando o período fornecido
          "workload": disc.workload ?? 60,  // Valor padrão 60h
          "faults": 0,  // Inicia sem faltas
          "test1": 0.0,  // Notas zeradas
          "test2": 0.0,
          "finalExam": 0.0,
          "finalMedia": 0.0,
          "frequency": 100,  // Frequência inicial 100%
          "status": "Matriculado",  // Status inicial
        };

        requests.add(
          http.post(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
        );
      }

      // Executa todas as requisições em paralelo
      final responses = await Future.wait(requests);
      
      // Verifica se todas foram bem sucedidas
      for (final response in responses) {
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Falha na disciplina: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Erro na rematrícula: $e');
    }
  }
}