import 'dart:convert';

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
import 'package:http/http.dart' as http;
import '../api_data/userProfile.dart';
import '../core/route/app_route_name.dart';
import '../module/home/presentation/home_screen.dart';

class RootApp extends StatefulWidget {

  final String accessToken;
  RootApp({required this.accessToken});
  @override
  _RootAppState createState() => _RootAppState();
}
class _RootAppState extends State<RootApp> {
  dynamic responseData; 
  late Future<UserProfile> _profileFuture;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int pageIndex = 0;
  late List<Widget> pages;
  // List<Widget> pages = [
  //   DailyPage(),
  //   StatsPage(),
  //   BudgetPage(),
  //   ChatScreen(),
  //   CreatBudgetPage(accessToken: widget.accessToken),
  // ];

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfileData(widget.accessToken);
     // Initialize the pages list after accessing the widget.accessToken
    pages = [
      DailyPage(accessToken: widget.accessToken),
      StatsPage(accessToken: widget.accessToken),
      BudgetPage(),
      ChatScreen(),
      CreatBudgetPage(accessToken: widget.accessToken),
    ];
  }

  @override
  void dispose() {
    super.dispose();

  }
 Future<bool> validateToken(String accessToken) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/user/validate/');
  final headers = {'Authorization': 'Bearer $accessToken'};

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final bool isValid = responseData['valid'];
    // print("token validate-----" + responseData);
    return isValid;
  } else {
    throw Exception('Failed to validate token');
  }
}

//   Future<UserProfile> _fetchProfileData(String accessToken) async {
//   final url = Uri.parse('http://127.0.0.1:8000/api/user/profile/');
//   final headers = {'Authorization': 'Bearer $accessToken'};

//   var response = await http.get(url, headers: headers);
//   if (response.statusCode == 200) {
//     final responseData = jsonDecode(response.body);
//     _responseData = responseData;
//     print("user data :=------=-"+_responseData);
//     return UserProfile.fromJson(responseData);
//   } else {
//     throw Exception('Failed to fetch profile data');
//   }
// }
 Future<UserProfile> _fetchProfileData(String accessToken) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/user/profile/');
  final headers = {'Authorization': 'Bearer $accessToken'};

  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    // print(responseData); // Debug print the response data

    if (responseData is Map<String, dynamic>) {
      // Check if the response data is of the expected type
      final userProfile = UserProfile.fromJson(responseData);
      // print(userProfile); // Debug print the parsed user profile object
      return userProfile;
    } else {
      throw Exception('Invalid response data format');
    }
  } else {
    throw Exception('Failed to fetch profile data. Status code: ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      // backgroundColor:black,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   // title: Text('Your App Title'),
      // ),
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
                Navigator.pushNamed(
                context,
                AppRouteName.profile,
                arguments: {
                  'accessToken': widget.accessToken,
                  'responseData': responseData,

                },
              );
          } 
            ),

            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Detailed View"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouteName.details,
                 arguments: {
                  'accessToken': widget.accessToken,

                },
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                 Navigator.pushNamed(context, AppRouteName.settings,
                 arguments: {
                  'accessToken': widget.accessToken,

                },);
              },
            ),
            ListTile(
              leading: const Icon(Icons.diamond_rounded),
              title: const Text('Go Premium'),
              onTap: () {
                Navigator.pop(context);
                 Navigator.pushNamed(context, AppRouteName.premium);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body:GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            // Swipe from left to right (open drawer)
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: getBody(),
      ),
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
    // print(widget.accessToken);
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
