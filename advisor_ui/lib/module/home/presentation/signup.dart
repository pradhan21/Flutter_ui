import 'package:advisor_ui/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:advisor_ui/core/component/dialog/loading_dialog.dart';
import 'package:advisor_ui/core/theme/app_color.dart';
import 'package:rive/rive.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';


class Signup extends StatefulWidget {

   
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String validEmail = "Dandi@gmail.com";
  String validPassword = "12345";
  bool _isSigningUp =false;// track whether to login or signin.
   final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ]
   );

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  FocusNode ContactFocusNode = FocusNode();
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
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
      });
     });
     _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }


  //  setState(() {
  //     _isSigningUp = false;
  //   });
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
                  ),const SizedBox(height: 8),
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
                      focusNode: ContactFocusNode,
                      controller: contactController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Contact",
                      ),
                      obscureText: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();

                        final email = emailController.text;
                        final password = passwordController.text;

                        showLoadingDialog(context);
                        await Future.delayed(
                          const Duration(milliseconds: 2000),
                        );
                        if (mounted) Navigator.pop(context);

                        if (email == validEmail && password == validPassword) {
                          trigSuccess?.change(true);
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RootApp()),
                            );
    
                        } else {
                          trigFail?.change(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(_isSigningUp ? 'Signup' : 'Login'),
                    ),
                  ),
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
                  ),
                  // const SizedBox(height: 32),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 64,
                  //   child: TextButton(
                  //          onPressed: signInWithGoogle,
                  //         child: Text('Sign in with Google'),
                  //       ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
