import 'package:flutter/material.dart';
import 'package:pushit/screen/notifications.dart';

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

  void _showQuickNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => NotificationsSheet(
        notifications: _notifications.take(2).toList(),
        onViewAll: () {
          Navigator.pop(context);
          setState(() {
            _selectedIndex = 2; // Switch to notifications tab
          });
        },
      ),
    );
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
        return const Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80),
            SizedBox(height: 16),
            Text('Home Page Content'),
          ],
        )
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
        return NotificationsScreen(notifications: _notifications);
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
