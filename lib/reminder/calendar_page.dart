import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Reminder {
  String text;
  TimeOfDay? time;
  DateTime date;

  Reminder({required this.text, this.time, required this.date});
}

class ReminderManager {
  static final ReminderManager _instance = ReminderManager._internal();

  factory ReminderManager() {
    return _instance;
  }

  ReminderManager._internal();

  final Map<DateTime, List<Reminder>> _reminders = {};

  void addReminder(DateTime date, Reminder reminder) {
    _reminders.putIfAbsent(date, () => []).add(reminder);
  }

  void deleteReminder(DateTime date, Reminder reminder) {
    _reminders[date]?.remove(reminder);
  }

  Map<DateTime, List<Reminder>> get reminders => _reminders;
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  final _reminderManager = ReminderManager();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _addSampleReminders();
  }

  void _addSampleReminders() {
    if (_reminderManager.reminders.isEmpty) {
      _reminderManager.addReminder(
        DateTime(2024, 3, 1),
        Reminder(
          text: 'Math quiz at 10:00 AM',
          date: DateTime(2024, 3, 1),
          time: TimeOfDay(hour: 10, minute: 00),
        ),
      );
      _reminderManager.addReminder(
        DateTime(2024, 3, 3),
        Reminder(
          text: 'History presentation at 2:00 PM',
          date: DateTime(2024, 3, 3),
          time: TimeOfDay(hour: 12, minute: 00),
        ),
      );
    }
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

  Widget _buildTimeSelector(
      TimeOfDay? selectedTime, Function(TimeOfDay) onTimeChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(selectedTime != null
              ? "${selectedTime!.format(context)}"
              : "Select Time"),
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
      _reminderManager.addReminder(date, newReminder);
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
    TextEditingController _textFieldController =
        TextEditingController(text: reminder.text);
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
                  _editReminder(
                      date, reminder, _textFieldController.text, selectedTime);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editReminder(
      DateTime date, Reminder reminder, String newText, TimeOfDay? newTime) {
    setState(() {
      reminder.text = newText;
      reminder.time = newTime;
    });
  }

  void _deleteReminder(DateTime date, Reminder reminder) {
    _reminderManager.deleteReminder(date, reminder);
    setState(() {
      if (_reminderManager.reminders[date]?.isEmpty ?? false) {
        _reminderManager.reminders.remove(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              headerVisible: true, // Include header (Sun, Mon, Tue, etc.)
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      :  Color.fromARGB(255, 43, 148, 96),
                ),
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 43, 148, 96),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.red, // Change weekend text color
                  fontWeight: FontWeight.bold,
                ),
                outsideTextStyle: TextStyle(color: Colors.grey), // Change text color for dates outside the current month
                outsideDaysVisible: false, // Hide days outside the current month
                // Add background color
                outsideDecoration: BoxDecoration(
                  color:  Color.fromARGB(255, 43, 148, 96),
                ),
                weekendDecoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.transparent,
                ),
                todayDecoration: BoxDecoration(
                  color:  Color.fromARGB(255, 145, 65, 30),
                  shape: BoxShape.circle
                ),
                markersMaxCount: 2, // Increase the maximum number of markers per day
              ),
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              rowHeight: 40,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _reminderManager.reminders.length,
                itemBuilder: (context, index) {
                  final date = _reminderManager.reminders.keys.elementAt(index);
                  final reminders = _reminderManager.reminders[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Text(
                          'Reminders for ${_formatDate(date)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (reminders.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reminders.length,
                          itemBuilder: (context, localIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    reminders[localIndex].text,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    reminders[localIndex].time != null
                                        ? '${reminders[localIndex].time!.hour}:${reminders[localIndex].time!.minute} ${reminders[localIndex].time!.period == DayPeriod.am ? 'AM' : 'PM'}'
                                        : 'No time specified',
                                  ),
                                  onTap: () {
                                    _showReminderOptionsDialog(
                                        date, reminders[localIndex]);
                                  },
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      if (reminders.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'No reminders',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
