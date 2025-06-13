import 'package:flutter/material.dart';

class CourseProgressIndicator extends StatelessWidget {
  final int progress;

  const CourseProgressIndicator({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
          minHeight: 20,
        ),
        const SizedBox(height: 8),
        Text(
          '$progress% concluído',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}