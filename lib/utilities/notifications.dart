import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> displayNotification(String title, String task, DateTime deadline) async{
  DateTime sendDate;
  int duration = deadline.difference(DateTime.now()).inMinutes;
  if (duration >= 2880){
    sendDate = deadline.subtract(Duration(days: 1));
  } else if (duration >= 1440){
    sendDate = deadline.subtract(Duration(hours: 12));
  } else if (duration >= 720){
    sendDate = deadline.subtract(Duration(hours: 2));
  } else if (duration >= 120){
    sendDate = deadline.subtract(Duration(hours: 1));
  } else if (duration >= 30) {
    sendDate = deadline.subtract(Duration(minutes: 15));
  } else {
    sendDate = deadline.subtract(Duration(minutes: 5));
  }
  void _sendMessage(DateTime time) {
    notificationsPlugin.zonedSchedule(
        0,
        title,
        task,
        tz.TZDateTime.from(time, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails('channel id', 'channel name', 'channel description')
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );
  }
  if (sendDate.isAfter(DateTime.now())){
      _sendMessage(sendDate);
  }
}

void initializeSetting() async {
  var initializeAndroid = AndroidInitializationSettings('notification_icon');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSetting);
}