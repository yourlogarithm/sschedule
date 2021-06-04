import 'jsonFile.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

TasksManager tasksObject = TasksManager('tasks.json');

class TasksManager extends JSONFile{
  TasksManager(filename) : super(filename);
  List allTasks = [];
  void addTask(SingleTask arg){
    allTasks.add(arg);
  }

  void removeTask(SingleTask arg){
    allTasks.remove(arg);
  }

  void bubbleSort() {
    allTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = File(dir.path + '/' + fileName);
    fileExists = await jsonFile.exists();
    if (fileExists) {
      String data = await jsonFile.readAsString();
      fileContent = jsonDecode(data);
      fileContent['allTasks'].forEach((key, value) {
        String status = value['status'];
        DateTime deadline = DateTime.parse(value['deadline']);
        if (deadline.isBefore(DateTime.now())){
          status = 'missed';
        }
        allTasks.add(SingleTask(id: int.parse(key), deadline: deadline, creationDate: DateTime.parse(value['creationDate']), name: value['name'], assignment: value['assignment'], status: status));
      });
    } else {
      createFile();
    }
  }

  void createFile() {
    File file = File(dir.path + '/' + fileName);
    fileContent = {'allTasks': {}};
    file.create().then((_) {
      fileExists = true;
      file.writeAsString(jsonEncode(fileContent));
    });
  }

  void writeToFile(){
    Map jsonReadableContent = {};
    allTasks.forEach((element) {
      jsonReadableContent[element.id.toString()] = {
        'creationDate': element.creationDate.toString(),
        'deadline': element.deadline.toString(),
        'name': element.name,
        'assignment': element.assignment,
        'status': element.status
      };
    });
    fileContent['allTasks'] = jsonReadableContent;
    jsonFile.writeAsString(jsonEncode(fileContent));
  }
}

class SingleTask {
  late int id;
  late DateTime deadline;
  late DateTime creationDate;
  late String name;
  late String assignment;
  late String status;

  SingleTask({required this.id, required this.deadline, required this.creationDate, required this.name, required this.assignment, this.status = 'active'});

  void changeStatus(String arg){
    this.status = arg;
  }

}


List<Color> taskColorsCreator(SingleTask task){
  List<Color> colors = [];
  Duration difference = task.deadline.add(Duration(days: 1)).difference(DateTime.now());
  if (task.status == 'active'){
    if (difference.inDays > 3){
      colors.add(Color.fromRGBO(101, 133, 98, 1));
      colors.add(Color.fromRGBO(191, 237, 186, 1));
      colors.add(Color.fromRGBO(131, 151, 123, 1));
      colors.add(Color.fromRGBO(188, 219, 188, 1));
      colors.add(Color.fromRGBO(244, 255, 243, 1));
    } else if (difference.inDays > 1){
      colors.add(Color.fromRGBO(244, 239, 109, 1));
      colors.add(Color.fromRGBO(191, 184, 74, 1));
      colors.add(Color.fromRGBO(209, 167, 0, 1));
      colors.add(Color.fromRGBO(216, 204, 67, 1));
      colors.add(Color.fromRGBO(252, 255, 203, 1));
    } else {
      colors.add(Color.fromRGBO(255, 130, 130, 1));
      colors.add(Color.fromRGBO(190, 146, 146, 1));
      colors.add(Color.fromRGBO(151, 123, 123, 1));
      colors.add(Color.fromRGBO(198, 167, 167, 1));
      colors.add(Color.fromRGBO(255, 230, 230, 1));
    }
  } else if (task.status == 'completed'){
    colors.add(Color.fromRGBO(148, 174, 145, 1));
    colors.add(Color.fromRGBO(158, 158, 158, 1));
    colors.add(Color.fromRGBO(86, 86, 86, 1));
    colors.add(Color.fromRGBO(125, 125, 125, 1));
    colors.add(Color.fromRGBO(246, 246, 246, 1));
  } else if (task.status == 'missed'){
    colors.add(Color.fromRGBO(255, 130, 130, 1));
    colors.add(Color.fromRGBO(190, 146, 146, 1));
    colors.add(Color.fromRGBO(151, 123, 123, 1));
    colors.add(Color.fromRGBO(198, 167, 167, 1));
    colors.add(Color.fromRGBO(255, 230, 230, 1));
  }
  return colors;
}