import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'note.dart'; // Adjust the import path as needed
import 'note_details.dart'; // Adjust the import path as needed

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  void _navigateAndDisplayNoteDetail(BuildContext context, {Note? note, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          // Update existing note
          _notes[index] = Note.fromContent(result['note'], imagePath: result['image']);
        } else {
          // Add new note
          _notes.add(Note.fromContent(result['note'], imagePath: result['image']));
        }
      });
    }
  }

  void _deleteNoteAtIndex(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes',
      style: TextStyle(fontSize: 20),)),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          var note = _notes[index];
          // Format the createdAt date to display only month/day/year
          String formattedDate = DateFormat('MM/dd/yyyy').format(note.createdAt);
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$formattedDate', // Use the formatted date string
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteNoteAtIndex(index),
              ),
              onTap: () => _navigateAndDisplayNoteDetail(context, note: note, index: index),
            ),
          );
        },
      ),
floatingActionButton: SizedBox(
  width: 50, // Adjust the width to change the size
  height: 50, // Adjust the height to change the size
  child: FloatingActionButton(
    shape: CircleBorder(),
    onPressed: () => _navigateAndDisplayNoteDetail(context),
    tooltip: 'Add Note',
    backgroundColor: Color.fromARGB(255, 43, 148, 96),
    child: Icon(Icons.add, size: 25, color: Colors.white), // Adjust the icon size and color
  ),
),
    );
  }
}
