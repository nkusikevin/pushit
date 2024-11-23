import 'package:flutter/material.dart';
import 'package:pushit/service/notification_service.dart';

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
  final Function(NotificationItem)? onNotificationTap;

  const NotificationsScreen({
    super.key,
    required this.notifications,
    this.onNotificationTap,
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
                  // Schedule a notification for 5 seconds later
                  NotificationService.instance.scheduleNotification(
                    title: 'All notifications marked as read',
                    body: 'Your notification inbox is now clean',
                    scheduledDate:
                        DateTime.now().add(const Duration(seconds: 5)),
                  );
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
                onTap: () => onNotificationTap?.call(notification),
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
