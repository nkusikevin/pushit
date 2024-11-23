import 'package:flutter/material.dart';



class NotificationItem {
  final String title;
  final String description;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatelessWidget {
  final List<NotificationItem> notifications;

  const NotificationsScreen({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '${notifications.where((n) => !n.isRead).length} unread notifications',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Add mark all as read functionality
                },
                child: const Text('Mark all as read'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.isRead
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  child: Icon(
                    Icons.notifications,
                    color: notification.isRead ? Colors.grey : Colors.blue,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.description),
                    const SizedBox(height: 4),
                    Text(
                      notification.time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotificationsSheet extends StatelessWidget {
  final List<NotificationItem> notifications;
  final VoidCallback onViewAll;

  const NotificationsSheet({
    super.key,
    required this.notifications,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notification.description),
                trailing: Text(
                  notification.time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
