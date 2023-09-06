import 'package:apitest/signup_page.dart';
import 'package:apitest/splash_screen.dart';
import 'package:apitest/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'example.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:apitest/login_page.dart';
import 'package:apitest/survey_form.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // themeMode: ThemeMode.light,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white),
      // darkTheme: ThemeData(
      //   brightness: Brightness.light,
      // ),
      home: const SplashScreen(),
    );
  }
}
