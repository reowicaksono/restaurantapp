part of 'pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _bottonNavIndex = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'Restoran',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorit',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Pengaturan',
    ),
  ];

  final List<Widget> _listWidget = [
    const ListRestaurant(),
    const RestaurantFavorite(),
    const SettingsPage(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottonNavIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(
        context, '/detail_restaurant');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottonNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        currentIndex: _bottonNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
