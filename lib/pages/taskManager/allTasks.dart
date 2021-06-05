import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/utilities/notifications.dart';
import 'package:sschedule/utilities/painter.dart';
import 'package:sschedule/content.dart';
import '../addContent/addContent.dart';
import 'package:sschedule/settings/schedule.dart';
import 'taskPage.dart';
import 'package:timezone/data/latest.dart' as tz;

class AllTasksPage extends StatefulWidget {
  // const AllTasksPage({Key key}) : super(key: key);

  @override
  _AllTasksPageState createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {

  int category = 0;
  int selected = -1;
  String searchValue = '';
  List<bool> filterSelected = [true, false, false];

  Widget filterOption(index, {required String text, required bool selected, bool first = false, bool last = false}) {
    BoxDecoration boxDecoration;
    Color textColor;
    if (selected) {
      textColor = settingsObject.colorScheme.primaryTop;
      boxDecoration = BoxDecoration(
          gradient: reverseGradient(mainGradient(
              begin: Alignment.centerLeft, end: Alignment.centerRight)),
          borderRadius: BorderRadius.circular(10));
    } else {
      textColor = settingsObject.colorScheme.filterSelector;
      boxDecoration = BoxDecoration(
          border: Border.all(
              color: settingsObject.colorScheme.gradientMedium, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white);
    }
    return Container(
      width: 80,
      height: 30,
      decoration: boxDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              for (int i = 0; i < filterSelected.length; i++) {
                if (i == index) {
                  category = i;
                  filterSelected[i] = true;
                } else {
                  filterSelected[i] = false;
                }
              }
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> listTasks(int category){
    List filteredTasks = [];
    String filter = '';
    switch (category){
      case 0:
        filter = 'active';
        break;
      case 1:
        filter = 'completed';
        break;
      case 2:
        filter = 'missed';
        break;
      case 3:
        searchValue = searchValue.toLowerCase();
        tasksObject.allTasks.forEach((element) {
          String name = element.name.toLowerCase();
          String assignment = element.assignment.toLowerCase();
          String deadlineFormatted = DateFormat('d MMMM yyyy').format(element.deadline).toLowerCase();
          if(name.contains(searchValue) || searchValue.contains(name) || assignment.contains(searchValue) || searchValue.contains(assignment) || deadlineFormatted.contains(searchValue) || searchValue.contains(deadlineFormatted)){
            filteredTasks.add(element);
          }
        });
    }
    if (category != 3){
      tasksObject.allTasks.forEach((element) {
        if (element.status == filter){
          filteredTasks.add(element);
        }
      });
    }
    List<Widget> output = [];
    if (filteredTasks.isNotEmpty){
      filteredTasks.forEach((element) {
        Widget containerContent;
        List<Color> colors = taskColorsCreator(element);
        if (selected != element.id){
          String status = '';
          switch (element.status){
            case 'active':
              status = 'Active';
              break;
            case 'completed':
              status = 'Done';
              break;
            case 'missed':
              status = 'Missed';
              break;
          }
          containerContent = Container(
            decoration: BoxDecoration(color: colors[4], borderRadius: BorderRadius.circular(20)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selected = -1;
                    content.value = TaskPage(task: element);
                  });
                },
                onLongPress: () {
                  setState(() {
                    selected = element.id;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomPaint(
                                  painter: Circle(
                                      radius: 7.5,
                                      offset: Offset(0, 0),
                                      color: colors[0]
                                  )
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                status,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: colors[1],
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Text(
                              element.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors[2],
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          element.assignment,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors[3],
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: colors[1],
                                    fontFamily: 'Ubuntu',
                                    fontSize: 16),
                                children: [
                                  TextSpan(
                                      text: DateFormat('d MMMM ').format(element.deadline),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextSpan(
                                      text: DateFormat('yyyy').format(element.deadline)
                                  ),
                                ]
                            )
                        ),
                      )
                    ],
                  ),
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
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  tasksObject.removeTask(element);
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Yes'),
                            )
                          ],
                          elevation: 24,
                        ),
                        barrierDismissible: true
                    );
                  }
                  else if (text == 'Done') {
                    int index = tasksObject.allTasks.indexOf(element);
                    setState(() {
                      tasksObject.allTasks[index].changeStatus('completed');
                      tasksObject.writeToFile();
                      selected = -1;
                    });
                  } else if (text == 'Restore'){
                    int index = tasksObject.allTasks.indexOf(element);
                    setState(() {
                      tasksObject.allTasks[index].changeStatus('active');
                      if (tasksObject.allTasks[index].deadline.isBefore(DateTime.now())){
                        tasksObject.allTasks[index].deadline = DateTime.now().add(Duration(days: 1));
                      }
                      selected = -1;
                    });
                    tasksObject.writeToFile();
                    displayNotification(tasksObject.allTasks[index].name, tasksObject.allTasks[index].assignment, tasksObject.allTasks[index].deadline);
                  } else if (text == 'Edit'){
                    selected = -1;
                    content.value = AddContent(
                        initialIndex: 0,
                        taskEdit: true,
                        task: element,
                        subject: Subject(name: 'none', imagePath: 'none', category: 'none')
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
          MainAxisAlignment contextAlignment = MainAxisAlignment.spaceBetween;
          List<Widget> contextList = [
            _contextButton(color: Color.fromRGBO(79, 79, 79, 1), text: 'Edit', icon: Icon(Icons.edit, color: Color.fromRGBO(79, 79, 79, 1), size: 32)),
            _contextButton(color: Color.fromRGBO(232, 81, 81, 1),
                text: 'Delete',
                icon: Icon(Icons.delete_rounded,
                    color: Color.fromRGBO(232, 81, 81, 1), size: 32))
          ];
          if (element.status != 'completed'){
            contextList.insert(0, _contextButton(color: Color.fromRGBO(118, 230, 99, 1), text: 'Done', icon: Icon(Icons.task_alt_rounded, color: Color.fromRGBO(118, 230, 99, 1), size: 32)));
          } else {
            contextAlignment = MainAxisAlignment.spaceEvenly;
            contextList.insert(0, _contextButton(color: Color.fromRGBO(250, 236, 42, 1), text: 'Restore', icon: Icon(Icons.restore, color: Color.fromRGBO(250, 236, 42, 1), size: 32)));
          }
          containerContent = Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: contextAlignment,
              children: contextList,
            ),
          );
        }
        output.add(Container(
          width: MediaQuery.of(context).size.height * 0.2,
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
      });
    }
    return output;
  }

  @override
  void initState() {
    initializeSetting();
    tz.initializeTimeZones();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          selected = -1;
        });
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              decoration: BoxDecoration(
                  gradient: mainGradient(),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  boxShadow: [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    offset: Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 0.1,
                  )]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Browse Tasks',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: settingsObject.colorScheme.primaryTop),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 30,
                    child: TextField(
                      onSubmitted: (value) {
                        setState(() {
                          searchValue = value;
                          category = 3;
                        });
                      },
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          color: settingsObject.colorScheme.searchInput,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          isDense: true,
                          // contentPadding: EdgeInsets.symmetric(vertical: 5),
                          prefixIcon: Icon(
                            Icons.search,
                            color: settingsObject.colorScheme.searchInput,
                            size: 24,
                          ),
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500,
                              color: settingsObject.colorScheme.searchInput),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: settingsObject.colorScheme.searchInput,
                                width: 1,
                              )),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: settingsObject.colorScheme.searchInput,
                                  width: 2
                              )
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 20, 30, MediaQuery.of(context).size.height * 0.1 + 20),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Categories',
                                style: TextStyle(
                                    color: settingsObject.colorScheme.label,
                                    fontFamily: 'Open Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  filterOption(0,
                                      text: 'Valid',
                                      selected: filterSelected[0],
                                      first: true),
                                  filterOption(1,
                                      text: 'Done',
                                      selected: filterSelected[1]),
                                  filterOption(2,
                                      text: 'Missed',
                                      selected: filterSelected[2],
                                      last: true),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Tasks',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: settingsObject.colorScheme.label,
                                    fontFamily: 'Open Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                                children: listTasks(category),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
