import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'note.dart'; // Assuming your Note class is in a file named note.dart

class NoteDetailPage extends StatefulWidget {
  final Note? note;

  NoteDetailPage({this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  TextEditingController _noteController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _noteController.text = widget.note!.content;
      if (widget.note!.imagePath != null) {
        _image = File(widget.note!.imagePath!);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<bool> _onBackPressed() async {
    // Save the note and image path here
    Navigator.pop(context, {'note': _noteController.text, 'image': _image?.path});
    return true; // Return true to indicate that we have handled the back press
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _noteController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Enter your note here...',
                    border: InputBorder.none, // Removed border line
                  ),
                ),
                SizedBox(height: 20),
                _image != null ? Image.file(_image!) : SizedBox.shrink(), // Removed text 'No image selected.'
              ],
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10), // Adjust height as needed
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.5), // Adjust border color and opacity
                  width: 0.5, // Adjust border thickness
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.white, // Set background color of AppBar
              elevation: 0, // Remove AppBar elevation
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _onBackPressed();
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.attach_file), // Changed camera icon to paper clip icon
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.share), // Changed save icon to share icon like iOS
                  onPressed: () {
                    Navigator.pop(context, {'note': _noteController.text, 'image': _image?.path});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
