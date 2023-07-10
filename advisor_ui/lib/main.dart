import 'package:flutter/material.dart';
import 'package:advisor_ui/main_module.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/route/app_route.dart';
import 'core/route/app_route_name.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String stripePublishableKey="pk_test_51NNPZVGvjAuWKVBt4nen9FtK5T1s1ZaqxJ2OsvMgUGXa1mPRq3bTkEOOtKJIgB3cSyo24Rt7vHQf9OAYahskBM3s00xktbReww";
  MainModule.init();
  Stripe.publishableKey = stripePublishableKey;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  State<MyApp> createState()=> _Myappstate();
}
  class _Myappstate extends State<MyApp>{
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: "Budget App",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialRoute: AppRouteName.home,
      onGenerateRoute: AppRoute.generate,
    );
  }
}
