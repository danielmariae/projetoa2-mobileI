import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/discipline_service.dart';

class ReenrollmentScreen extends StatefulWidget {
  const ReenrollmentScreen({Key? key}) : super(key: key);

  @override
  _ReenrollmentScreenState createState() => _ReenrollmentScreenState();
}

class _ReenrollmentScreenState extends State<ReenrollmentScreen> {
  late Future<List<Discipline>> _disciplinesFuture;
  final List<Discipline> _selectedDisciplines = [];
  final String _studentId = '2'; // ID do aluno logado
  final int _nextPeriod = 2; // Próximo período para matrícula

  @override
  void initState() {
    super.initState();
    _disciplinesFuture = DisciplineService.getDisciplinasPorPeriodo(_studentId, _nextPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rematrícula Online')),
      body: Column(
        children: [
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
                  return const Center(child: Text('Nenhuma disciplina disponível para este período'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final discipline = snapshot.data![index];
                    return CheckboxListTile(
                      title: Text(discipline.name ?? ''),
                      subtitle: Text('CH: ${discipline.workload}h'),
                      value: _selectedDisciplines.contains(discipline),
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedDisciplines.add(discipline);
                          } else {
                            _selectedDisciplines.remove(discipline);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _selectedDisciplines.isEmpty ? null : _confirmReenrollment,
              child: const Text('Confirmar Matrícula'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReenrollment() async {
    try {
      await DisciplineService.sendReenrollment(_studentId, _nextPeriod, _selectedDisciplines);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rematrícula confirmada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao confirmar rematrícula: $e')),
      );
    }
  }
}