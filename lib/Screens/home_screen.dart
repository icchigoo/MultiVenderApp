// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie_app/Screens/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // ignore: deprecated_member_use
        child: RaisedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ));
            });
          },
          child: Text('signUp'),
        ),
      ),
    );
  }
}
