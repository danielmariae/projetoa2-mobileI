import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/discipline.dart';
import '../services/course_service.dart';
import '../services/discipline_service.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({Key? key}) : super(key: key);

  @override
  _GradeScreenState createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  late Future<List<Course>> _coursesFuture;
  late Future<List<Discipline>> _disciplinesFuture;
  String? _selectedCourse;
  final String _studentId = '2'; // ID do aluno logado

  @override
  void initState() {
    super.initState();
    _coursesFuture = CourseService.getCourses();
    _disciplinesFuture = DisciplineService.getDisciplinasByAluno(_studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grade Curricular')),
      body: Column(
        children: [
          FutureBuilder<List<Course>>(
            future: _coursesFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    hint: const Text('Selecione o curso'),
                    value: _selectedCourse,
                    items: snapshot.data!.map((course) {
                      return DropdownMenuItem<String>(
                        value: course.name,
                        child: Text(course.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCourse = value);
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Expanded(
            child: FutureBuilder<List<Discipline>>(
              future: _disciplinesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma disciplina encontrada'));
                }

                // Agrupar disciplinas por período
                final Map<int, List<Discipline>> periodMap = {};
                for (var disc in snapshot.data!) {
                  periodMap.putIfAbsent(disc.period ?? 0, () => []).add(disc);
                }

                return ListView.builder(
                  itemCount: periodMap.length,
                  itemBuilder: (context, index) {
                    final period = periodMap.keys.elementAt(index);
                    final disciplines = periodMap[period]!;
                    return ExpansionTile(
                      title: Text('Período $period'),
                      children: disciplines.map((disc) => ListTile(
                        title: Text(disc.name ?? ''),
                        subtitle: Text('CH: ${disc.workload}h - ${disc.status}'),
                      )).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}