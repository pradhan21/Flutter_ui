import 'package:advisor_ui/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:advisor_ui/core/component/dialog/loading_dialog.dart';
import 'package:advisor_ui/core/theme/app_color.dart';
import 'package:rive/rive.dart';
import 'package:google_sign_in/google_sign_in.dart';



class HomeScreen extends StatefulWidget {

   HomeScreen({Key? key}): super(key: key); 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSigningUp =false;// track whether to login or signin.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ]
  );
  final List<User> _users = [];

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  FocusNode contactFocusNode = FocusNode();
  TextEditingController contactController = TextEditingController();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    contactFocusNode.addListener(contactFocus);
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    contactFocusNode.removeListener(contactFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void contactFocus() {
    isChecking?.change(contactFocusNode.hasFocus);
  }


 

  Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User canceled the sign-in process
      return;
    }
  
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  
    // Use the GoogleAuth credentials to authenticate with your backend server
    // and perform any necessary operations.
    String accessToken = googleAuth.accessToken!;
    String idToken = googleAuth.idToken!;

  
    // TODO: Implement your logic here for successful sign-in.
  
  } catch (error) {
    // Handle sign-in errors
    print('Sign-In Error: $error');
  }
}

  void Signup() { 
    final String username = emailController.text;
    final String password = passwordController.text;
    int contact = int.tryParse(contactController.text) ?? 0;

    // Create a new user and add it to the list
    final User newUser = User(username: username, password: password, contact: contact);
    _users.add(newUser);

    // Clear the text fields

    setState(() {
      _isSigningUp = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Signup successful!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
 Future<void> login() async {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();

   final String username = emailController.text;
    final String password = passwordController.text;

    showLoadingDialog(context);
    await Future.delayed(
      const Duration(milliseconds: 2000),
    );
    if (mounted) Navigator.pop(context);
  

    // Find the user in the list based on the username
    User? user;
    try {
      user = _users.firstWhere((user) => user.username == username);
      if (username == user.username && password == user.password) {
      trigSuccess?.change(true);
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RootApp()),
        );

    } else {
      trigFail?.change(true);
    }
    } catch (e) {
      user = null;
    }
    
  }

//     Future<void> login() async {
//   emailFocusNode.unfocus();
//   passwordFocusNode.unfocus();

//   final String username = emailController.text ;
//   final String password = passwordController.text;

//   showLoadingDialog(context);
//   await Future.delayed(
//     const Duration(milliseconds: 2000),
//   );
//   if (mounted) Navigator.pop(context);

//   try {
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:8000/api/user/login/'),
//      body: <String, String> {
//         'email': username,
//         'password': password,
//       },
//     );
//     print(username);
//     print(password);

//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       final token = responseData['token'];
//       final refreshToken = token['refresh'];
//       print(refreshToken);
//                           if (refreshToken != null) {
//                           navigateToRootApp(refreshToken);
//                         } else {
//                           // Handle the case when refreshToken is null
//                           // For example, show an error message or navigate to a different page
//                           print('Refresh token is null');
//                         }
//       navigateToRootApp(refreshToken!);
//     } else if (response.statusCode == 404) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Email or password is not valid'),
//             actions: <Widget>[
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       trigFail?.change(true);
//       // Handle other status codes or errors
//     }
//   } catch (error) {
//     // Handle network or connection errors
//     print('Error: $error');
//   }
// }

void navigateToRootApp(String refreshToken) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootApp()),
    );
  });
}



  @override
  Widget build(BuildContext context) {
    print("Build Called Again");
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              height: 64,
              width: 64,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Image(
                image: AssetImage("assets/rive_logo.png"),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Budget Manager",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "assets/login-teddy.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                    artboard,

                    /// from rive, you can see it in rive editor
                    "Login Machine",
                  );
                  if (controller == null) return;

                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: emailFocusNode,
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        numLook?.change(value.length.toDouble());
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: passwordFocusNode,
                      controller: passwordController, 
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: _isSigningUp  ,
                    child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      focusNode: contactFocusNode,
                      controller: contactController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Contact",
                      ),
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {},
                    ),
                  ),)
                  ,
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: ElevatedButton(
                      onPressed:_isSigningUp ? Signup : login ,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                       child: Text(_isSigningUp ? 'Signup' : 'Login'),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerRight,
                     child: SizedBox(
                    width: 200,
                    height: 64,
                    child: TextButton(
                          onPressed: () {
                          },
                          
                            child:Text("Recover Password"),
                        ),
                  ),),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isSigningUp = !_isSigningUp;
                            });
                          },
                          child: Text(_isSigningUp
                              ? 'Already have an account? HomeScreen'
                              : 'Don\'t have an account? Signup'),
                        ),
                  ), const SizedBox(height: 32),
                  Visibility(
                    visible: _isSigningUp  ,
                    child:SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: TextButton(
                           onPressed: signInWithGoogle,
                          child: Text('Sign in with Google'),
                        ),
                  ))
                  ,

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
 class User {
  final String username;
  final String password;
  final int contact;
  User({required this.username, required this.password, required this.contact});
  }
