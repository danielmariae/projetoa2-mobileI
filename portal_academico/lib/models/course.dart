class Course {
  final String name;
  final String modality;
  final String status;

  Course({
    required this.name,
    required this.modality,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      modality: json['modality'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'modality': modality,
    'status': status,
  };
}
