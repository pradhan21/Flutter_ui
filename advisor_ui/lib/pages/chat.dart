import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import '../theme/colors.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: black,
                height: 150,
                child: Padding(
                  padding: EdgeInsets.only(top: 55, left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tech Support",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 500, // Set a fixed height for the Tawk widget
                child: Tawk(
                  directChatLink:
                      'https://tawk.to/chat/64ace0dacc26a871b027a065/1h51kslp4',
                  visitor: TawkVisitor(
                    name: 'Jimmy',
                    email: 'jimmy@gmail.com',
                  ),
                  onLoad: () {
                    print('Hello World!');
                  },
                  onLinkTap: (String url) {
                    print(url);
                  },
                  placeholder: const Center(
                    child: Text('Loading...'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
