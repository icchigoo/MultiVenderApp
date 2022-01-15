// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_final_fields, unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:foodie_app/providers/auth_provider.dart';
import 'package:foodie_app/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Enter your phone number to proceed',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              decoration: InputDecoration(
                prefixText: '+977',
                labelText: ' 10 digit mobile number',
              ),
              autofocus: true,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              controller: _phoneNumberController,
              onChanged: (value) {
                if (value.length == 10) {
                  setState(() {
                    _validPhoneNumber = true;
                  });
                } else {
                  setState(() {
                    _validPhoneNumber = false;
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    absorbing: _validPhoneNumber ? false : true,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          auth.loading = true;
                        });
                        String number = '+977${_phoneNumberController.text}';
                        auth.verifyPhone(context, number).then((value) {
                          _phoneNumberController.clear();
                          auth.loading = false;
                        });
                      },
                      color: _validPhoneNumber
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      child: auth.loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              _validPhoneNumber
                                  ? 'CONTINUE'
                                  : 'ENTER PHONE NUMBER',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
