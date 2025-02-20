

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/subject.dart';
import 'widgets/subject_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absence Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AbsenceTracker(prefs: prefs),
    );
  }
}

class AbsenceTracker extends StatefulWidget {
  final SharedPreferences prefs;

  AbsenceTracker({required this.prefs});

  @override
  _AbsenceTrackerState createState() => _AbsenceTrackerState();
}

class _AbsenceTrackerState extends State<AbsenceTracker> {
  List<Subject> subjects = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final savedData = widget.prefs.getStringList('subjects');
    if (savedData != null) {
      setState(() {
        subjects = savedData.map((data) => Subject.fromJson(data)).toList();
      });
    } else {
      setState(() {
        subjects = List.generate(9, (index) => Subject(name: 'Subject ${index + 1}', absences: 0));
      });
    }
  }

  void _saveData() {
    final data = subjects.map((subject) => subject.toJson()).toList();
    widget.prefs.setStringList('subjects', data);
  }

  void _updateSubjectName(int index, String newName) {
    setState(() {
      subjects[index].name = newName;
      _saveData();
    });
  }

  void _incrementAbsence(int index) {
    setState(() {
      if (subjects[index].absences < 8) {
        subjects[index].absences++;
        _saveData();
      }
    });
  }

  void _decrementAbsence(int index) {
    setState(() {
      if (subjects[index].absences > 0) {
        subjects[index].absences--;
        _saveData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ABSENCE TRACKER',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0), // Space between cards
              child: SubjectCard(
                subject: subjects[index],
                onNameChanged: (newName) => _updateSubjectName(index, newName),
                onIncrement: () => _incrementAbsence(index),
                onDecrement: () => _decrementAbsence(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
