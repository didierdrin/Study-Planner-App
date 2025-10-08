import 'package:flutter/material.dart'; 
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/json_storage.dart';
import 'package:study_planner_app/providers/task_provider.dart'; 

// Notifications Screen
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = TaskProvider(storage: JsonStorageService());

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<void>(
        future: taskProvider.loadTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFFAC606)),
            );
          }

          final notifications = _generateNotifications(taskProvider.tasks);

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                color: Colors.white.withOpacity(0.1),
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFFAC606),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: Color(0xFF031438),
                    ),
                  ),
                  title: Text(
                    notification['title'] as String,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    notification['subtitle'] as String,
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    notification['time'] as String,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _generateNotifications(List<Task> tasks) {
    final notifications = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (var task in tasks) {
      // Task created notification
      notifications.add({
        'icon': Icons.add_task,
        'title': 'Task Created: ${task.title}',
        'subtitle': 'Due on ${_formatDate(task.dueDate)}',
        'time': _getRelativeTime(task.dueDate),
      });

      // Reminder notifications
      if (task.notify1DayBefore) {
        final reminderTime = task.dueDate.subtract(Duration(days: 1));
        if (reminderTime.isAfter(now)) {
          notifications.add({
            'icon': Icons.notification_important,
            'title': 'Reminder Set: ${task.title}',
            'subtitle': '1 day before - ${_formatDate(reminderTime)}',
            'time': _getRelativeTime(reminderTime),
          });
        }
      }

      if (task.notify1HourBefore) {
        final reminderTime = task.dueDate.subtract(Duration(hours: 1));
        if (reminderTime.isAfter(now)) {
          notifications.add({
            'icon': Icons.access_time,
            'title': 'Reminder Set: ${task.title}',
            'subtitle': '1 hour before - ${_formatTime(reminderTime)}',
            'time': _getRelativeTime(reminderTime),
          });
        }
      }

      // Due soon notification (within 10 minutes)
      final diff = task.dueDate.difference(now);
      if (diff.inMinutes > 0 && diff.inMinutes <= 10) {
        notifications.add({
          'icon': Icons.warning,
          'title': 'Task Due Soon: ${task.title}',
          'subtitle': 'Due in ${diff.inMinutes} minutes',
          'time': 'Now',
        });
      }
    }

    // Sort by most recent first
    notifications.sort((a, b) {
      if (a['time'] == 'Now') return -1;
      if (b['time'] == 'Now') return 1;
      return 0;
    });

    return notifications;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inMinutes < 0) {
      return 'Past';
    } else if (diff.inMinutes < 60) {
      return 'In ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'In ${diff.inHours} hours';
    } else {
      return 'In ${diff.inDays} days';
    }
  }
}
