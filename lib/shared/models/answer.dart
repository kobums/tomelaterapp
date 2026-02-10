import 'package:app/shared/models/question.dart';

class Answer {
  final int id;
  final int userId;
  final int questionId;
  final String content;
  final bool isPublic;
  final Question? question;
  final String createdAt;
  final String updatedAt;

  Answer({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.content,
    required this.isPublic,
    this.question,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? questionJson;
    
    // Check 'extra' field first for question data
    if (json['extra'] != null && json['extra'] is Map<String, dynamic>) {
      final extra = json['extra'] as Map<String, dynamic>;
      if (extra['question'] != null) {
        questionJson = extra['question'];
      }
    }
    
    // Fallback to root 'question' field if not found in extra
    if (questionJson == null && json['question'] != null) {
      questionJson = json['question'];
    }

    return Answer(
      id: json['id'],
      userId: json['user_id'] ?? json['userId'] ?? json['uid'],
      questionId: json['question_id'] ?? json['questionId'] ?? json['qid'],
      content: json['content'],
      isPublic: (json['ispublic'] == 'PUBLIC' || json['ispublic'] == 2) || 
                (json['isPublic'] == 'PUBLIC' || json['isPublic'] == 2),
      question: questionJson != null ? Question.fromJson(questionJson) : null,
      createdAt: json['created_at'] ?? json['createdAt'] ?? json['createdat'] ?? '',
      updatedAt: json['updated_at'] ?? json['updatedAt'] ?? json['updatedat'] ?? '',
    );
  }
}
