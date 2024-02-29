import 'package:flutter/material.dart';
import 'package:organi/notes/notes_page.dart';
import 'todo/todo_page.dart';
import 'reminder/calendar_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Organify',
      theme: ThemeData(
        // Your theme data remains the same
      ),
      home: LandingPage(), // Directly set LandingPage as home
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Future.delayed to navigate to MainPage after 0.3 seconds
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainPage(), // Navigate to MainPage
        ),
      );
    });

    // Return a simple scaffold with a centered loading indicator
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _widgetOptions = [
    TodoPage(),
    CalendarPage(),
    NotesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.calendar_today, size: 30, color: Colors.white),
          Icon(Icons.note, size: 30, color: Colors.white),
        ],
        color: Color.fromARGB(255, 36, 35, 35), // Grey for the navigation bar background
        buttonBackgroundColor: Color.fromARGB(255, 43, 148, 96), // Vibrant blue for the selected item background
        backgroundColor: Colors.transparent, // Light grey for the navigation bar's inactive background
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
