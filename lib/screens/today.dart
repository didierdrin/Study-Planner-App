import 'package:flutter/material.dart'; 
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/json_storage.dart';
import 'package:study_planner_app/providers/task_provider.dart'; 

// Today Screen
class TodayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = TaskProvider(storage: JsonStorageService());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remind tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: FutureBuilder<List<Task>>(
                        future: taskProvider.loadTasks().then((_) => taskProvider.getTodayTasks()),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No tasks for today',
                                style: TextStyle(color: Colors.white54),
                              ),
                            );
                          }
                          
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final task = snapshot.data![index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Text('• ', style: TextStyle(color: Colors.white, fontSize: 20)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title,
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                          if (task.description != null && task.description!.isNotEmpty)
                                            Text(
                                              task.description!,
                                              style: TextStyle(color: Colors.white54, fontSize: 14),
                                            ),
                                          Text(
                                            'Due: ${_formatTime(task.dueDate)}',
                                            style: TextStyle(color: Color(0xFFFAC606), fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new-task');
              },
              child: Text('New Task'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}