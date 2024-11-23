// // notification_service.dart
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._();
//   static NotificationService get instance => _instance;
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   NotificationService._();

//   // Future<void> init() async {
//   //   // Initialize timezone
//   //   tz.initializeTimeZones();

//   //   // Initialize notification settings for Android
//   //   const AndroidInitializationSettings androidInitializationSettings =
//   //       AndroidInitializationSettings('@mipmap/ic_launcher');

//   //   // Initialize notification settings for iOS
//   //   const DarwinInitializationSettings iOSInitializationSettings =
//   //       DarwinInitializationSettings(
//   //     requestAlertPermission: true,
//   //     requestBadgePermission: true,
//   //     requestSoundPermission: true,
//   //   );

//   //   // Combined initialization settings
//   //   const InitializationSettings initializationSettings =
//   //       InitializationSettings(
//   //     android: androidInitializationSettings,
//   //     iOS: iOSInitializationSettings,
//   //   );

//   //   // Initialize the plugin
//   //   await _flutterLocalNotificationsPlugin.initialize(
//   //     initializationSettings,
//   //     onDidReceiveNotificationResponse: (NotificationResponse response) {
//   //       // Handle notification tap
//   //       print('Notification clicked: ${response.payload}');
//   //     },
//   //   );
//   // }

//     static Future<void> init() async {
//     // Initialize settings for different platforms
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     // Initialize the plugin with the settings
//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       // Optional: handle notification taps
//       onDidReceiveNotificationResponse: (details) {
//         // Handle notification tap
//       },
//     );
//   }

//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'default_channel', // Channel ID
//       'Default Channel', // Channel name
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//     );

//     const DarwinNotificationDetails iOSNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iOSNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }

//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'scheduled_channel',
//       'Scheduled Channel',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iOSNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iOSNotificationDetails,
//     );

//        await _flutterLocalNotificationsPlugin.zonedSchedule(
//       1, // Notification ID
//       title,
//       body,
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }
// }


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  static const String backgroundChannelKey = 'background_channel_key';

  factory NotificationService() {
    return instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Stream controller for handling foreground messages
  final StreamController<NotificationMessage> _messageStreamController =
      StreamController<NotificationMessage>.broadcast();
  Stream<NotificationMessage> get messageStream =>
      _messageStreamController.stream;

  // Background port for isolate communication
  static const String backgroundMessagePort = 'background_notification_port';

  // Initialize the service
  Future<void> init() async {
    // Initialize local notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationTap(details);
      },
    );

    // Register background message port
    final backgroundPort = ReceivePort();
    IsolateNameServer.registerPortWithName(
      backgroundPort.sendPort,
      backgroundMessagePort,
    );

    // Listen to background messages
    backgroundPort.listen((message) {
      if (message is NotificationMessage) {
        _handleBackgroundMessage(message);
      }
    });
  }

  // Handle foreground messages
  Future<void> handleForegroundMessage(NotificationMessage message) async {
    // Add message to stream for UI updates
    _messageStreamController.add(message);

    // Show notification
    await showNotification(
      title: message.title,
      body: message.body,
      payload: message.payload,
    );
  }

  // Handle background messages
  static Future<void> handleBackgroundMessage(
      NotificationMessage message) async {
    // Get the background message port
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName(backgroundMessagePort);

    if (sendPort != null) {
      // Send message to main isolate
      sendPort.send(message);
    }
  }

  // Show a notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Channel',
      channelDescription: 'Channel for scheduled notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecond,
      title,
      body,
      tz.TZDateTime.from(
          scheduledDate, tz.local), // Convert DateTime to TZDateTime
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  void _handleNotificationTap(NotificationResponse details) {
    // Handle notification tap
    if (details.payload != null) {
      // Navigate or perform action based on payload
      print('Notification tapped with payload: ${details.payload}');
    }
  }

  Future<void> _handleBackgroundMessage(NotificationMessage message) async {
    // Show notification
    await showNotification(
      title: message.title,
      body: message.body,
      payload: message.payload,
    );
  }

  // Request notification permissions
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // Clean up resources
  void dispose() {
    _messageStreamController.close();
    IsolateNameServer.removePortNameMapping(backgroundMessagePort);
  }
}

// Message model
class NotificationMessage {
  final String title;
  final String body;
  final String? payload;
  final DateTime timestamp;

  NotificationMessage({
    required this.title,
    required this.body,
    this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
