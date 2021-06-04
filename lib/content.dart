import 'package:flutter/material.dart';
import 'package:sschedule/pages/weekSchedule/weekSchedule.dart';
import 'package:sschedule/settings/settings.dart';
import 'pages/home/home.dart';
import 'pages/taskManager/allTasks.dart';
import 'package:flutter/services.dart';
import 'package:sschedule/settings/tasks.dart';
import 'package:sschedule/pages/addContent/addContent.dart';
import 'package:sschedule/pages/settingsPage/settingsPage.dart';
import 'package:sschedule/settings/schedule.dart';

ValueNotifier<Widget> content = ValueNotifier(Home());

Color passive = Color.fromRGBO(188, 193, 205, 1);
Color active = Color.fromRGBO(131, 136, 167, 1);

List<ValueNotifier<Color>> bottomColors = [
  ValueNotifier(active),
  ValueNotifier(passive),
  ValueNotifier(passive),
  ValueNotifier(passive),
  ValueNotifier(passive),
];

reselectBottomColor({int index = -1}){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  if (index >= 0){
    for (int i = 0; i < bottomColors.length; i++){
      if (i == index){
        bottomColors[i].value = active;
      } else {
        bottomColors[i].value = passive;
      }
    }
  } else {
    bottomColors.forEach((element) {
      element.value = passive;
    });
  }
}

class MainPage extends StatefulWidget {
  // const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(246, 246, 246, 1),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ValueListenableBuilder<Widget>(
                valueListenable: content,
                builder: (context, value, _){
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: value,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 5,
                      spreadRadius: 0.1,
                    )]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder<Color>(valueListenable: bottomColors[0], builder: (context, value, _){
                      return IconButton(
                          onPressed: () {
                            reselectBottomColor(index: 0);
                            setState(() {
                              content.value = Home();
                            });
                          },
                          icon: Icon(Icons.home_rounded),
                          color: value,
                          iconSize: 32,
                          padding: EdgeInsets.all(0)
                      );
                    }
                    ),
                    ValueListenableBuilder<Color>(valueListenable: bottomColors[1], builder: (context, value, _){
                      return IconButton(
                          onPressed: () {
                            reselectBottomColor(index: 1);
                            content.value = WeekSchedule();
                          },
                          icon: Icon(Icons.calendar_today),
                          color: value,
                          iconSize: 32,
                          padding: EdgeInsets.all(0)
                      );
                    }
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        reselectBottomColor();
                        content.value = AddContent(task: SingleTask(name: 'none', assignment: 'none', creationDate: DateTime(1900), deadline: DateTime(1900), id: -1), subject: Subject(name: 'none', imagePath: 'none', category: 'none'));
                      },
                      fillColor: settingsObject.colorScheme.gradientStart,
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Icon(
                        Icons.add,
                        color: settingsObject.colorScheme.searchInput,
                        size: 24.0,
                      ),
                      padding: EdgeInsets.all(12.0),
                      shape: CircleBorder(),
                    ),
                    ValueListenableBuilder<Color>(valueListenable: bottomColors[2], builder: (context, value, _){
                      return IconButton(
                          onPressed: () {
                            reselectBottomColor(index: 2);
                            content.value = AllTasksPage();
                          },
                          icon: Icon(Icons.assignment_outlined),
                          color: value,
                          iconSize: 32,
                          padding: EdgeInsets.all(0)
                      );
                    }
                    ),
                    ValueListenableBuilder<Color>(valueListenable: bottomColors[4], builder: (context, value, _){
                      return IconButton(
                          onPressed: () {
                            reselectBottomColor(index: 4);
                            content.value = SettingsPage();
                          },
                          icon: Icon(Icons.settings_rounded),
                          color: value,
                          iconSize: 32,
                          padding: EdgeInsets.all(0)
                      );
                    }
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
