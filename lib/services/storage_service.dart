import 'package:study_planner_app/models/task.dart'; 

// Storage Interface
abstract class StorageService {
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  Future<void> deleteTask(String id);
  String getStorageType();
}
