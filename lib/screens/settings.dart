import 'package:flutter/material.dart';
import 'package:study_planner_app/providers/task_provider.dart';
import 'package:study_planner_app/services/json_storage.dart';
import 'package:study_planner_app/services/sqlite_storage.dart';

// Settings Screen
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TaskProvider _taskProvider;
  bool _notificationsEnabled = true;
  String _selectedStorage = 'Local';
  bool _showStorageDropdown = false;

  @override
  void initState() {
    super.initState();
    _taskProvider = TaskProvider(storage: JsonStorageService());
    _notificationsEnabled = _taskProvider.remindersEnabled;
    _selectedStorage = _taskProvider.storageType.contains('JSON')
        ? 'JSON'
        : 'SQLite';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white,),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications'); 
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Notifications',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                        _taskProvider.toggleReminders(value);
                      });
                    },
                    activeColor: Color(0xFFFAC606),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                Divider(color: Colors.white24, height: 1),
                ListTile(
                  title: Text('Storage', style: TextStyle(color: Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedStorage,
                        style: TextStyle(color: Colors.white70),
                      ),
                      Icon(Icons.arrow_right, color: Colors.white70),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _showStorageDropdown = !_showStorageDropdown;
                    });
                  },
                ),
                if (_showStorageDropdown)
                  Container(
                    color: Colors.white.withOpacity(0.05),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: Text(
                            'JSON (SharedPreferences)',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 'JSON',
                          groupValue: _selectedStorage,
                          onChanged: (value) async {
                            setState(() {
                              _selectedStorage = value!;
                              _showStorageDropdown = false;
                            });

                            // Migrate data to new storage
                            final currentTasks = _taskProvider.tasks;
                            _taskProvider.changeStorage(JsonStorageService());
                            for (var task in currentTasks) {
                              await _taskProvider.addTask(task);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Switched to JSON storage'),
                                backgroundColor: Color(0xFFFAC606),
                              ),
                            );
                          },
                          activeColor: Color(0xFFFAC606),
                        ),
                        RadioListTile<String>(
                          title: Text(
                            'SQLite Database',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 'SQLite',
                          groupValue: _selectedStorage,
                          onChanged: (value) async {
                            setState(() {
                              _selectedStorage = value!;
                              _showStorageDropdown = false;
                            });

                            // Migrate data to new storage
                            final currentTasks = _taskProvider.tasks;
                            _taskProvider.changeStorage(SqliteStorageService());
                            for (var task in currentTasks) {
                              await _taskProvider.addTask(task);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Switched to SQLite storage'),
                                backgroundColor: Color(0xFFFAC606),
                              ),
                            );
                          },
                          activeColor: Color(0xFFFAC606),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: TextStyle(
                    color: Color(0xFFFAC606),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Version', style: TextStyle(color: Colors.white70)),
                    Text('1.0.0', style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Storage Type',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      _taskProvider.storageType,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Tasks',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '${_taskProvider.tasks.length}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
