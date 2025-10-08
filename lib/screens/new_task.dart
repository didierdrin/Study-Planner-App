import 'package:flutter/material.dart';
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/json_storage.dart';
import 'package:study_planner_app/providers/task_provider.dart'; 

// New Task Screen
class NewTaskScreen extends StatefulWidget {
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _notify1DayBefore = false;
  bool _notify1HourBefore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                'Title',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Description (Optional)',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Date',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }

                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedTime.format(context)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.calendar_today, color: Colors.white54),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notify me 1 day before',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: _notify1DayBefore,
                    onChanged: (value) {
                      setState(() {
                        _notify1DayBefore = value ?? false;
                      });
                    },
                    fillColor: MaterialStateProperty.all(Color(0xFFFAC606)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notify me 1 hour before',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: _notify1HourBefore,
                    onChanged: (value) {
                      setState(() {
                        _notify1HourBefore = value ?? false;
                      });
                    },
                    fillColor: MaterialStateProperty.all(Color(0xFFFAC606)),
                  ),
                ],
              ),
              if (_notify1DayBefore || _notify1HourBefore) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: Color(0xFFFAC606)),
                      SizedBox(width: 12),
                      Text(
                        _getNotificationTime(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTask,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNotificationTime() {
    final baseTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (_notify1DayBefore) {
      final notifyTime = baseTime.subtract(Duration(days: 1));
      return 'Notification: ${notifyTime.day}/${notifyTime.month} at ${notifyTime.hour}:${notifyTime.minute.toString().padLeft(2, '0')}';
    } else if (_notify1HourBefore) {
      final notifyTime = baseTime.subtract(Duration(hours: 1));
      return 'Notification: ${notifyTime.hour}:${notifyTime.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }

  void _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      dueDate: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      notify1DayBefore: _notify1DayBefore,
      notify1HourBefore: _notify1HourBefore,
      reminderTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
    );

    final taskProvider = TaskProvider(storage: JsonStorageService());
    await taskProvider.addTask(task);

    Navigator.pop(context);
  }
}
