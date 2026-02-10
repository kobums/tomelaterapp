class Question {
  final int id;
  final String content;
  final int month;
  final int day;
  final String createdAt;
  final String updatedAt;

  Question({
    required this.id,
    required this.content,
    required this.month,
    required this.day,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      content: json['content'],
      month: json['month'],
      day: json['day'],
      createdAt: json['created_at'] ?? json['createdAt'] ?? '', // handle null safety
      updatedAt: json['updated_at'] ?? json['updatedAt'] ?? '',
    );
  }
}
