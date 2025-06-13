import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import '../models/discipline.dart';
import '../services/discipline_service.dart';

class ReenrollmentScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const ReenrollmentScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
  }) : super(key: key);

  @override
  _ReenrollmentScreenState createState() => _ReenrollmentScreenState();
}

class _ReenrollmentScreenState extends State<ReenrollmentScreen> {
  late Future<List<Discipline>> _disciplinesFuture;
  final Map<String, bool> _selectedDisciplines = {};
  final int _nextPeriod = 3;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _disciplinesFuture = DisciplineService.getDisciplinasPorPeriodo(
      widget.studentId,
      _nextPeriod,
    );
  }

  void _toggleDisciplineSelection(String code) {
    setState(() {
      _selectedDisciplines[code] = !(_selectedDisciplines[code] ?? false);
    });
  }

  Future<void> _generateAndSavePdf(List<Discipline> disciplines) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'Comprovante de Rematrícula',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Text(
              'Aluno: ${widget.studentName}',
              style: const pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Matrícula: ${widget.studentId}',
              style: const pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Período: $_nextPeriod',
              style: const pw.TextStyle(fontSize: 16),
            ),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),
            pw.Text(
              'Disciplinas Matriculadas:',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.ListView.builder(
              itemCount: disciplines.length,
              itemBuilder: (pw.Context context, int index) {
                final discipline = disciplines[index];
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Text('• ', style: const pw.TextStyle(fontSize: 14)),
                      pw.Expanded(
                        child: pw.Text(
                          '${discipline.code} - ${discipline.name}',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text(
                'Data: ${DateTime.now().toString().substring(0, 10)}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await Printing.layoutPdf(
          onLayout: (format) => pdf.save(),
          name: 'Comprovante_Rematricula_${widget.studentName}',
        );
      } else {
        _showPdfUnavailableDialog(context);
      }
    } catch (e) {
      _showPdfErrorDialog(context, e);
    }
  }

  void _showPdfUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Funcionalidade não disponível'),
        content: const Text('A geração de PDF não está disponível nesta plataforma.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPdfErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro ao gerar PDF'),
        content: Text('Ocorreu um erro: ${error.toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReenrollment(List<Discipline> disciplines) async {
    setState(() => _isSubmitting = true);

    try {
      await DisciplineService.sendReenrollment(
        widget.studentId,
        _nextPeriod,
        disciplines,
      );

      await _generateAndSavePdf(disciplines);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rematrícula realizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar rematrícula: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rematrícula Online',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Discipline>>(
        future: _disciplinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar disciplinas\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final disciplines = snapshot.data ?? [];

          if (disciplines.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma disciplina disponível para rematrícula neste período.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: disciplines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final discipline = disciplines[index];
                    return CheckboxListTile(
                      title: Text(
                        discipline.name ?? 'Disciplina sem nome',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Código: ${discipline.code} | CH: ${discipline.workload}h',
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: _selectedDisciplines[discipline.code ?? ''] ?? false,
                      onChanged: (_) => _toggleDisciplineSelection(discipline.code ?? ''),
                      activeColor: Colors.blue.shade900,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            final selected = disciplines
                                .where((d) => _selectedDisciplines[d.code ?? ''] == true)
                                .toList();

                            if (selected.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Selecione pelo menos uma disciplina'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            _submitReenrollment(selected);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'CONFIRMAR REMATRÍCULA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}