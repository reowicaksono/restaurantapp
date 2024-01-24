import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setDailyReminderState(bool isDailyReminderEnabled) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool('dailyReminder', isDailyReminderEnabled);
  }

  Future<bool> getDailyReminderState() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getBool('dailyReminder') ?? false;
  }
}
