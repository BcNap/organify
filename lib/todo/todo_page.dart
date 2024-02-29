import 'package:flutter/material.dart';
import 'package:organi/todo/checker.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<TodoItem> _todoList = [];
  final TextEditingController _textFieldController = TextEditingController();

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

  void _toggleTodoCompletion(int index) {
    setState(() {
      _todoList[index].isCompleted = !_todoList[index].isCompleted;
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
            decoration: InputDecoration(hintText: 'Enter something to do...'),
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
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
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
              title: Text(
                _todoList[index].task,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Make the text bold
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
      floatingActionButton: SizedBox(
        width: 50, // Adjust the width to change the size
        height: 50, // Adjust the height to change the size
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: _showAddTodoDialog,
          tooltip: 'Add Task',
          backgroundColor: Color.fromARGB(255, 43, 148, 96),
          child: Icon(Icons.add, size: 25, color: Colors.white), // Increase the size to make it bolder
        ),
      ),
    );
  }
}
