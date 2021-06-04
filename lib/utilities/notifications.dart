import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> displayNotification(String title, String task, DateTime date) async{
  DateTime sendDate = date.subtract(Duration(days: 1));
  if (sendDate.isBefore(DateTime.now())){
    sendDate = DateTime.now().add(Duration(seconds: 15));
  }
  int hours = 24;
  for (int i = 0; i < 2; i++){
    hours = hours ~/ 2;
    notificationsPlugin.zonedSchedule(
        0,
        title,
        task,
        tz.TZDateTime.from(sendDate, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails('channel id', 'channel name', 'channel description')
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );
    sendDate = sendDate.add(Duration(hours: hours));
    if (sendDate.isAfter(date)){
      break;
    }
  }
}

void initializeSetting() async {
  var initializeAndroid = AndroidInitializationSettings('ic_launcher');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSetting);
}