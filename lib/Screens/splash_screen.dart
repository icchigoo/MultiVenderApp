// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie_app/Screens/home_screen.dart';
import 'package:foodie_app/Screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = ' splash-screen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(tag: 'logo', child: Image.asset('images/logo2.png')),
      ),
    );
  }
}
