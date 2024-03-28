import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note.dart';
import 'note_details.dart';
import 'package:flutter/cupertino.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _addSampleNotes();
  }

  void _addSampleNotes() {
    _notes.addAll([
      Note(
        title: 'Physics Homework',
        content: 'Solve Chapter 5 problems\nRead Chapter 6 for next class',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Chemistry Experiment',
        content:
            'Prepare lab equipment\nMix chemicals carefully\nRecord observations',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'History Essay',
        content:
            'Research about World War II\nWrite a 5-page essay\nInclude references',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Mathematics Assignment',
        content: 'Complete exercises 1-10\nSubmit assignment by Friday',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Literature Reading',
        content:
            'Read chapters 1-3 of "To Kill a Mockingbird"\nTake notes on themes and characters',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Biology Project',
        content:
            'Prepare presentation slides\nPractice presentation\nGather research materials',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Computer Science Coding Assignment',
        content:
            'Write a program to calculate factorial\nImplement bubble sort algorithm',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Geography Quiz Preparation',
        content:
            'Study continents and oceans\nReview maps\nTake practice quizzes',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Art Portfolio',
        content: 'Sketch landscapes\nPaint still life\nDesign a self-portrait',
        createdAt: DateTime.now(),
      ),
      Note(
        title: 'Physical Education Training',
        content:
            'Practice running\nWork on strength training\nStretching exercises',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  void _navigateAndDisplayNoteDetail(BuildContext context,
      {Note? note, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _notes[index] =
              Note.fromContent(result['note'], imagePath: result['image']);
        } else {
          _notes.add(
              Note.fromContent(result['note'], imagePath: result['image']));
        }
      });
    }
  }

  void _deleteNoteAtIndex(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  String _getFirstLine(String text) {
    if (text.length > 35) {
      return text.substring(0, 35);
    }
    return text;
  }

  String _getRemainingContent(String text) {
    List<String> lines = text.split('\n');

    if (lines.length > 1) {
      return lines.skip(1).join('\n');
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                var note = _notes[index];
                String formattedDate =
                    DateFormat('MM/dd/yyyy').format(note.createdAt);
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getFirstLine(note.content),
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _getRemainingContent(note.content),
                          style: TextStyle(color: textColor, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNoteAtIndex(index),
                    ),
                    onTap: () => _navigateAndDisplayNoteDetail(context,
                        note: note, index: index),
                    // onLongPress: () => _shareNoteContent(note.content), // Share the note content on long press
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () => _navigateAndDisplayNoteDetail(context),
          tooltip: 'Add Note',
          backgroundColor: Color.fromARGB(255, 43, 148, 96),
          child: Icon(Icons.add, size: 25, color: Colors.white),
        ),
      ),
    );
  }
}
