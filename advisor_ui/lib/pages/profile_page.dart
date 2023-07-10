import 'dart:convert';

import 'package:advisor_ui/pages/root_app.dart';
import 'package:advisor_ui/pages/setting_page.dart';
import 'package:advisor_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:advisor_ui/api_data/userProfile.dart';

class ProfilePage extends StatefulWidget {
  final String accessToken;
  final dynamic responseData;
  ProfilePage({required this.accessToken, required this.responseData});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late var Token;
  late Future<UserProfile> _profileFuture;
  TextEditingController _email = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController password = TextEditingController();
  Map<String, dynamic>? userData;
  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Function to fetch user profile data from the API
// Future<Map<String, dynamic>> fetchUserProfile() async {
//   // Make the API request
//   final response = await http.get(
//     Uri.parse('http://127.0.0.1:8000/api/user/profile/'),
//     headers:  {'Authorization': 'Bearer ${widget.accessToken}'},
//   );
//   print('Authorization header: Bearer $Token');
//   if (response.statusCode == 200) {
//     // Parse the response body
//     final data = jsonDecode(response.body);
//     setState(() {
//       userData = data;
//       print(userData);
//       _email.text = data['email'];
//       dateOfBirth.text = data['dateOfBirth'];
//       password.text = data['password'];
//     });
//     return data;
//   } else {
//     // Throw an error if API request failed
//     throw Exception('Failed to fetch user profile data');
//   }
// }
  void _fetchProfileData() {
    final url = Uri.parse('http://10.0.2.2:8000/api/user/profile/');
    final headers = {'Authorization': 'Bearer ${widget.accessToken}'};

    _profileFuture = http.get(url, headers: headers).then((response) {
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // print(responseData);
        return UserProfile.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch profile data');
      }
    }).catchError((error) {
      throw Exception('An error occurred: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey.withOpacity(0.05),
        body: FutureBuilder<UserProfile>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final userProfile = snapshot.data!;
                var size = MediaQuery.of(context).size;
                return SingleChildScrollView(
                    child: Container(
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // decoration: BoxDecoration(color: white, boxShadow: [
                        //   BoxShadow(
                        //     color: grey.withOpacity(0.01),
                        //     spreadRadius: 10,
                        //     blurRadius: 3,
                        //     // changes position of shadow
                        //   ),
                        // ]),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.blue,
                            Colors.red,
                          ],
                        )),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, right: 20, left: 20, bottom: 25),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: black),
                                  ),
                                  IconButton(
                                    icon: const Icon(AntDesign.arrowleft),
                                    // onPressed: (){},
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RootApp(
                                              accessToken: widget.accessToken),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: (size.width - 40) * 0.4,
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          RotatedBox(
                                            quarterTurns: -2,
                                            child: CircularPercentIndicator(
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                                backgroundColor:
                                                    grey.withOpacity(0.3),
                                                radius: 85.0,
                                                lineWidth: 6.0,
                                                percent: 0.53,
                                                progressColor: primary),
                                          ),
                                          Positioned(
                                            top: 35,
                                            left: 5,
                                            bottom: 26,
                                            child: Container(
                                              width: 130,
                                              height: 130,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://images.unsplash.com/photo-1531256456869-ce942a665e80?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTI4fHxwcm9maWxlfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"),
                                                      fit: BoxFit.cover)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    // width: (size.width - 40) * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${userProfile.fName} ${userProfile.lName} ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 28),
                                              Icon(Icons.email_outlined),
                                              SizedBox(width: 8),
                                              Text(
                                                "${userProfile.email}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        black.withOpacity(0.7)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 108),
                                              Icon(Icons.phone),
                                              SizedBox(width: 8),
                                              Text(
                                                "${userProfile.phone}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        black.withOpacity(0.7)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // Container(
                              //   width: double.infinity,
                              //   decoration: BoxDecoration(
                              //       color: black,
                              //       borderRadius: BorderRadius.circular(12),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: primary.withOpacity(0.01),
                              //           spreadRadius: 10,
                              //           blurRadius: 3,
                              //           // changes position of shadow
                              //         ),
                              //       ]),
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         left: 20, right: 20, top: 25, bottom: 25),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Column(
                              //           crossAxisAlignment: CrossAxisAlignment.start,
                              //           children: [
                              //             Text(
                              //               "United Bank Asia",
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 12,
                              //                   color: white),
                              //             ),
                              //             SizedBox(
                              //               height: 10,
                              //             ),
                              //             Text(
                              //               "\$2446.90",
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight.bold,
                              //                   fontSize: 20,
                              //                   color: white),
                              //             ),
                              //           ],
                              //         ),
                              //         Container(
                              //           decoration: BoxDecoration(
                              //               borderRadius: BorderRadius.circular(10),
                              //               border: Border.all(color: white)),
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(13.0),
                              //             child: Text(
                              //               "Update",
                              //               style: TextStyle(color: white),
                              //             ),
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d)),
                            ),
                            TextField(
                              controller: _email,
                              cursorColor: black,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                              decoration: InputDecoration(
                                  hintText: "${userProfile.email}",
                                  border: InputBorder.none),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Date of birth",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d)),
                            ),
                            TextField(
                              controller: dateOfBirth,
                              cursorColor: black,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                              decoration: InputDecoration(
                                  hintText: "${userProfile.dateOfBirth}",
                                  border: InputBorder.none),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Date of birth",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d)),
                            ),
                            TextField(
                              obscureText: true,
                              controller: password,
                              cursorColor: black,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
              }
            }));
  }
}
