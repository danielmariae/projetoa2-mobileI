import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class SituationScreen extends StatefulWidget {
  const SituationScreen({Key? key}) : super(key: key);

  @override
  _SituationScreenState createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen> {
  late Future<Student> _studentFuture;
  final String _studentId = '2'; // ID do aluno logado

  @override
  void initState() {
    super.initState();
    _studentFuture = StudentService.getStudents().then(
      (students) => students.firstWhere((s) => s.registrationNumber == _studentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Situação Acadêmica')),
      body: FutureBuilder<Student>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Dados do aluno não encontrados'));
          }

          final student = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nome: ${student.name}', style: const TextStyle(fontSize: 18)),
                        Text('Matrícula: ${student.registrationNumber}'),
                        Text('Status: ${student.status}'),
                        Text('Rematrícula: ${student.canReenroll ? 'Liberada' : 'Não liberada'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Documentos:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...student.documents.map((doc) => ListTile(
                  title: Text(doc.type),
                  trailing: Text(doc.status, style: TextStyle(
                    color: doc.status == 'Pendente' ? Colors.red : Colors.green,
                  )),
                )).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}