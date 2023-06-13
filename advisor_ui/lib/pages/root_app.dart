import 'package:advisor_ui/pages/budget_page.dart';
import 'package:advisor_ui/pages/chat.dart';
import 'package:advisor_ui/pages/create_budge_page.dart';
import 'package:advisor_ui/pages/daily_page.dart';
import 'package:advisor_ui/pages/profile_page.dart';
import 'package:advisor_ui/pages/stats_page.dart';
import 'package:advisor_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    BudgetPage(),
    ChatScreen(),
    CreatBudgetPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Your App Title'),
      ),
     
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            // Carries the details of User
            const DrawerHeader(
              padding: const EdgeInsets.only(
                  top: 0),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "Aniraj Shahi",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("anirajshahi@gmail.com"),
                currentAccountPictureSize: Size.square(60),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.teal),
                  ),
                ),
              ), 
              ),

            // ListTile Widget // Provides the options
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
               onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfilePage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("My Course"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text('Saved Videos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedTab(4);
        },
        child: Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: Color.fromARGB(255, 21, 126, 191),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_star,
      Ionicons.md_wallet,
      Ionicons.chatbox_ellipses,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.white.withOpacity(0.5),
      icons: iconItems,
      backgroundColor: Colors.black,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
    );
  }

  void selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
