import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() => _notificationService;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool? hasPermissionToNotify;

  Future<void> init() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      hasPermissionToNotify = await _notificationsPlugin //
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      hasPermissionToNotify = await _notificationsPlugin //
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }

    if (hasPermissionToNotify ?? false) {
      const InitializationSettings initializationSettings =
          InitializationSettings(android: AndroidInitializationSettings('@drawable/cache_icon'), iOS: DarwinInitializationSettings());

      await _notificationsPlugin.initialize(initializationSettings);
    }
  }

  void percentageNotification(int percentage, int totalPercetage) {
    if (hasPermissionToNotify != true) {
      return;
    }

    final androidNotificationDetails = AndroidNotificationDetails(
      'cache',
      'Cache de dados',
      channelDescription: 'Notificação de progresso de download dos dados utilizados pelo app offline',
      progress: percentage,
      maxProgress: totalPercetage,
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: percentage != totalPercetage,
      autoCancel: false,
      ongoing: percentage != totalPercetage,
      category: AndroidNotificationCategory.progress,
      visibility: NotificationVisibility.public,
    );

    final notificationDetails = NotificationDetails(android: androidNotificationDetails);

    _notificationsPlugin.show(
      0,
      'progress notification title',
      'progress notification body',
      notificationDetails,
    );
  }
}
