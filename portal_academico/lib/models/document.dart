class Document {
  final String type;
  final String status;

  Document({
    required this.type,
    required this.status
  });

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'isRequired': status
    };
  }

  // Criar a partir de JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      type: json['type'],
      status: json['status']
    );
  }
}