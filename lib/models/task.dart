
// Models
class Task {
  String id;
  String title;
  String? description;
  DateTime dueDate;
  DateTime? reminderTime;
  bool notify1DayBefore;
  bool notify1HourBefore;

  Task({
    String? id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderTime,
    this.notify1DayBefore = false,
    this.notify1HourBefore = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'reminderTime': reminderTime?.toIso8601String(),
        'notify1DayBefore': notify1DayBefore,
        'notify1HourBefore': notify1HourBefore,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        reminderTime: json['reminderTime'] != null
            ? DateTime.parse(json['reminderTime'])
            : null,
        notify1DayBefore: json['notify1DayBefore'] ?? false,
        notify1HourBefore: json['notify1HourBefore'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.millisecondsSinceEpoch,
        'reminderTime': reminderTime?.millisecondsSinceEpoch,
        'notify1DayBefore': notify1DayBefore ? 1 : 0,
        'notify1HourBefore': notify1HourBefore ? 1 : 0,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
        reminderTime: map['reminderTime'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['reminderTime'])
            : null,
        notify1DayBefore: map['notify1DayBefore'] == 1,
        notify1HourBefore: map['notify1HourBefore'] == 1,
      );
}