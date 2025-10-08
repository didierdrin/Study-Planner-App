import 'package:flutter/material.dart'; 
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/json_storage.dart';
import 'package:study_planner_app/providers/task_provider.dart'; 
import 'package:table_calendar/table_calendar.dart';

// Calendar Screen
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late TaskProvider _taskProvider;
  Map<DateTime, List<Task>> _events = {};

  @override
  void initState() {
    super.initState();
    _taskProvider = TaskProvider(storage: JsonStorageService());
    _selectedDay = DateTime.now();
    _loadEvents();
  }

  void _loadEvents() async {
    await _taskProvider.loadTasks();
    setState(() {
      _events = {};
      for (var task in _taskProvider.tasks) {
        final date = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
        if (_events[date] != null) {
          _events[date]!.add(task);
        } else {
          _events[date] = [task];
        }
      }
    });
  }

  List<Task> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Study Planner'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TableCalendar<Task>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Color(0xFF031438)),
                  defaultTextStyle: TextStyle(color: Color(0xFF031438)),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFFAC606),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Color(0xFF031438)),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF031438).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Color(0xFFFAC606),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Color(0xFF031438),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF031438)),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF031438)),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            SizedBox(height: 16),
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
                      'Tasks for ${_selectedDay != null ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}' : 'Selected Date'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: _selectedDay == null
                          ? Center(
                              child: Text(
                                'Select a date to view tasks',
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : _getEventsForDay(_selectedDay!).isEmpty
                              ? Center(
                                  child: Text(
                                    'No tasks for this date',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _getEventsForDay(_selectedDay!).length,
                                  itemBuilder: (context, index) {
                                    final task = _getEventsForDay(_selectedDay!)[index];
                                    return Card(
                                      color: Colors.white.withOpacity(0.1),
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      child: ListTile(
                                        title: Text(
                                          task.title,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (task.description != null)
                                              Text(
                                                task.description!,
                                                style: TextStyle(color: Colors.white54),
                                              ),
                                            Text(
                                              'Time: ${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}',
                                              style: TextStyle(color: Color(0xFFFAC606)),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            await _taskProvider.deleteTask(task.id);
                                            _loadEvents();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}