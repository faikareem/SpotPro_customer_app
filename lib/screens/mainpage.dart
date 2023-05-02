import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotpro_customer/screens/sc_profile.dart';
import 'components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'welcome_screen.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'homepage.dart';
import '../widgets/upcoming.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'bookings.dart';

import 'package:spotpro_customer/screens/sc_profile.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {


  late PersistentTabController _controller;
  late bool _hideNavBar;
  // Initialize Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print("myBackgroundMessageHandler: $message");
    // handle the message when the app is in the background
  }
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _hideNavBar = false;
    setToken();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Display the notification when the app is in the foreground
      print('Received notification: ${message.notification?.title}');
      // display the notification to the user
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the notification when the app is in the background or closed
      print('Opened app from notification: ${message.notification?.title}');
      // Navigate to the home screen of the app
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      Navigator.pushReplacementNamed(context, '/');
    });
  }
  List<Widget> _buildScreens() => [
    HomePage(title: 'title'),

    BookingList(),
    ScrollList(),
    SCProfile(),

  ];
  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_cart),
        title: "My Bookings",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,

    ),

    PersistentBottomNavBarItem(
      icon: const Icon(Icons.notifications_active),
      title: "My Requests",
      activeColorPrimary: Colors.purple,
      inactiveColorPrimary: Colors.grey,
      inactiveColorSecondary: Colors.purple,

    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.account_circle),
      title: "My profile",
      activeColorPrimary: Colors.purple,
      inactiveColorPrimary: Colors.grey,
      inactiveColorSecondary: Colors.purple,

    ),

  ];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override

  Widget build(final BuildContext context) => Scaffold(

    key: scaffoldKey,

    drawerScrimColor: Colors.black45.withOpacity(0.6),
    drawer: Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: () {
              final ap = Provider.of<AuthProvider>(context, listen: false);
              ap.userSignOut().then(
                    (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                ),
              );
            }, child: Text('Log Out')),
          ],
        ),
      ),
    ),
    body: Stack(
      children: [

        PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          onItemSelected: (int) {
            setState(() {}); // This is required to update the nav bar if Android back button is pressed
          },

          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 0,
          selectedTabScreenContext: (final context) {
            var testContext = context;
          },
          backgroundColor: Colors.white54,
          hideNavigationBar: _hideNavBar,
          decoration: NavBarDecoration(

            colorBehindNavBar: Colors.white,
            border: Border(
              top: BorderSide(width: 1, color: Colors.grey )
            )
          ),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.easeInBack
          ),

          navBarStyle: NavBarStyle
              .style9, // Choose the nav bar style with this property
        ),

      ],
    )
  );

  Future<void> setToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the FCM token
    String? fcmToken = await messaging.getToken();
    String user_id = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference user_ref = FirebaseFirestore.instance.collection('users').doc(user_id);
    
    user_ref.update({'token': fcmToken});

    messaging.onTokenRefresh.listen((String? newToken) {
      user_ref.update({'token': fcmToken});
    });
  }
}

class CustomNavBarWidget extends StatelessWidget {
  const CustomNavBarWidget(
      this.items, {
        required final Key key,
        required this.selectedIndex,
        required this.onItemSelected,
      }) : super(key: key);
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  Widget _buildItem(
      final PersistentBottomNavBarItem item, final bool isSelected) =>
      Container(
        alignment: Alignment.center,
        height: kBottomNavigationBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: IconTheme(
                data: IconThemeData(
                    size: 26,
                    color: isSelected
                        ? (item.activeColorSecondary ?? item.activeColorPrimary)
                        : item.inactiveColorPrimary ?? item.activeColorPrimary),
                child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Material(
                type: MaterialType.transparency,
                child: FittedBox(
                    child: Text(
                      item.title!,
                      style: TextStyle(
                          color: isSelected
                              ? (item.activeColorSecondary ??
                              item.activeColorPrimary)
                              : item.inactiveColorPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    )),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(final BuildContext context) => Container(
    color: Colors.white,
    child: SizedBox(
      width: double.infinity,
      height: kBottomNavigationBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((final item) {
          final int index = items.indexOf(item);
          return Flexible(
            child: GestureDetector(
              onTap: () {
                onItemSelected(index);
              },
              child: _buildItem(item, selectedIndex == index),
            ),
          );
        }).toList(),
      ),
    ),
  );
}