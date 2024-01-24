part of 'pages.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDailyReminderEnabled = false;
  final NotificationBloc _notificationBloc = NotificationBloc();
  AppPreferences preferences = AppPreferences();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    bool storedDailyReminderState = await preferences.getDailyReminderState();
    setState(() {
      isDailyReminderEnabled = storedDailyReminderState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Reminder',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Enable Daily Reminder'),
                Spacer(),
                Switch(
                  value: isDailyReminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDailyReminderEnabled = value;
                    });
                    _notificationBloc.add(ToggleNotificationEvent(value));
                    preferences.setDailyReminderState(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }
}
