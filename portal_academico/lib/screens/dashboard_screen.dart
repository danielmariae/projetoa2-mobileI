import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildDashboardCard(context, 'Boletim', Icons.assignment, '/boletim'),
          _buildDashboardCard(context, 'Grade Curricular', Icons.schedule, '/grade'),
          _buildDashboardCard(context, 'Rematrícula', Icons.edit, '/rematricula'),
          _buildDashboardCard(context, 'Situação Acadêmica', Icons.school, '/situacao'),
          _buildDashboardCard(context, 'Análise Curricular', Icons.analytics, '/analise'),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}