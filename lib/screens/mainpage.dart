import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'welcome_screen.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'homepage.dart';
import '../widgets/upcoming.dart';




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

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _hideNavBar = false;

  }
  List<Widget> _buildScreens() => [
    HomePage(title: 'title'),
    const ScrollList(),
  ];
  List<PersistentBottomNavBarItem> _navBarsItems() => [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications_active),
        title: "Home",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (final context) => HomePage(title: 'title'),
            "/second": (final context) => HomePage(title: 'title'),
        },
      ),
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
          backgroundColor: Colors.white70,
          hideNavigationBar: _hideNavBar,
          decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
          ),
          navBarStyle: NavBarStyle
              .style9, // Choose the nav bar style with this property
        ),
        Positioned(
          left: 10,
          top: 22,
          child: IconButton(
            icon: Icon(Icons.menu_rounded, size: 28, color: Colors.grey.shade900,),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
        )
      ],
    )
  );
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