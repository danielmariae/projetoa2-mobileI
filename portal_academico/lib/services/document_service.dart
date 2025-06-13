import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/document.dart';

class DocumentsService {
  static const String baseUrl = 'https://684b8fb7ed2578be881bb6f8.mockapi.io/students';

  static Future<List<Document>> getDocuments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Document.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar documentos');
    }
  }

  static Future<void> addDocument(Document document) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(document.toJson()),
    );
  }

  static Future<void> updateDocument(String id, Document document) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(document.toJson()),
    );
  }

  static Future<void> deleteDocumento(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}