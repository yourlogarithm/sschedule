import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:intl/intl.dart';
import 'package:sschedule/content.dart';
import '../addContent/addContent.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:sschedule/utilities/painter.dart';

class TaskPage extends StatefulWidget {
  final SingleTask task;
  const TaskPage({required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late String creationDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (DateFormat('MMMM').format(widget.task.creationDate).length > 5){
      creationDate = DateFormat('d MMM yyyy').format(widget.task.creationDate);
    } else {
      creationDate = DateFormat('d MMMM yyyy').format(widget.task.creationDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Positioned(
          top: 0,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2 + 40,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              gradient: mainGradient()
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      widget.task.name,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: settingsObject.colorScheme.primaryTop
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Last edited: $creationDate',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: settingsObject.colorScheme.secondaryTop
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 5,
                  spreadRadius: 0.1,
                )]

            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.task_alt, color: settingsObject.colorScheme.label, size: 26),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Assignment',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: settingsObject.colorScheme.label
                                  )
                                ),
                              )
                            ],
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: CircleBorder(),
                                  onTap: () {
                                    setState(() {
                                      content.value = AddContent(taskEdit: true, task: widget.task, subject: Subject(name: 'none', imagePath: 'none', category: 'none'),);
                                    });
                                  },
                                  splashColor: settingsObject.colorScheme.primaryTop,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.edit_outlined, color: settingsObject.colorScheme.label, size: 26),
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          widget.task.assignment,
                          style: TextStyle(
                            color: settingsObject.colorScheme.secondaryText,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.calendar_today_rounded, color: settingsObject.colorScheme.label, size: 26),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                'Deadline',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: settingsObject.colorScheme.label
                                )
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          DateFormat('Hm').format(widget.task.deadline) + ' | ' + DateFormat('d MMMM y').format(widget.task.deadline),
                          style: TextStyle(
                              color: settingsObject.colorScheme.secondaryText,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.turned_in_not, color: settingsObject.colorScheme.label, size: 26),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                'Status',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: settingsObject.colorScheme.label
                                )
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            CustomPaint(
                                painter: Circle(
                                    radius: 7.5,
                                    offset: Offset(10, 0),
                                    color: taskColorsCreator(widget.task)[0]
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 25),
                              child: Text(
                                '${widget.task.status[0].toUpperCase()}${widget.task.status.substring(1)}',
                                style: TextStyle(
                                    color: settingsObject.colorScheme.secondaryText,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
