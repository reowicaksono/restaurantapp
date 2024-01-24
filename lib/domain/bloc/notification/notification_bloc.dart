import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/domain/services/background_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<ToggleNotificationEvent>((event, emit) async {
      Stream<NotificationState> _mapToggleNotificationEventToState(
        ToggleNotificationEvent event,
      ) async* {
        try {
          if (event.value) {
            if (kDebugMode) {
              debugPrint("Cancel");
            }

            await AndroidAlarmManager.oneShot(
              const Duration(seconds: 5),
              1,
              BackgroundService.callback,
              // startAt: test,
              exact: true,
              wakeup: true,
            );
          } else {
            if (kDebugMode) {
              debugPrint("Cancel");
            }
            final SendPort? send =
                IsolateNameServer.lookupPortByName("Isolate");
            send?.send(event.value);
            await AndroidAlarmManager.cancel(1);
          }

          yield NotificationSuccess();
        } catch (e) {
          yield NotificationError();
        }
      }
    });
  }
}
