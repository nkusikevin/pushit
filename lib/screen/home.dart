import 'package:flutter/material.dart';
import 'package:pushit/screen/notifications.dart';
import 'package:pushit/service/notification_service.dart';
import 'package:pushit/service/message_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _titles = ['Home', 'Search', 'Notifications', 'Profile'];

  // Mock notifications data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'New Message',
      description: 'You have a new message from John',
      time: '2m ago',
      isRead: false,
    ),
    NotificationItem(
      title: 'Event Reminder',
      description: 'Team meeting in 30 minutes',
      time: '5m ago',
      isRead: false,
    ),
    NotificationItem(
      title: 'System Update',
      description: 'A new version is available for download',
      time: '1h ago',
      isRead: true,
    ),
    NotificationItem(
      title: 'Payment Successful',
      description: 'Your subscription has been renewed',
      time: '2h ago',
      isRead: true,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  Future<void> _initializeNotifications() async {
    await NotificationService.instance.init();
    await NotificationService.instance.requestPermissions();
  }


  

  @override
  void initState() {
    super.initState();
    _initializeNotifications();

    // Start listening for messages
    NotificationService.instance.messageStream.listen((message) {
      // Add new notification to the list
      setState(() {
        _notifications.insert(
          0,
          NotificationItem(
            title: message.title,
            description: message.body,
            time: 'Just now',
            isRead: false,
          ),
        );
      });
    });

    // Start mock message stream (for testing)
    MessageHandler.instance.startMockMessageStream();
  }

void _addNewNotification() {
    // Create a new notification
    final newNotification = NotificationItem(
      title: 'New Alert',
      description: 'This is a new notification (${DateTime.now().toString()})',
      time: 'Just now',
      isRead: false,
    );

    // Show the local notification
    NotificationService.instance.showNotification(
      title: newNotification.title,
      body: newNotification.description,
    );

    // Update the state to include the new notification
    setState(() {
      _notifications.insert(
          0, newNotification); // Add to the beginning of the list
    });
  }

   @override
  void dispose() {
    MessageHandler.instance.dispose();
    NotificationService.instance.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Required for more than 3 items
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            // removed const here
            icon: Badge(
              label: Text(
                  _notifications.where((n) => !n.isRead).length.toString()),
              child: const Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 80),
              const SizedBox(height: 16),
              const Text('Home Page Content'),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _addNewNotification,
                icon: const Icon(Icons.notification_add),
                label: const Text('Add New Notification'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return const Center(
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80),
            SizedBox(height: 16),
            Text('Search Page Content'),
          ],
        )
        );
      case 2:
        return NotificationsScreen(
          notifications: _notifications,
          onNotificationTap: (notification) {
            // Show a local notification when tapping a notification item
            NotificationService.instance.showNotification(
              title: notification.title,
              body: notification.description,
              payload: notification.title,
            );
          },
        );
      case 3:
        return const Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80),
            SizedBox(height: 16),
            Text('Profile Page Content'),
          ],
        )
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
