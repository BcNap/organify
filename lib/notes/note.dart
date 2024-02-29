class Note {
  String title;
  String content;
  String? imagePath;
  DateTime createdAt;

  Note({
    required this.title,
    required this.content,
    this.imagePath,
    required this.createdAt,
  });

  factory Note.fromContent(String content, {String? imagePath}) {
    final title = content.split('\n').first;
    return Note(
      title: title,
      content: content,
      imagePath: imagePath,
      createdAt: DateTime.now(), // Set the creation date to the current time
    );
  }
}
