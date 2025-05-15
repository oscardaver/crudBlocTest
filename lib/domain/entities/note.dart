class Note {
  final int id; // Cambiado a no-nullable (siempre debe tener ID)
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  Note({
    required this.id, // Ahora es requerido
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.userId,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int, // Aseguramos que es int
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      userId: map['user_id'] as int,
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? userId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId)';
  }
}