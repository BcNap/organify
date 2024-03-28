import 'package:flutter/material.dart';
import 'package:organi/todo/checker.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<TodoItem> _todoList = [];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addSampleTasks();
  }

  // Function to add sample tasks
  void _addSampleTasks() {
    _todoList.addAll([
      TodoItem(task: 'Complete Math Homework', isCompleted: false),
      TodoItem(task: 'Study for Science Test', isCompleted: false),
      TodoItem(task: 'Submit History Assignment', isCompleted: false),
      TodoItem(task: 'Write English Essay', isCompleted: false),
      TodoItem(task: 'Practice Music Instrument', isCompleted: false),
      TodoItem(task: 'Prepare for Geography Quiz', isCompleted: false),
      TodoItem(task: 'Attend After-school Club Meeting', isCompleted: false),
      TodoItem(task: 'Prepare Presentation for Meeting', isCompleted: false),
      TodoItem(task: 'Read Chapter 7 for Literature Class', isCompleted: false),
      TodoItem(task: 'Complete Coding Exercise', isCompleted: false),
      // Add more todo items here as needed
    ]);
  }

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoList.add(TodoItem(task: task, isCompleted: false));
      });
      _textFieldController.clear();
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  Future<void> _confirmRemoveTodoItem(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to remove this task?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleTodoCompletion(int index) {
    setState(() {
      _todoList[index].isCompleted = !_todoList[index].isCompleted;
      if (_todoList[index].isCompleted) {
        _confirmRemoveTodoItem(index);
      }
    });
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new task'),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'What to do...'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addTodoItem(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDarkMode ? Colors.grey[800] :  Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
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
                    title: Text(
                      _todoList[index].task,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        decoration: _todoList[index].isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Checkbox(
                      value: _todoList[index].isCompleted,
                      onChanged: (newValue) => _toggleTodoCompletion(index),
                    ),
                    onTap: () => _toggleTodoCompletion(index),
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
          onPressed: _showAddTodoDialog,
          tooltip: 'Add Task',
          backgroundColor: Color.fromARGB(255, 43, 148, 96),
          child: Icon(Icons.add, size: 25, color: Colors.white),
        ),
      ),
    );
  }
}
