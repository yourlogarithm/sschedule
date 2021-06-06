import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'jsonFile.dart';


ScheduleManager scheduleObject = ScheduleManager('schedule.json');

class ScheduleManager extends JSONFile {
  ScheduleManager(filename) : super(filename);
  late String weekStart;
  late int lessonDuration;
  List schedule = [];
  List<Subject> subjects = [];

  List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = File(dir.path + '/' + fileName);
    fileExists = await jsonFile.exists();
    if (fileExists) {
      String data = await jsonFile.readAsString();
      fileContent = jsonDecode(data);
      subjects = [];
      fileContent['subjects'].forEach((key, value) {
        subjects.add(Subject(name: key, imagePath: value[1], category: value[0]));
      });
      bubbleSortSubjects();
      lessonDuration = fileContent['lessonDuration'];
      schedule = [];
      fileContent['schedule'].forEach((day) {
        List classes = [];
        day.forEach((lesson) {
          subjects.forEach((subject) {
            if (subject.name == lesson['subject']){
              Class oneClass = Class(subject: subject, startHour: lesson['startHour'], startMinute: lesson['startMinute'], note: lesson['note']);
              classes.add(oneClass);
            }
          });
        });
        schedule.add(classes);
      });
      weekStart = fileContent['weekStart'];
    } else {
      createFile();
    }
  }

  void addSubject(Subject arg){
    subjects.add(arg);
  }
  void removeSubject(Subject arg){
    subjects.remove(arg);
  }
  void removeClass(int day, int index){
    schedule[day].removeAt(index);
  }
  void bubbleSortSubjects() {
    subjects.sort((a, b) => a.name.compareTo(b.name));
  }
  void bubbleSortSchedule(int index){
    List<Class> localDaySchedule = List<Class>.from(schedule[index]);
    localDaySchedule.sort((a, b) => a.date.compareTo(b.date));
    schedule[index] = localDaySchedule;
  }
  void writeToFile(){
    Map jsonReadableSubjects = {};
    subjects.forEach((element) {
      jsonReadableSubjects[element.name] = [element.category, element.imagePath];
    });
    List jsonReadableSchedule = [];
    schedule.forEach((day) {
      List classes = [];
      day.forEach((lesson) {
        Map jsonReadableLesson = {
          'subject': lesson.subject.name,
          'startHour': lesson.startHour,
          'startMinute': lesson.startMinute,
          'note': lesson.note
        };
        classes.add(jsonReadableLesson);
      });
      jsonReadableSchedule.add(classes);
    });
    Map tempContent = {
      'schedule': jsonReadableSchedule,
      'lessonDuration': lessonDuration,
      'weekStart': weekStart,
      'subjects': jsonReadableSubjects
    };
    fileContent = tempContent;
    jsonFile.writeAsString(jsonEncode(fileContent));
  }

  void createFile(){
    File file = File(dir.path + '/' + fileName);
    fileContent = {
      'schedule': [[], [], [], [], [], [], []],
      'weekStart': 'Monday',
      'lessonDuration': 45,
      'subjects': defaultSubjects
    };
    schedule = [[], [], [], [], [], [], []];
    weekStart = 'Monday';
    lessonDuration = 45;
    fileContent['subjects'].forEach((key, value) {
      subjects.add(Subject(name: key, imagePath: value[1], category: value[0]));
    });
    file.create().then((_) {
      fileExists = true;
      file.writeAsString(jsonEncode(fileContent));
    });
  }

  void setWeekDays() {
    if (weekStart == 'Sunday'){
      weekdays.insert(0, weekdays.removeAt(6));
    }
  }
}

class Class {
  late Subject subject;
  late int startHour;
  late int startMinute;
  late int endHour;
  late int endMinute;
  late String note;
  late DateTime date;
  Class({required this.subject, required this.startHour, required this.startMinute, required this.note}) {
    DateTime refferenceStart =  DateTime(1900, 1, 1, startHour, startMinute);
    date = refferenceStart;
    DateTime refferenceEnd = refferenceStart.add(Duration(minutes: scheduleObject.lessonDuration));
    endHour = refferenceEnd.hour;
    endMinute = refferenceEnd.minute;
  }
}

class Subject {
  late String name;
  late String imagePath;
  late String category;
  Subject({required this.name, required this.imagePath, required this.category});
}

Map<String, List<String>> defaultSubjects = {
  'Mathematics': ['Science', 'images/subjects/flat/Math.png'],
  'Physics': ['Science', 'images/subjects/flat/Atom.png'],
  'Chemistry': ['Science', 'images/subjects/flat/Chemistry.png'],
  'Biology': ['Science', 'images/subjects/flat/Biology.png'],
  'Astronomy': ['Science', 'images/subjects/flat/Astronomy.png'],
  'Geography': ['Science', 'images/subjects/flat/Geology.png'],
  'Computer Science': ['Science', 'images/subjects/flat/Computer Science.png'],
  'Arts': ['Creativity', 'images/subjects/flat/Arts.png'],
  'Music': ['Creativity', 'images/subjects/flat/Music.png'],
  'Theatre': ['Creativity', 'images/subjects/flat/Theatre.png'],
  'English': ['Language', 'images/subjects/flat/Language.png'],
  'History': ['Social', 'images/subjects/flat/Parchment.png'],
  'Physical Education': ['Sport', 'images/subjects/flat/Sport.png']
};