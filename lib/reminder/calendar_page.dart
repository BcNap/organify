import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Reminder {
  String text;
  TimeOfDay? time;
  DateTime date;

  Reminder({required this.text, this.time, required this.date});
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  Map<DateTime, List<Reminder>> _reminders = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
  }

  DateTime _normalizeDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = _normalizeDateTime(selectedDay);
      _focusedDay = focusedDay;
    });
    _showAddReminderDialog(_selectedDay);
  }

  Future<void> _showAddReminderDialog(DateTime date) async {
    TextEditingController _textFieldController = TextEditingController();
    TimeOfDay? selectedTime;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Enter reminder"),
              ),
              SizedBox(height: 10),
              _buildTimeSelector(selectedTime, (newTime) {
                setState(() {
                  selectedTime = newTime;
                });
              }),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_textFieldController.text.isNotEmpty) {
                  _saveReminder(date, _textFieldController.text, selectedTime);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeSelector(TimeOfDay? selectedTime, Function(TimeOfDay) onTimeChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(selectedTime != null ? "${selectedTime!.format(context)}" : "Select Time"),
          onPressed: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (pickedTime != null) {
              onTimeChanged(pickedTime);
            }
          },
        ),
      ],
    );
  }

  void _saveReminder(DateTime date, String text, TimeOfDay? time) {
    final newReminder = Reminder(text: text, time: time, date: date);
    setState(() {
      _reminders.putIfAbsent(date, () => []).add(newReminder);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showReminderOptionsDialog(DateTime date, Reminder reminder) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reminder Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditReminderDialog(date, reminder);
                },
              ),
              ListTile(
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteReminder(date, reminder);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditReminderDialog(DateTime date, Reminder reminder) async {
    TextEditingController _textFieldController = TextEditingController(text: reminder.text);
    TimeOfDay? selectedTime = reminder.time;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Enter reminder"),
              ),
              SizedBox(height: 10),
              _buildTimeSelector(selectedTime, (newTime) {
                setState(() {
                  selectedTime = newTime;
                });
              }),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_textFieldController.text.isNotEmpty) {
                  _editReminder(date, reminder, _textFieldController.text, selectedTime);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editReminder(DateTime date, Reminder reminder, String newText, TimeOfDay? newTime) {
    setState(() {
      reminder.text = newText;
      reminder.time = newTime;
    });
  }

  void _deleteReminder(DateTime date, Reminder reminder) {
    setState(() {
      _reminders[date]!.remove(reminder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.black), // Set default text color
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 43, 148, 96),
                shape: BoxShape.circle, // Make the shape a circle
              ),
            ),
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.values.fold<int>(0, (previousValue, element) => previousValue + element.length),
              itemBuilder: (context, index) {
                int totalIndex = 0;
                DateTime? date;
                for (final entry in _reminders.entries) {
                  if (totalIndex <= index && index < totalIndex + entry.value.length) {
                    date = entry.key;
                    break;
                  }
                  totalIndex += entry.value.length;
                }

                if (date == null) {
                  return SizedBox.shrink(); // Skip if date is null
                }

                List<Reminder> reminders = _reminders[date]!;
                int localIndex = index - totalIndex;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        reminders[localIndex].text, // Make the title bold
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        reminders[localIndex].time != null
                            ? '${reminders[localIndex].time!.hour}:${reminders[localIndex].time!.minute} ${reminders[localIndex].time!.period == DayPeriod.am ? 'AM' : 'PM'}'
                            : 'No time specified',
                      ),
                      onTap: () {
                        _showReminderOptionsDialog(date!, reminders[localIndex]);
                      },
                    ),
                    if (localIndex == reminders.length - 1) // Add label only for the last reminder of the date
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Text(
                          'Reminders for ${_formatDate(date)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalendarPage(),
  ));
}
