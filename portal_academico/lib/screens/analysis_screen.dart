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
  late Future<Student?> _studentFuture;
  late Future<List<Discipline>> _disciplinesFuture;
  final String _studentId = '2'; // ID do aluno logado

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _studentFuture = StudentService.getStudents().then(
      (students) => students.cast<Student?>().firstWhere(
            (s) => s?.id == _studentId,
            orElse: () => null,
          ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar dados: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final student = snapshot.data?[0] as Student?;
          final disciplines = snapshot.data?[1] as List<Discipline>? ?? [];

          if (student == null) {
            return const Center(
              child: Text('Aluno não encontrado'),
            );
          }

          final completed = disciplines.where((d) => d.status?.contains('Aprovado') ?? false).length;
          final total = disciplines.length;
          final progress = total > 0 ? (completed / total * 100).round() : 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aluno: ${student.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Curso: ${student.course}', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          Text('Progresso do Curso: $progress%', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress / 100,
                            minHeight: 20,
                            backgroundColor: Colors.grey[300],
                            color: _getProgressColor(progress),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDisciplineSection(
                    title: 'Disciplinas Concluídas ($completed/$total)',
                    disciplines: disciplines.where((d) => d.status?.contains('Aprovado') ?? false).toList(),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  _buildDisciplineSection(
                    title: 'Disciplinas Pendentes (${total - completed})',
                    disciplines: disciplines.where((d) => !(d.status?.contains('Aprovado') ?? true)).toList(),
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDisciplineSection({
    required String title,
    required List<Discipline> disciplines,
    required IconData icon,
    required Color color,
  }) {
    if (disciplines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                ],
              ),
            ),
            ...disciplines.map((d) => ListTile(
              title: Text(d.name ?? 'Disciplina sem nome'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (d.period != null) Text('Período: ${d.period}'),
                  if (d.finalMedia != null && (d.status?.contains('Aprovado') ?? false))
                    Text('Média: ${d.finalMedia}'),
                  if (d.status != null) Text('Status: ${d.status}'),
                ],
              ),
              trailing: _getStatusIcon(d.status),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(int progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 50) return Colors.blue;
    return Colors.orange;
  }

  Widget? _getStatusIcon(String? status) {
    if (status == null) return null;
    
    if (status.contains('Aprovado')) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (status.contains('Reprovado')) {
      return const Icon(Icons.cancel, color: Colors.red);
    } else {
      return const Icon(Icons.pending, color: Colors.orange);
    }
  }
}