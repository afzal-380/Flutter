class Subject {
  String name;
  int absences;

  Subject({required this.name, required this.absences});

  // Convert Subject to JSON
  String toJson() {
    return '$name|$absences';
  }

  // Create Subject from JSON
  factory Subject.fromJson(String json) {
    final parts = json.split('|');
    return Subject(
      name: parts[0],
      absences: int.parse(parts[1]),
    );
  }
}
