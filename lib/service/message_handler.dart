import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:pushit/service/notification_service.dart';

class MessageHandler {
  static final MessageHandler instance = MessageHandler._internal();
  Timer? _mockMessageTimer;

  factory MessageHandler() {
    return instance;
  }

  MessageHandler._internal();

  // Simulate receiving messages
  void startMockMessageStream() {
    _mockMessageTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _simulateIncomingMessage();
    });
  }

  void _simulateIncomingMessage() {
    final random = Random();
    final isForeground = random.nextBool();

    final message = NotificationMessage(
      title: 'New Message ${DateTime.now().toString()}',
      body: 'This is a ${isForeground ? 'foreground' : 'background'} message',
      payload: 'message_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (isForeground) {
      NotificationService.instance.handleForegroundMessage(message);
    } else {
      // Simulate background message by spawning an isolate
      _handleBackgroundMessage(message);
    }
  }

  Future<void> _handleBackgroundMessage(NotificationMessage message) async {
    // Simulate background processing
    await Isolate.spawn(
      (message) {
        NotificationService.handleBackgroundMessage(
            message as NotificationMessage);
      },
      message,
    );
  }

  void dispose() {
    _mockMessageTimer?.cancel();
  }
}
