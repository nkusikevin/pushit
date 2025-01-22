// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// /// A notification action which triggers a URL launch event.
// const String urlLaunchActionId = 'id_1';

// /// A notification action which triggers an app navigation event.
// const String navigationActionId = 'id_3';

// /// Defines an iOS/MacOS notification category for plain actions.
// const String darwinNotificationCategoryPlain = 'plainCategory';

// /// Global instance of the FlutterLocalNotificationsPlugin.
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// /// Simple incrementing ID for demo notifications.
// int id = 0;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Android initialization settings
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');

//   // iOS/macOS: define a category that supports plain actions
//   final List<DarwinNotificationCategory> darwinNotificationCategories =
//       <DarwinNotificationCategory>[
//     DarwinNotificationCategory(
//       darwinNotificationCategoryPlain,
//       actions: <DarwinNotificationAction>[
//         DarwinNotificationAction.plain('id_1', 'Action 1'),
//         DarwinNotificationAction.plain('id_2', 'Action 2'),
//         DarwinNotificationAction.plain(navigationActionId, 'Action 3'),
//       ],
//     ),
//   ];

//   // iOS/macOS initialization settings
//   final DarwinInitializationSettings initializationSettingsDarwin =
//       DarwinInitializationSettings(
//     notificationCategories: darwinNotificationCategories,
//   );

//   // Consolidated initialization settings
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsDarwin,
//     macOS: initializationSettingsDarwin,
//   );

//   // Initialize the plugin
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MyHomePage(),
//   ));
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   // List of pages to display
//   final List<Widget> _pages = [
//     const HomePage(),
//     const UpdatesPage(),
//     const DocumentsPage(),
//     const ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Plain Actions Notification'),
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.update),
//             label: 'Updates',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.document_scanner),
//             label: 'Documents',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   Future<void> _showNotificationWithActions() async {
//     // ANDROID: define actions
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'Your Channel Name',
//       channelDescription: 'Channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       actions: <AndroidNotificationAction>[
//         AndroidNotificationAction(
//           urlLaunchActionId,
//           'Action 1',
//           icon: DrawableResourceAndroidBitmap('food'),
//           contextual: true,
//         ),
//         AndroidNotificationAction(
//           'id_2',
//           'Action 2',
//           icon: DrawableResourceAndroidBitmap('secondary_icon'),
//         ),
//         AndroidNotificationAction(
//           navigationActionId,
//           'Action 3',
//           icon: DrawableResourceAndroidBitmap('secondary_icon'),
//           showsUserInterface: true,
//           cancelNotification: false,
//         ),
//       ],
//     );

//     // iOS/macOS: reference the plain-actions category
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       categoryIdentifier: darwinNotificationCategoryPlain,
//     );

//     // Linux: define actions
//     const LinuxNotificationDetails linuxNotificationDetails =
//         LinuxNotificationDetails(
//       actions: <LinuxNotificationAction>[
//         LinuxNotificationAction(
//           key: urlLaunchActionId,
//           label: 'Action 1',
//         ),
//         LinuxNotificationAction(
//           key: navigationActionId,
//           label: 'Action 2',
//         ),
//       ],
//     );

//     // Combine platform details
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: darwinNotificationDetails,
//       macOS: darwinNotificationDetails,
//       linux: linuxNotificationDetails,
//     );

//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//       id++,
//       'plain title',
//       'plain body',
//       notificationDetails,
//       payload: 'item_z',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _showNotificationWithActions,
//         child: const Text('Show Notification with Plain Actions'),
//       ),
//     );
//   }
// }

// class UpdatesPage extends StatelessWidget {
//   const UpdatesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Updates Page'),
//     );
//   }
// }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Profile Page'),
//     );
//   }
// }

// class DocumentsPage extends StatelessWidget {
//   const DocumentsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Documents Page'),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A notification action which triggers a URL launch event.
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers an app navigation event.
const String navigationActionId = 'id_3';

/// Defines an iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

/// Global instance of the FlutterLocalNotificationsPlugin.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Simple incrementing ID for demo notifications.
int id = 0;

// Add a GlobalKey for navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS/macOS: define a category that supports plain actions
  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'View certificate'),
        DarwinNotificationAction.plain('id_2', 'Pay fine'),
      ],
    ),
  ];

  // iOS/macOS initialization settings
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    notificationCategories: darwinNotificationCategories,
  );

  // Consolidated initialization settings
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );

  // Initialize the plugin with action handling
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Simplify navigation logic
      if (response.actionId == null) return; // Handle empty action

      String route = '/';
      switch (response.actionId) {
        case 'id_1':
          route = '/updates';
          break;
        case 'id_2':
          route = '/documents';
          break;
        case 'id_3':
          route = '/profile';
          break;
      }

      // Navigate using a simpler approach
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        route,
        (route) => route.isFirst,
      );
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(initialIndex: 0),
        '/updates': (context) => const MyHomePage(initialIndex: 1),
        '/documents': (context) => const MyHomePage(initialIndex: 2),
        '/profile': (context) => const MyHomePage(initialIndex: 3),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int initialIndex;

  const MyHomePage({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const UpdatesPage(),
    const DocumentsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plain Actions Notification'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _showNotificationWithActions() async {
    // ANDROID: define actions
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'Channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          urlLaunchActionId,
          'View certificate',
        ),
        AndroidNotificationAction(
          'id_2',
          'Pay fine',
        ),
        AndroidNotificationAction(
          navigationActionId,
          'View profile',
          showsUserInterface: true,
          cancelNotification: false,
        ),
      ],
    );

    // iOS/macOS: reference the plain-actions category
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    // Combine platform details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      id++,
      'plain title',
      'plain body',
      notificationDetails,
      payload: 'item_z',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _showNotificationWithActions,
        child: const Text('Show Notification with Plain Actions'),
      ),
    );
  }
}

class UpdatesPage extends StatelessWidget {
  const UpdatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updates'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.update, size: 64),
            SizedBox(height: 16),
            Text('Updates Page - Opened from Notification'),
          ],
        ),
      ),
    );
  }
}

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.document_scanner, size: 64),
            SizedBox(height: 16),
            Text('Documents Page - Opened from Notification'),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64),
            SizedBox(height: 16),
            Text('Profile Page - Opened from Notification'),
          ],
        ),
      ),
    );
  }
}
