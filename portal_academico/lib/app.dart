import 'package:flutter/material.dart';
import 'package:portal_academico/screens/analysis_screen.dart';
import 'package:portal_academico/screens/boletin_screen.dart';
import 'package:portal_academico/screens/grade_screen.dart';
import 'package:portal_academico/screens/reenrollment_screen.dart';
import 'package:portal_academico/screens/situation_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Acadêmico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/boletim': (context) => const BoletimScreen(),
        '/grade': (context) => const GradeScreen(),
        '/rematricula': (context) => const ReenrollmentScreen(studentName: 'Lucas Santos', studentId: '2'),
        '/situacao': (context) => const SituationScreen(),
        '/analise': (context) => const AnalysisScreen(),
      },
    );
  }
}
