import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:intl/intl.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:sschedule/utilities/scrollBehavior.dart';
import 'package:flutter/services.dart';
import 'classes.dart';

int selectedContainer = -1;
List<ValueNotifier<String>> classCount = [
  ValueNotifier<String>(scheduleObject.schedule[0].length.toString()),
  ValueNotifier<String>(scheduleObject.schedule[1].length.toString()),
  ValueNotifier<String>(scheduleObject.schedule[2].length.toString()),
  ValueNotifier<String>(scheduleObject.schedule[3].length.toString()),
  ValueNotifier<String>(scheduleObject.schedule[4].length.toString()),
  ValueNotifier<String>(scheduleObject.schedule[5].length.toString()),
  ValueNotifier<String>(scheduleObject.schedule[6].length.toString())
];
void reloadNotifiers(){
  for (int i = 0; i < 7; i++){
    classCount[i].value = scheduleObject.schedule[i].length.toString();
  }
}

class WeekSchedule extends StatefulWidget {
  final bool transition;
  final int initialValue;
  const WeekSchedule({this.transition = false, this.initialValue = -1});

  @override
  _WeekScheduleState createState() => _WeekScheduleState();
}

class _WeekScheduleState extends State<WeekSchedule> with SingleTickerProviderStateMixin {
  int subtractionVal = scheduleObject.weekStart == 'Monday' ? 1 : 0;
  late int initialIndex;
  late TabController _tabController;
  late int selected;
  ScrollController scrollController = ScrollController();

  List<Widget> getDays() {
    List<Widget> output = [];
    DateTime firstDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday - subtractionVal));
    for (int i = 0; i < 7; i++) {
      Color containerColor = Color.fromRGBO(245, 247, 249, 1);
      Color dateColor = settingsObject.colorScheme.label;
      Color dayColor = Color.fromRGBO(127, 137, 157, 1);
      BoxShadow shadow = BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3, spreadRadius: 1);
      if (i == selected) {
        containerColor = settingsObject.colorScheme.gradientMedium;
        dateColor = Colors.white;
        dayColor = Colors.white;
        shadow = BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 3,
            spreadRadius: 1);
      }
      DateTime date = firstDay.add(Duration(days: i));
      output.add(
        Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            width: 70,
            decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [shadow]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d').format(date),
                  style: TextStyle(
                    height: 1,
                      color: dateColor,
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('E').format(date),
                  style: TextStyle(
                      height: 1,
                      color: dayColor,
                      fontFamily: 'Open Sans',
                      fontSize: 20
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: settingsObject.colorScheme.primaryTop,
                    shape: BoxShape.circle
                  ),
                  child: ValueListenableBuilder<String>(
                    valueListenable: classCount[i],
                    builder: (BuildContext context, String value, _){
                      return Text(
                        value,
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold
                        ),
                      );
                    },
                  )
                )
              ],
            )),
      );
    }
    return output;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.transition){
      initialIndex = widget.initialValue;
    } else {
      initialIndex = DateTime.now().weekday - subtractionVal;
    }
    _tabController =
        TabController(length: 7, vsync: this, initialIndex: initialIndex);
    selected = initialIndex;
    scrollController.addListener(() {
      if (scrollController.position.pixels >= MediaQuery.of(context).size.height * 0.15){
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ));
      }
    });
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
          selectedContainer = -1;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        gradient: mainGradient(
                            begin: Alignment.centerRight, end: Alignment.centerLeft)),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: settingsObject.colorScheme.primaryTop,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 24),
                                  children: [
                                TextSpan(
                                    text: DateFormat('EEEE ').format(DateTime.now()),
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: DateFormat('d MMMM').format(DateTime.now()))
                              ])),
                          Text(
                            'Schedule',
                            style: TextStyle(
                                color: settingsObject.colorScheme.secondaryTop,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: mainGradient(begin: Alignment.centerRight, end: Alignment.centerLeft)
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 35, 0, MediaQuery.of(context).size.height * 0.1 + 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.65
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              child: ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: TabBar(
                                  onTap: (index) {
                                    setState(() {
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      selected = index;
                                    });
                                  },
                                  indicatorColor: Colors.transparent,
                                  controller: _tabController,
                                  isScrollable: true,
                                  tabs: getDays(),
                                ),
                              ),
                            ),
                            Divider(
                              color: Color.fromRGBO(246, 246, 246, 1),
                              thickness: 1,
                            ),
                            Classes(weekday: selected)
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
