import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> displayNotification(String title, String task, DateTime deadline) async{
  DateTime sendDate = deadline.subtract(Duration(days: 1));
  if (sendDate.isBefore(DateTime.now())){
    sendDate = DateTime.now().add(Duration(seconds: 15));
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
  _sendMessage(sendDate);
}

void initializeSetting() async {
  var initializeAndroid = AndroidInitializationSettings('notification_icon');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSetting);
}