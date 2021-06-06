import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:sschedule/utilities/painter.dart';
import 'weekSchedule.dart';

class Classes extends StatefulWidget {
  final int weekday;

  const Classes({required this.weekday});

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  late Subject addClassSubjectValue;
  Subject defaultSubject = Subject(name: 'Subject', imagePath: 'none', category: 'none');
  DateTime addClassTime = DateTime.now();
  String hour = 'H';
  String minute = 'M';
  TextEditingController noteController = TextEditingController();

  List<Widget> getClasses() {
    int subtractionVal = scheduleObject.weekStart == 'Monday' ? 1 : 0;
    DateTime firstDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday - subtractionVal));
    DateTime date = firstDay.add(Duration(days: widget.weekday));
    List<Widget> output = [];
    scheduleObject.schedule[widget.weekday].asMap().forEach((index, element) {
      DateTime classTimeStart = DateTime(date.year, date.month, date.day, element.startHour, element.startMinute);
      DateTime classTimeEnd = DateTime(date.year, date.month, date.day, element.endHour, element.endMinute);
      Color timeColor = Color.fromRGBO(204, 207, 212, 1);
      if (classTimeStart.isBefore(DateTime.now()) && classTimeEnd.isAfter(DateTime.now())){
        timeColor = settingsObject.colorScheme.secondaryTop;
      }
      Widget contentUnselected = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedContainer = -1;
            });
          },
          onLongPress: () {
            setState(() {
              selectedContainer = index;
            });
          },
          borderRadius: BorderRadius.horizontal(left: Radius.circular(25)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              element.subject.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1,
                                  color: settingsObject.colorScheme.className,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              element.note.isEmpty ? 'No additional info' : element.note,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color.fromRGBO(126, 126, 126, 1),
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: settingsObject.colorScheme.searchInput,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(element.subject.imagePath),
                  ),
                  radius: 38,
                )
              ],
            ),
          ),
        ),
      );
      Widget contentSelected = Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: IconButton(
              onPressed: () {
                setState(() {
                  scheduleObject.removeClass(widget.weekday, index);
                  reloadNotifiers();
                  selectedContainer = -1;
                });
                scheduleObject.writeToFile();
              },
              icon: Icon(
                Icons.delete_rounded,
                color: Color.fromRGBO(232, 81, 81, 1),
                size: 32,
              )
          )
      );
      output.add(Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3 - 40,
              height: MediaQuery.of(context).size.height * 0.175,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('Hm').format(classTimeStart),
                    style: TextStyle(
                      color: timeColor,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
                      return Container(
                        width: constraints.widthConstraints().maxWidth,
                        height: constraints.heightConstraints().maxHeight,
                        child: CustomPaint(
                          foregroundPainter: Lines(timeColor: timeColor),
                        ),
                      );
                    }),
                  ),
                  Text(
                    DateFormat('Hm').format(classTimeEnd),
                    style: TextStyle(
                        color: timeColor,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.175,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 247, 249, 1),
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 5,
                        spreadRadius: 1)
                  ]
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: index == selectedContainer ? contentSelected : contentUnselected
              ),
            )
          ],
        ),
      ));
    });
    scheduleObject.bubbleSortSubjects();
    List dropdownElements = [defaultSubject] + scheduleObject.subjects;
    List<DropdownMenuItem<Subject>> dropdownValues = [];
    dropdownElements.forEach((element) {
      dropdownValues.add(DropdownMenuItem<Subject>(
          value: element,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              element.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 14, fontWeight: FontWeight.w600,
                color: Color.fromRGBO(106, 106, 106, 1)
              ),
            ),
          )));
    });
    output.add(Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RawMaterialButton(
            constraints: BoxConstraints(minWidth: 12),
            onPressed: () {
              if(addClassSubjectValue.name != 'Subject' && hour != 'H' && minute != 'M'){
                setState(() {
                  scheduleObject.schedule[widget.weekday].add(Class(subject: addClassSubjectValue, startHour: addClassTime.hour, startMinute: addClassTime.minute, note: noteController.text));
                  scheduleObject.bubbleSortSchedule(widget.weekday);
                  scheduleObject.writeToFile();
                  addClassSubjectValue = defaultSubject;
                  hour = 'H';
                  minute = 'M';
                  noteController.text = '';
                  reloadNotifiers();
                });
              }
            },
            fillColor: settingsObject.colorScheme.searchInput,
            elevation: 1,
            child: Icon(
              Icons.add,
              color: settingsObject.colorScheme.gradientMedium,
              size: 28.0,
            ),
            padding: EdgeInsets.all(12.0),
            shape: CircleBorder(),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.175,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(245, 247, 249, 1),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 5,
                      spreadRadius: 1)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton(
                        value: addClassSubjectValue,
                        icon: Icon(Icons.arrow_drop_down),
                        underline: Container(
                          height: 2,
                          color: settingsObject.colorScheme.gradientMedium,
                        ),
                        onChanged: (Subject? newValue) {
                          setState(() {
                            addClassSubjectValue = newValue!;
                          });
                        },
                        items: dropdownValues,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          DatePicker.showTimePicker(
                              context,
                              showTitleActions: true,
                              showSecondsColumn: false,
                              currentTime: addClassTime,
                              onConfirm: (time) {
                                DateTime now = DateTime.now();
                                setState(() {
                                  addClassTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                  hour = DateFormat('H').format(time);
                                  minute = DateFormat('m').format(time);
                                  if (minute.length == 1) {
                                    minute = '0' + minute;
                                  }
                            });
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.125,
                              height: MediaQuery.of(context).size.width * 0.125,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(225, 229, 232, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  hour,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 137, 157, 1),
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  ':',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 137, 157, 1),
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.125,
                              height: MediaQuery.of(context).size.width * 0.125,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(225, 229, 232, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  minute,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(127, 137, 157, 1),
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.175-20,
                  child: TextField(
                      controller: noteController,
                      textInputAction: TextInputAction.done,
                      maxLines: 6,
                      cursorColor: settingsObject.colorScheme.gradientMedium,
                      maxLength: 25,
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 13
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Add a note...',
                        hintStyle: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 13
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: settingsObject.colorScheme.gradientMedium,
                              width: 2,
                            )
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
    return output;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addClassSubjectValue = defaultSubject;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
        child: Column(
          children: getClasses(),
        ));
  }
}

