import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'package:dio/dio.dart';

import '../services/db_helper.dart';

class TodoProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<TodoModel> _todos = [];
  List<TodoModel> _completed = [];
  List<TodoModel> _inProgress = [];
  bool _isLoading = false;
  int _limit = 15;
  int _offset = 0;
  bool _hasMore = true;

  List<TodoModel> get todos => _todos;
  List<TodoModel> get completed => _completed;
  List<TodoModel> get inProgress => _inProgress;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchAndStoreTodos() async {
    try {
      Response response =
      await _dio.get('https://jsonplaceholder.typicode.com/todos');
      List<TodoModel> todos = (response.data as List)
          .map((json) => TodoModel.fromJson(json))
          .toList();

      await _dbHelper.insertTodos(todos);

      // Add fetched todos to `_todos` list
      _todos.clear(); // Clear old data before adding new ones
      _completed.clear();
      _inProgress.clear();
      _todos.addAll(await _dbHelper.getPendingTodos(_limit, _offset));
      _completed.addAll(await _dbHelper.getCompletedTasks(_limit, _offset));
      _inProgress.addAll(await _dbHelper.getInProgressTasks());
      notifyListeners();
    } catch (e) {
      print("API Fetch Error: $e");
    }
  }

  Future<void> loadMoreInProgress() async {
    try {
      _isLoading = true;
      notifyListeners();

      _inProgress.clear();
      _inProgress.addAll(await _dbHelper.getInProgressTasks());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Load More Error: $e");
    }
  }

  Future<void> loadMoreTodos() async {
    if (_isLoading || !_hasMore) return;
    try {
      _isLoading = true;
      notifyListeners();

      List<TodoModel> newTodos = await _dbHelper.getPendingTodos(_limit, _offset);

      if (newTodos.isNotEmpty) {
        _todos.addAll(newTodos); //Append new todos correctly
        _offset += _limit;
      } else {
        _hasMore = false;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Load More Error: $e");
    }
  }

  Future<void> loadMoreCompleted() async {
    if (_isLoading || !_hasMore) return;
    try {
      _isLoading = true;
      notifyListeners();

      List<TodoModel> newTodos = await _dbHelper.getCompletedTasks(_limit, _offset);

      if (newTodos.isNotEmpty) {
        _completed.addAll(newTodos); //Append new todos correctly
        _offset += _limit;
      } else {
        _hasMore = false;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Load More Error: $e");
    }
  }

  void deleteTodo(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _dbHelper.deleteTodo(id); // Delete from local SQLite DB
    notifyListeners();
  }

  void deleteCompleted(int id) async {
    _completed.removeWhere((todo) => todo.id == id);
    await _dbHelper.deleteTodo(id); // Delete from local SQLite DB
    notifyListeners();
  }

  void deleteInProgress(int id) async {
    _inProgress.removeWhere((todo) => todo.id == id);
    await _dbHelper.deleteTodo(id); // Delete from local SQLite DB
    notifyListeners();
  }


  void updateTodo(BuildContext context, TodoModel todo, String newTitle, String newStatus, String newPriority,int id) async {
    //final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    // Determine status
    bool isCompleted = newStatus == "Completed";
    bool isInProgress = newStatus == "In Progress";

    if(!todo.completed && !todo.inProgress){
      _todos.removeWhere((todo) => todo.id == id);
    }

    else if(todo.inProgress){
      _inProgress.removeWhere((todo) => todo.id == id);
    }


    // Update database
    await DatabaseHelper.instance.updateTodo(
      todo.id,
      title: newTitle,
      completed: isCompleted,
      inProgress: isInProgress,
      priority: newPriority,
    );

    if(newStatus == "Completed"){
      _completed.add(todo);
    }
    else if(newStatus == "In Progress"){
      _inProgress.clear();
      _inProgress.addAll(await _dbHelper.getInProgressTasks());
    }
    else{
      _todos.add(todo);
    }

    print(_inProgress.length);

    _isLoading = false;
    notifyListeners();

    // Refresh UI
    //todoProvider.refreshTodos();
  }

}
