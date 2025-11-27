class Todo {
  final String? title;
  final String? subtitle;
  final String? description;
  final String? id;
  final bool? complete;
  Todo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.id,
    required this.complete,
  });

  factory Todo.fromMap(Map<String, dynamic> map, String docId) {
    return Todo(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      id: docId,
      complete: map['complete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'subtitle': subtitle, 'description': description};
  }

  Todo copyWith({
    String? title,
    String? subtitle,
    String? description,
    String? id,
    bool? complete,
  }) {
    return Todo(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      id: id ?? this.id,
      complete: complete ?? this.complete,
    );
  }
}
