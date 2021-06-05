import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/utilities/notifications.dart';

class AddTask extends StatefulWidget {
  final bool edit;
  final SingleTask task;

  const AddTask({
    this.edit = false,
    required this.task,
  });

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  DateTime deadlineValue = DateTime(1900);
  String addedSuccessfully = '';

  Color colorTitleHint = Color.fromRGBO(115, 115, 115, 1);
  Color colorTaskHint = Color.fromRGBO(115, 115, 115, 1);
  Color colorContainer = Color.fromRGBO(246, 246, 246, 1);

  late Widget dateTimeContent;

  Widget emptyDateTimeContent(bool editing, Color color) {
    if (!editing) {
      return Text('Press to pick a date',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: color,
          ));
    } else {
      return fillDateTimeContent(widget.task.deadline);
    }
  }

  Widget fillDateTimeContent(DateTime date) {
    List<Color> colors = taskColorsCreator(SingleTask(
        id: -1,
        deadline: date,
        creationDate: DateTime.now(),
        name: 'none',
        assignment: 'none'));
    colorContainer = colors[4];
    return Center(
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(fontFamily: 'Open Sans', fontSize: 22),
                children: [
                  TextSpan(
                      text: DateFormat('Hm').format(date) + '\n',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors[1],
                          fontSize: 20
                      )
                  ),
                  TextSpan(
                      text: DateFormat('d MMMM').format(date) + '\n',
                      style: TextStyle(
                          color: colors[2], fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                      text: DateFormat('yyyy').format(date) + '\n',
                      style: TextStyle(
                        color: colors[3],
                      )
                  ),
                  TextSpan(
                    text: DateFormat('EEEE').format(date),
                      style: TextStyle(
                        color: colors[0],
                      )
                  )
                ])));
  }

  @override
  void initState() {
    super.initState();
    bool initEdit = widget.edit ? true : false;
    dateTimeContent = emptyDateTimeContent(initEdit, Color.fromRGBO(115, 115, 115, 1));
    if (initEdit) {
      titleController.text = widget.task.name;
      taskController.text = widget.task.assignment;
      deadlineValue = widget.task.deadline;
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    taskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, MediaQuery.of(context).size.height * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title:',
                  style: TextStyle(
                      color: Color.fromRGBO(96, 96, 96, 1),
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: TextField(
                      controller: titleController,
                      maxLength: 21,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: settingsObject.colorScheme.gradientStart,
                      decoration: InputDecoration(
                        hintText: 'Enter your task title here...',
                        hintStyle: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            color: colorTitleHint
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: settingsObject.colorScheme.gradientMedium,
                              width: 2,
                            )
                        ),
                      )),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Task:',
                        style: TextStyle(
                            color: Color.fromRGBO(96, 96, 96, 1),
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          width:
                              MediaQuery.of(context).size.width / 2 - 30,
                          child: Center(
                            child: TextField(
                                controller: taskController,
                                maxLines: 4,
                                maxLength: 70,
                                textInputAction: TextInputAction.done,
                                cursorColor: settingsObject.colorScheme.gradientMedium,
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                    hintText: 'Enter your task...',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                        color: colorTaskHint),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: settingsObject
                                              .colorScheme.gradientMedium,
                                          width: 2,
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                          ))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Deadline: ',
                        style: TextStyle(
                            color: Color.fromRGBO(96, 96, 96, 1),
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            color: colorContainer,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  blurRadius: 2,
                                  spreadRadius: 0.1)
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(DateTime.now().year, DateTime.now().subtract(Duration(days: 61)).month, 1),
                                    maxTime: DateTime.now().add(Duration(days: 365)),
                                    onConfirm: (date) {
                                      setState(() {
                                        deadlineValue = date;
                                        dateTimeContent = fillDateTimeContent(date);
                                      });
                                   },
                                    currentTime: DateTime.now().add(Duration(days: 1)),
                                    locale: LocaleType.en);
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(child: dateTimeContent),
                              )),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.075,
            decoration: BoxDecoration(
              color: settingsObject.colorScheme.gradientStart,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  spreadRadius: 1

              )]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (titleController.text.isNotEmpty && taskController.text.isNotEmpty && deadlineValue != DateTime(1900)) {
                      DateTime creationDate = DateTime.now();
                      int id;
                      if (tasksObject.allTasks.isNotEmpty) {
                        List<int> ids = [];
                        tasksObject.allTasks.forEach((element) {ids.add(element.id);});
                        id = ids.reduce(max) + 1;
                      } else {
                        id = 0;
                      }
                      SingleTask tempTask;
                      if (widget.task.status == 'completed') {
                        tempTask = SingleTask(
                            id: id,
                            deadline: deadlineValue,
                            creationDate: creationDate,
                            name: titleController.text,
                            assignment: taskController.text,
                            status: 'completed'
                        );
                      } else {
                        if (deadlineValue.isAfter(creationDate)) {
                          tempTask = SingleTask(
                              id: id,
                              deadline: deadlineValue,
                              creationDate: creationDate,
                              name: titleController.text,
                              assignment: taskController.text
                          );
                        } else {
                          tempTask = SingleTask(
                              id: id,
                              deadline: deadlineValue,
                              creationDate: creationDate,
                              name: titleController.text,
                              assignment: taskController.text,
                              status: 'missed'
                          );
                        }
                      }
                      tasksObject.addTask(tempTask);
                      if (widget.edit) {
                        tasksObject.allTasks.remove(widget.task);
                      }
                      tasksObject.writeToFile();
                      displayNotification(titleController.text, taskController.text, deadlineValue);
                      setState(() {
                        titleController.clear();
                        taskController.clear();
                        dateTimeContent = emptyDateTimeContent(
                            false, Color.fromRGBO(115, 115, 115, 1));
                        colorContainer = Color.fromRGBO(246, 246, 246, 1);
                        deadlineValue = DateTime(1900);
                        addedSuccessfully = 'Added successfuly';
                      });
                    } else {
                      if (titleController.text.isEmpty) {
                        setState(() {
                          colorTitleHint = Color.fromRGBO(237, 114, 114, 1);
                        });
                      }
                      if (taskController.text.isEmpty) {
                        setState(() {
                          colorTaskHint = Color.fromRGBO(237, 114, 114, 1);
                        });
                      }
                      if (deadlineValue == DateTime(1900)) {
                        setState(() {
                          dateTimeContent = emptyDateTimeContent(
                              false, Color.fromRGBO(237, 114, 114, 1));
                          colorContainer =
                              Color.fromRGBO(246, 246, 246, 1);
                        });
                      }
                    }
                  },
                  child: Center(
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )),
            ),
          ),
          Container(
            child: Text(
              addedSuccessfully,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Color.fromRGBO(122, 179, 116, 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}
