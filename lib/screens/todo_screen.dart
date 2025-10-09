import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _taskCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks (To-Do List)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskCtrl,
              decoration: const InputDecoration(
                  labelText: 'Add Task (e.g., Prepare Documents)'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskCtrl.text.isNotEmpty) {
                  context.read<TodoProvider>().addTodo(_taskCtrl.text);
                  _taskCtrl.clear();
                }
              },
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todo, child) {
                  if (todo.todos.isEmpty) {
                    return const Center(child: Text('No tasks yet'));
                  }
                  return ListView.builder(
                    itemCount: todo.todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(todo.todos[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => todo.removeTodo(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }
}
