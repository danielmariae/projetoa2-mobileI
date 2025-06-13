import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/discipline.dart';
import '../services/student_service.dart';
import '../services/discipline_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late Future<Student> _studentFuture;
  late Future<List<Discipline>> _disciplinesFuture;
  final String _studentId = '2'; // ID do aluno logado

  @override
  void initState() {
    super.initState();
    _studentFuture = StudentService.getStudents().then(
      (students) => students.firstWhere((s) => s.registrationNumber == _studentId),
    );
    _disciplinesFuture = DisciplineService.getDisciplinasByAluno(_studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análise Curricular')),
      body: FutureBuilder(
        future: Future.wait([_studentFuture, _disciplinesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Dados não encontrados'));
          }

          // ignore: unused_local_variable
          final student = snapshot.data![0] as Student;
          final disciplines = snapshot.data![1] as List<Discipline>;

          final completed = disciplines.where((d) => d.status == 'Aprovado').length;
          final total = disciplines.length;
          final progress = total > 0 ? (completed / total * 100).round() : 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progresso do Curso: $progress%', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 20,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                const Text('Disciplinas Concluídas:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...disciplines.where((d) => d.status == 'Aprovado').map((d) => ListTile(
                  title: Text(d.name ?? ''),
                  subtitle: Text('Período ${d.period} - Média ${d.finalMedia}'),
                )).toList(),
                const SizedBox(height: 20),
                const Text('Disciplinas Pendentes:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...disciplines.where((d) => d.status != 'Aprovado').map((d) => ListTile(
                  title: Text(d.name ?? ''),
                  subtitle: Text('Período ${d.period} - Status: ${d.status}'),
                )).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}