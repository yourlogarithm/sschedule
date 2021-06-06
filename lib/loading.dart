import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'settings/settings.dart';
import 'settings/schedule.dart';
import 'settings/tasks.dart';
import 'settings/subjectIcons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ads.dart';
import 'utilities/notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class Loading extends StatefulWidget {
// const ({Key key}) : super(key: key);


  @override
  _LoadingState createState() => _LoadingState();
}
class _LoadingState extends State<Loading> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {
      return false;
    } else {
      prefs.setBool('first_time', false);
      return true;
    }
  }
  void nextRoute(){
    startTime().then((value) {
      if (value){
        Navigator.pushReplacementNamed(context, '/welcome');
      } else {
        interstitialAd();
        Navigator.pushReplacementNamed(context, '/content');
      }
    });
  }
  @override
  void initState() {
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
    settingsObject.init().then((_){
      settingsObject.setColorScheme(settingsObject.stringColorScheme);
    });
    scheduleObject.init().then((_){
      scheduleObject.setWeekDays();
    });
    subjectIconsObject.getPaths().then((value) => subjectIconsObject.paths = value);
    tasksObject.init().then((_){
      nextRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRing(
          color: Color.fromRGBO(97, 145, 123, 1),
        ),
      ),
    );
  }
}



