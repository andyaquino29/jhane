import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'package:intl/intl.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  String _formatTimestamp(date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy – hh:mm a').format(date.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: todo.completed ? Colors.pink.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: todo.completed ? Colors.pink : Colors.pink.shade200,
          ),
          onPressed: onToggle,
        ),
        title: Text(
          todo.task,
          style: TextStyle(
            decoration:
                todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
            color: todo.completed ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _formatTimestamp(todo.createdAt),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.pinkAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
