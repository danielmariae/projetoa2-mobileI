class Reenrollment {
  final List<String> selectedDisciplines;
  final bool isCompleted;

  Reenrollment({
    required this.selectedDisciplines,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedDisciplines': selectedDisciplines,
      'isCompleted': isCompleted,
    };
  }

  factory Reenrollment.fromJson(Map<String, dynamic> json) {
    return Reenrollment(
      selectedDisciplines: List<String>.from(json['selectedDisciplines']),
      isCompleted: json['isCompleted'],
    );
  }
}