import 'package:cloud_firestore/cloud_firestore.dart';
class Note {
  final String? id;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;

  Note({
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  factory Note.fromFireStore(Map<String, dynamic> data) {
    return Note(
      id: data['note_id'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      userId: data['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "note_id": id,
      'title': title,
      'content': content,
      'created_at': Timestamp.fromDate(createdAt!),
      'updated_at': Timestamp.fromDate(updatedAt!),
      'user_id': userId,
    };
  }
}