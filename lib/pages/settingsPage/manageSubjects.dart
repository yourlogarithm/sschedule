import 'package:flutter/material.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:sschedule/utilities/scrollBehavior.dart';
import 'package:sschedule/pages/addContent/addContent.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/content.dart';
import 'package:flutter/services.dart';

class ManageSubjects extends StatefulWidget {
  // const ManageSubjects({Key key}) : super(key: key);

  @override
  _ManageSubjectsState createState() => _ManageSubjectsState();
}

class _ManageSubjectsState extends State<ManageSubjects> {
  ScrollController scrollController = ScrollController();

  Widget getSubjects() {
    List<Widget> output = [];
    scheduleObject.subjects.forEach((subject) {
      output.add(
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(246, 246, 246, 1)
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                content.value = AddContent(initialIndex: 1, subjectEdit: true, subject: subject, task: SingleTask(name: 'none', assignment: 'none', creationDate: DateTime(1900), deadline: DateTime(1900), id: -1));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: settingsObject.colorScheme.searchInput,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(subject.imagePath),
                      ),
                      radius: 38,
                    ),
                    Flexible(
                      child: Text(
                        subject.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: settingsObject.colorScheme.tertiaryText
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: settingsObject.colorScheme.tertiaryText,
                    )
                  ],
                ),
              ),
            ),
          )
        )
      );
    });
    return Column(
      children: output,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(gradient: mainGradient()),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: settingsObject.colorScheme.gradientEnd,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.9
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, MediaQuery.of(context).size.height * 0.1 + 20),
                    child: Column(
                      children: [
                        Text(
                          'Manage your subjects',
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: settingsObject.colorScheme.label),
                        ),
                        getSubjects()
                      ],
                    ),
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
