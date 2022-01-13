// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(tag: 'logo', child: Image.asset('images/logo2.png')),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
          ],
        ),
      ),
    );
  }
}
