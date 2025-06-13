import 'document.dart';

class Student {
  final String id;
  final String registrationNumber;
  final String name;
  final String email;
  final String password;
  final String status; // Matriculado, Ativo, etc.
  final String course;
  final int progress;
  final int period;
  final List<Document> documents;
  bool canReenroll; // Se pode fazer rematrícula

  Student({
    required this.id,
    required this.registrationNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.course,
    required this.progress,
    required this.period,
    required this.documents,
    this.canReenroll = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'name': name,
      'email': email,
      'password': password,
      'status': status,
      'course': course,
      'progress': progress,
      'period': period,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'canReenroll': canReenroll,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    var documentsJson = json['documents'] as List;
    List<Document> documentsList =
        documentsJson.map((docJson) => Document.fromJson(docJson)).toList();

    return Student(
      id: json['id'],
      registrationNumber: json['registrationNumber'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      status: json['status'],
      course: json['course'],
      progress: json['progress'],
      period: json['period'],
      documents: documentsList,
      canReenroll: json['canReenroll'],
    );
  }
}
