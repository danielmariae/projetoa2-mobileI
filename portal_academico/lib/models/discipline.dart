  class Discipline {
    final String? id;
    final String? studentId;
    final String? code;
    final String? name;
    final int? period; // Período
    final int? workload; // Carga horária
    final int? faults;
    final double? test1; // Nota
    final double? test2; // Nota
    final double? finalExam; // Exame Final Nota
    final double? finalMedia;
    final int? frequency; // Frequência em porcentagem
    final String? status; // Aprovado, Reprovado, Pendente, Cursando

    Discipline({
      this.id,
      this.studentId,
      this.code,
      this.name,
      this.period,
      this.workload,
      this.faults,
      this.test1,
      this.test2,
      this.finalExam,
      this.finalMedia,
      this.frequency,
      this.status,
    });


  factory Discipline.fromJson(Map<String, dynamic> json) {
    return Discipline(
      id: json['id']?.toString(),
      studentId: json['studentId']?.toString(),
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      period: json['period'] != null ? int.tryParse(json['period'].toString()) : null,
      workload: json['workload'] != null ? int.tryParse(json['workload'].toString()) : null,
      faults: json['faults'] != null ? int.tryParse(json['faults'].toString()) : null,
      test1: json['test1'] != null ? double.tryParse(json['test1'].toString()) : null,
      test2: json['test2'] != null ? double.tryParse(json['test2'].toString()) : null,
      finalExam: json['finalExam'] != null ? double.tryParse(json['finalExam'].toString()) : null,
      finalMedia: json['finalMedia'] != null ? double.tryParse(json['finalMedia'].toString()) : null,
      frequency: json['frequency'] != null ? int.tryParse(json['frequency'].toString()) : null,
      status: json['status']?.toString(),
    );
  }

  }
