import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_dribble_challenge/screens/onboarding/onboarding_page.dart';


void main() => run();
 
Future run() async {
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: OnBoardingPage(),
    );
  }
}
