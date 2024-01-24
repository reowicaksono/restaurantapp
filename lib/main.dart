import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/database/database_helper.dart';
import 'package:restaurant_app/domain/bloc/detail/restaurant_detail_bloc.dart';
import 'package:restaurant_app/domain/bloc/favorites/favorite_bloc.dart';

import 'package:restaurant_app/domain/bloc/list/restaurant__bloc.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/view/pages.dart';

void main() async {
  await AndroidAlarmManager.initialize();
  await NotificationHelper()
      .initNotifications(FlutterLocalNotificationsPlugin());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RestaurantBloc()),
        BlocProvider(create: (_) => RestaurantDetailBloc()),
        BlocProvider(create: (_) => FavoriteBloc(DatabaseHelper())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
