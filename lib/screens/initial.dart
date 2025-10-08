import 'package:flutter/material.dart'; 
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/screens/calendar.dart';
import 'package:study_planner_app/screens/settings.dart';
import 'package:study_planner_app/screens/today.dart';
import 'package:study_planner_app/services/json_storage.dart';
import 'package:study_planner_app/providers/task_provider.dart'; 


// Main Screen with Bottom Navigation
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late TaskProvider _taskProvider;

  @override
  void initState() {
    super.initState();
    _taskProvider = TaskProvider(storage: JsonStorageService());
    // Check for reminders when app opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowReminders();
    });
  }

  void _checkAndShowReminders() {
    if (!_taskProvider.remindersEnabled) return;

    final now = DateTime.now();
    final tasks = _taskProvider.getTodayTasks();

    for (var task in tasks) {
      if (task.reminderTime != null) {
        final diff = task.reminderTime!.difference(now);
        if (diff.inMinutes.abs() < 10) {
          _showReminderDialog(task);
          break;
        }
      }
    }
  }

  void _showReminderDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF031438),
        title: Text('Reminder', style: TextStyle(color: Colors.white)),
        content: Text(
          'Task "${task.title}" is due soon!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Dismiss', style: TextStyle(color: Color(0xFFFAC606))),
          ),
        ],
      ),
    );
  }

  final List<Widget> _screens = [
    TodayScreen(),
    CalendarScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
