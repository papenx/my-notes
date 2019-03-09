import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Notifier {

  Notifier();
  static void notify(String title, String body) async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    // init basic settings
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'My Notes id', 'Заметки', 'Показывать новые заметки',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

}

