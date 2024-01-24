import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';
import 'package:restaurant_app/domain/services/restaurant__api.dart';

class NotificationHelper {
  final selectNotificationSubject = ValueNotifier<String>('');

  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ApiRestaurantModel restaurant) async {
    var androidPlatformChannelSpecifics = _createAndroidNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    var restaurantList = await _fetchRestaurantList();
    var restaurantRandom = _getRandomRestaurant(restaurantList);

    var titleNotification = "<b>New Restaurant Alert!</b>";
    var titleRestaurant = '<b>${restaurantRandom.name}</b>';
    var city = '<b>${restaurantRandom.city}</b>';
    var rating = restaurantRandom.rating.toString();

    var notificationMessage = "Explore Restaurant $titleRestaurant\n"
        "in $city\n"
        "rating of $rating";

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, notificationMessage, platformChannelSpecifics,
        payload: json.encode(restaurantRandom.toJson()));
  }

  void configureSelectNotificationSubject(BuildContext context, String route) {
    selectNotificationSubject.addListener(() async {
      var data =
          Restaurant.fromJson(json.decode(selectNotificationSubject.value));
      // Process the data as needed
    });
  }

  Future<ApiRestaurantModel> _fetchRestaurantList() async {
    return await RestaurantAPI().fetchAllRestaurant();
  }

  Restaurant _getRandomRestaurant(ApiRestaurantModel restaurantList) {
    var restaurantItem = restaurantList.restaurants;
    var randomIndex = Random().nextInt(restaurantItem!.length);
    return restaurantItem[randomIndex];
  }

  AndroidNotificationDetails _createAndroidNotificationDetails() {
    return const AndroidNotificationDetails("1", "test",
        importance: Importance.max,
        priority: Priority.high,
        ticker: "test",
        styleInformation: DefaultStyleInformation(true, true));
  }
}
