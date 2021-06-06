import 'package:flutter/material.dart';
import 'package:sschedule/pages/addContent/addSubject.dart';
import 'package:sschedule/pages/addContent/addTask.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/utilities/scrollBehavior.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/settings/schedule.dart';

class AddContent extends StatefulWidget {
  final int initialIndex;
  final bool taskEdit;
  final bool subjectEdit;
  final SingleTask task;
  final Subject subject;
  const AddContent({this.initialIndex = 0, this.taskEdit = false, this.subjectEdit = false, required this.task, required this.subject});
  @override
  _AddContentState createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(gradient: mainGradient()),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: settingsObject.colorScheme.searchInput,
                      width: 4
                    )
                  ),
                  controller: _tabController,
                  labelStyle: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                  ),
                  labelColor: settingsObject.colorScheme.searchInput,
                  unselectedLabelColor: settingsObject.colorScheme.secondaryTop,
                  tabs: [
                    Tab(
                      child: Text('Task')
                    ),
                    Tab(
                      child: Text('Subject')
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75 + 40,
            child: Container(
              color: settingsObject.colorScheme.gradientEnd,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 5,
                          spreadRadius: 0.5)
                    ]
                ),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AddTask(edit: widget.taskEdit, task: widget.task),
                      AddSubject(edit: widget.subjectEdit, subject: widget.subject)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Text(
// 'Task',
// style: TextStyle(
// color: tabsColors[0],
// fontFamily: 'Ubuntu',
// fontSize: 32,
// fontWeight: FontWeight.bold
// )
// ),
// Text(
// 'Subject',
// style: TextStyle(
// color: tabsColors[1],
// fontFamily: 'Ubuntu',
// fontSize: 32,
// fontWeight: FontWeight.bold
// )
// )
// ],
// ),
