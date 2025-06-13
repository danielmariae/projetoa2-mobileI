import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/discipline_service.dart';

class BoletimScreen extends StatefulWidget {
  const BoletimScreen({Key? key}) : super(key: key);

  @override
  _BoletimScreenState createState() => _BoletimScreenState();
}

class _BoletimScreenState extends State<BoletimScreen> {
  late Future<List<Discipline>> _disciplinesFuture;
  final String _studentId = '2'; // ID do aluno logado

  @override
  void initState() {
    super.initState();
    _disciplinesFuture = DisciplineService.getDisciplinasByAluno(_studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boletim')),
      body: FutureBuilder<List<Discipline>>(
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

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final discipline = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(discipline.name ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nota A1: ${discipline.test1 ?? 0}'),
                      Text('Nota A2: ${discipline.test2 ?? 0}'),
                      Text('Exame Final: ${discipline.finalExam ?? 0}'),
                      Text('Média Final: ${discipline.finalMedia ?? 0}'),
                      Text('Faltas: ${discipline.faults ?? 0}'),
                      Text('Status: ${discipline.status ?? ''}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}