import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';
import '../widgets/add_task_field.dart';
import '../widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    await _todosCollection.add({
      'task': _taskController.text.trim(),
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _taskController.clear();
  }

  Future<void> _toggleComplete(String id, bool currentStatus) async {
    await _todosCollection.doc(id).update({'completed': !currentStatus});
  }

  Future<void> _deleteTask(String id) async {
    await _todosCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List 🩷'),
        backgroundColor: Colors.pink.shade200,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          AddTaskField(controller: _taskController, onAdd: _addTask),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _todosCollection
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet 💭\nAdd something to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final todos = snapshot.data!.docs
                    .map((doc) => Todo.fromDocument(doc))
                    .toList();

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoTile(
                      todo: todo,
                      onToggle: () => _toggleComplete(todo.id, todo.completed),
                      onDelete: () => _deleteTask(todo.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
