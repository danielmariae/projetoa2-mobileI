import 'package:flutter/material.dart';
import '../models/discipline.dart';

class GradeCard extends StatelessWidget {
  final Discipline discipline;

  const GradeCard({Key? key, required this.discipline}) : super(key: key);

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
              discipline.name ?? 'Disciplina sem nome',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nota 1: ${discipline.test1?.toStringAsFixed(1) ?? '-'}'),
                Text('Nota 2: ${discipline.test2?.toStringAsFixed(1) ?? '-'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exame Final: ${discipline.finalExam?.toStringAsFixed(1) ?? '-'}'),
                Text('Média Final: ${discipline.finalMedia?.toStringAsFixed(1) ?? '-'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Frequência: ${discipline.frequency?.toString() ?? '-'}%'),
                Chip(
                  label: Text(discipline.status ?? 'Status desconhecido'),
                  backgroundColor: _getStatusColor(discipline.status),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'aprovado':
        return Colors.green.shade100;
      case 'reprovado':
        return Colors.red.shade100;
      case 'cursando':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}