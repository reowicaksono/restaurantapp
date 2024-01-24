part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class ToggleNotificationEvent extends NotificationEvent {
  final bool value;

  ToggleNotificationEvent(this.value);
}
