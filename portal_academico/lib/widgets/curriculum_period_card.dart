import 'package:flutter/material.dart';
import '../models/discipline.dart';

class CurriculumPeriodCard extends StatelessWidget {
  final String period;
  final List<Discipline> disciplines;

  const CurriculumPeriodCard({
    Key? key,
    required this.period,
    required this.disciplines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Período $period',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...disciplines.map((discipline) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(discipline.name ?? 'Disciplina sem nome'),
                  ),
                  Chip(
                    label: Text('${discipline.workload}h'),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}