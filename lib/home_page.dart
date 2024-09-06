import 'package:flutter/material.dart';

import 'notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> download() async {
    final notificationService = NotificationService();

    const time = 5;

    for (int i = 0; i <= time; i++) {
      notificationService.percentageNotification(i, time);

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: download,
              child: const Text('Mostrar notificação'),
            ),
          ],
        ),
      ),
    );
  }
}
