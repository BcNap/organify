import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'todo/todo_page.dart';
import 'notes/notes_page.dart';
import 'reminder/calendar_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Organify',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _widgetOptions = [
    TodoPage(),
    CalendarPage(),
    NotesPage(),
  ];

  final List<String> _appBarTitles = [
    'Tasks',
    'Scheduler',
    'Notes',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _appBarTitles[_selectedIndex], // Dynamically set the app bar title
            style: TextStyle(
              fontSize: 26, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.list, size: 30, color: Colors.white),
            Icon(Icons.calendar_today, size: 30, color: Colors.white),
            Icon(Icons.note, size: 30, color: Colors.white),
          ],
          color: _isDarkMode ? Color.fromARGB(255, 36, 35, 35) : Color.fromARGB(255, 36, 35, 35),
          buttonBackgroundColor: Color.fromARGB(255, 43, 148, 96),
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
