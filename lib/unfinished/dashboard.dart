import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

// TodoPage
class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample todo list. Replace it with your actual todo list.
    final List<String> todos = [];

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: todos.isEmpty
          ? Center(
              child: Text(
                'No task to be completed',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index]),
                );
              },
            ),
    );
  }
}

// NotesPage
class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample notes list. Replace it with your actual notes list.
    final List<String> notes = [];

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: notes.isEmpty
          ? Center(
              child: Text(
                'No notes',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                );
              },
            ),
    );
  }
}

// DashboardPage
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            title: Text(
              'Dashboard',
              style: TextStyle(fontSize: 23),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'To-Do List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TodoPage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Notes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          NotesPage(),
        ],
      ),
    );
  }
}
