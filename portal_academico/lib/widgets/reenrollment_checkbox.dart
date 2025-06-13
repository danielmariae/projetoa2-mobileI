import 'package:flutter/material.dart';
import '../models/discipline.dart';

class ReenrollmentCheckbox extends StatelessWidget {
  final Discipline discipline;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ReenrollmentCheckbox({
    Key? key,
    required this.discipline,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(discipline.name ?? 'Disciplina sem nome'),
      subtitle: Text('Período ${discipline.period} - ${discipline.workload}h'),
      value: value,
      onChanged: onChanged,
      secondary: Chip(
        label: Text('${discipline.workload}h'),
        backgroundColor: Colors.blue[50],
      ),
    );
  }
}