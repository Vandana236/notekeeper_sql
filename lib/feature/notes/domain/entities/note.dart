class Note {

  int? id;
  String title;
  String description;
  String date;
  int priority;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
  });
}