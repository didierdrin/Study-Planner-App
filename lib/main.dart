// main.dart
import 'package:flutter/material.dart';
import 'package:study_planner_app/screens/new_task.dart';
import 'package:study_planner_app/screens/notifications.dart';
import 'package:study_planner_app/screens/settings.dart';
import 'screens/initial.dart';


// Main App
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF031438),
        scaffoldBackgroundColor: Color(0xFF031438),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF031438),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFAC606),
            foregroundColor: Color(0xFF031438),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF031438),
          selectedItemColor: Color(0xFFFAC606),
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/new-task': (context) => NewTaskScreen(),
        '/settings': (context) => SettingsScreen(),
        '/notifications': (context) => NotificationsScreen(),
      },
    );
  }
}
