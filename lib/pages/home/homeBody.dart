import 'package:flutter/material.dart';
import 'package:sschedule/pages/taskManager/allTasks.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/content.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/pages/taskManager/taskPage.dart';
import 'package:sschedule/utilities/scrollBehavior.dart';
import 'package:sschedule/utilities/painter.dart';
import 'package:sschedule/pages/addContent/addContent.dart';
import 'package:intl/intl.dart';
import 'package:sschedule/pages/weekSchedule/weekSchedule.dart';

class HomeBody extends StatefulWidget {
  // const HomeBody({Key key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int selected = -1;
  DateTime getClassesDay() {
    bool empty = true;
    scheduleObject.schedule.forEach((element) {
      if (element.isNotEmpty){
        empty = false;
      }
    });
    if (empty){
      return DateTime.now();
    } else {
      DateTime editable = DateTime.now();
      DateTime lastLessonEnd;
      if (scheduleObject.schedule[editable.weekday-1].isNotEmpty){
        lastLessonEnd = DateTime(editable.year, editable.month, editable.day, scheduleObject.schedule[editable.weekday-1].last.startHour, scheduleObject.schedule[editable.weekday-1].last.startMinute);
        if (lastLessonEnd.isBefore(editable)){
          editable = editable.add(Duration(days: 1));
        }
      }
      while(scheduleObject.schedule[editable.weekday-1].isEmpty){
        editable = editable.add(Duration(days: 1));
      }
      return editable;
    }
  }
  String getClassesLabel(DateTime date){
    return '${scheduleObject.weekdays[date.weekday-1]} classes';
  }
  Widget classes(DateTime date){
    List lessons = scheduleObject.schedule[date.weekday-1];
    Widget _getContainer(int index){
      DateTime classStartTime = DateTime(date.year, date.month, date.day, lessons[index].startHour, lessons[index].startMinute);
      Widget data = lessons[index].note == '' ? Text(
        lessons[index].subject.name,
        style: TextStyle(
            height: 1,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            color: settingsObject.colorScheme.primaryText
        )
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Text(
                lessons[index].subject.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  color: settingsObject.colorScheme.primaryText
                )
              )
          ),
          Flexible(
              child: Text(
                  lessons[index].note,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    color: settingsObject.colorScheme.secondaryText,
                )
              )
          )
        ],
      );
      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: settingsObject.colorScheme.searchInput,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(lessons[index].subject.imagePath),
                ),
                radius: 38,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: constraints.widthConstraints().maxWidth * 0.7,
                height: MediaQuery.of(context).size.height * 0.11,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(246, 246, 246, 1)
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: data,
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                    ),
                    Text(
                      DateFormat('Hm').format(classStartTime),
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        color: settingsObject.colorScheme.tertiaryText,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
    }
    if (lessons.isNotEmpty){
      List<Widget> containers = [];
      int added = 0;
      for (int i = 0; i < lessons.length; i++){
        if (added >=2){
          break;
        }
        DateTime lessonEnd = DateTime(date.year, date.month, date.day, lessons[i].endHour, lessons[i].endMinute);
        if (lessonEnd.isAfter(DateTime.now())){
          containers.add(_getContainer(i));
          added++;
        }
      }
      return Column(
        children: containers,
      );
    } else {
      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(10),
          width: constraints.widthConstraints().maxWidth,
          height: MediaQuery.of(context).size.height * 0.11,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(246, 246, 246, 1)
          ),
          child: Center(
            child: Text(
              'No classes',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: settingsObject.colorScheme.primaryText
              ),
            ),
          ),
        );
      });
    }
  }
  Widget getTasks() {
    Container addTask = Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
      margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
      decoration: BoxDecoration(
          color: Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 5,
              spreadRadius: 0.5
          )]
      ),
      child: Material(
        borderRadius: BorderRadius.circular(25),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            reselectBottomColor();
            content.value = AddContent(initialIndex: 0, task: SingleTask(name: 'none', assignment: 'none', creationDate: DateTime(1900), deadline: DateTime(1900), id: -1), subject: Subject(name: 'none', imagePath: 'none', category: 'none'));
          },
          child: Icon(
            Icons.add,
            color: settingsObject.colorScheme.primaryTop,
          ),
        ),
      ),
    );
    List activeTasks = [];
    tasksObject.bubbleSort();
    tasksObject.allTasks.forEach((element) {
      if (element.status == 'active'){
        activeTasks.add(element);
      }
    });
    if (activeTasks.isNotEmpty){
      List<Container> containers = [];
      for (int i = 0; i < activeTasks.length; i++){
        SingleTask task = activeTasks[i];
        int difference = task.deadline.add(Duration(days: 1)).difference(DateTime.now()).inDays;
        String timeLeftUntilTask;
        String noun;
        if (difference == 1) {
          noun = "day";
        } else {
          noun = "days";
        }
        timeLeftUntilTask = '$difference $noun left';
        if (difference <= 1 || i < 4){
          List<Color> colors = taskColorsCreator(task);
          Widget containerContent;
          if (task.id != selected){
            containerContent = Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selected = -1;
                    content.value = TaskPage(task: task);
                    reselectBottomColor();
                  });
                },
                onLongPress: () {
                  setState(() {
                    selected = task.id;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomPaint(
                              painter: Circle(
                                  radius: 7.5,
                                  offset: Offset(0, 0),
                                  color: colors[0]
                              )
                          ),
                          Text(
                            timeLeftUntilTask,
                            style: TextStyle(
                                color: colors[1],
                                fontFamily: 'Ubuntu',
                                fontSize: 16
                            ),
                          )
                        ],
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Text(
                              task.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: colors[2],
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          task.assignment,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors[3],
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            Widget _contextButton({required Color color, required String text, required Icon icon}) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (text == 'Delete'){
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    selected = -1;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('No', style: TextStyle(color: settingsObject.colorScheme.gradientMedium)),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    tasksObject.removeTask(task);
                                  });
                                  tasksObject.writeToFile();
                                  Navigator.pop(context);
                                },
                                child: Text('Yes', style: TextStyle(color: settingsObject.colorScheme.gradientMedium)),
                              )
                            ],
                            elevation: 24,
                          ),
                          barrierDismissible: true
                      );
                    }
                    else if (text == 'Done') {
                      int index = tasksObject.allTasks.indexOf(task);
                      setState(() {
                        tasksObject.allTasks[index].changeStatus('completed');
                        tasksObject.writeToFile();
                        selected = -1;
                      });
                    } else if (text == 'Edit'){
                      reselectBottomColor();
                      selected = -1;
                      content.value = AddContent(
                        initialIndex: 0,
                        taskEdit: true,
                        task: task,
                        subject: Subject(name: 'none', imagePath: 'none', category: 'none'),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        icon,
                        Text(
                          text,
                          style: TextStyle(
                            color: color,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            colors[4] = Color.fromRGBO(246, 246, 246, 1);
            containerContent = Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _contextButton(color: Color.fromRGBO(118, 230, 99, 1), text: 'Done', icon: Icon(Icons.task_alt_rounded, color: Color.fromRGBO(118, 230, 99, 1), size: 32)),
                  _contextButton(color: Color.fromRGBO(79, 79, 79, 1), text: 'Edit', icon: Icon(Icons.edit, color: Color.fromRGBO(79, 79, 79, 1), size: 32)),
                  _contextButton(color: Color.fromRGBO(232, 81, 81, 1), text: 'Delete', icon: Icon(Icons.delete_rounded, color: Color.fromRGBO(232, 81, 81, 1), size: 32))
                ],
              ),
            );
          }
          containers.add(Container(
            margin: EdgeInsets.fromLTRB(30, 5, 0, 5),
            width:  MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: colors[4],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 5,
                spreadRadius: 0.5
              )]
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: containerContent,
            ),
          ));
        }
      }
      containers.add(addTask);
      return ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: containers,
          )
      );
    } else {
      return Container(margin: EdgeInsets.only(top: 5), child: addTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.73,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = -1;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          height: MediaQuery.of(context).size.height * 0.73,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40),
              boxShadow: [BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 5,
                spreadRadius: 0.1,
              )]
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getClassesLabel(getClassesDay()),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open Sans',
                              color: settingsObject.colorScheme.label
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(40),
                          child: InkWell(
                            onTap: () {
                              reselectBottomColor(index: 1);
                              content.value = WeekSchedule(transition: true, initialValue: getClassesDay().weekday-1);
                            },
                            borderRadius: BorderRadius.circular(40),
                            splashColor: settingsObject.colorScheme.primaryTop,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "See all",
                                style: TextStyle(
                                    color: settingsObject.colorScheme.href,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    classes(getClassesDay()),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your tasks",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Open Sans',
                                color: settingsObject.colorScheme.label
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            child: InkWell(
                              onTap: () {
                                reselectBottomColor();
                                content.value = AllTasksPage();
                              },
                              splashColor: settingsObject.colorScheme.primaryTop,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                      color: settingsObject.colorScheme.href,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2 + 10,
                      margin: EdgeInsets.only(top: 5),
                      child: getTasks()
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
