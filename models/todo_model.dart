import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String task;
  final bool completed;
  final Timestamp? createdAt;

  Todo({
    required this.id,
    required this.task,
    required this.completed,
    required this.createdAt,
  });

  factory Todo.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      task: data['task'] ?? '',
      completed: data['completed'] ?? false,
      createdAt: data['createdAt'],
    );
  }
}
