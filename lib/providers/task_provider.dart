import 'package:flutter/material.dart';
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/storage_service.dart';
import 'dart:async';


// Task Provider
class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  StorageService _storage;
  bool _remindersEnabled = true;
  Timer? _reminderTimer;

  TaskProvider({required StorageService storage}) : _storage = storage {
    loadTasks();
    _startReminderCheck();
  }

  List<Task> get tasks => _tasks;
  bool get remindersEnabled => _remindersEnabled;
  String get storageType => _storage.getStorageType();

  void changeStorage(StorageService newStorage) {
    _storage = newStorage;
    loadTasks();
    notifyListeners();
  }

  void toggleReminders(bool value) {
    _remindersEnabled = value;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await _storage.loadTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _storage.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _storage.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _storage.deleteTask(id);
    notifyListeners();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks
        .where(
          (task) =>
              task.dueDate.year == date.year &&
              task.dueDate.month == date.month &&
              task.dueDate.day == date.day,
        )
        .toList();
  }

  List<Task> getTodayTasks() {
    final now = DateTime.now();
    return getTasksForDate(now);
  }

  void _startReminderCheck() {
    _reminderTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (_remindersEnabled) {
        _checkReminders();
      }
    });
  }

  void _checkReminders() {
    final now = DateTime.now();
    for (var task in _tasks) {
      if (task.reminderTime != null) {
        final diff = task.reminderTime!.difference(now);

        // Check for 1 day before reminder
        if (task.notify1DayBefore && diff.inHours >= 23 && diff.inHours <= 24) {
          // Trigger reminder
        }

        // Check for 1 hour before reminder
        if (task.notify1HourBefore &&
            diff.inMinutes >= 59 &&
            diff.inMinutes <= 60) {
          // Trigger reminder
        }

        // Check for exact time reminder
        if (diff.inMinutes == 0) {
          // Trigger reminder
        }
      }
    }
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }
}
