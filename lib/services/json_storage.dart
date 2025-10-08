import 'package:study_planner_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_planner_app/models/task.dart'; 
import 'dart:convert';
import 'dart:async';

// JSON Storage Implementation
class JsonStorageService implements StorageService {
  static const String _key = 'tasks';

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_key, jsonEncode(tasksJson));
  }

  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_key);
    if (tasksString == null) return [];
    
    final tasksList = jsonDecode(tasksString) as List;
    return tasksList.map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }

  @override
  String getStorageType() => 'JSON (SharedPreferences)';
}
