part of 'notification_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationSuccess extends NotificationState {}

class NotificationError extends NotificationState {}
