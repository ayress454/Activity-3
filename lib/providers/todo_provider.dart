import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  List<String> _todos = [];

  List<String> get todos => _todos;

  void addTodo(String task) {
    _todos.add(task);
    notifyListeners();
  }

  void removeTodo(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }
}
