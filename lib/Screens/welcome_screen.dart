// ignore_for_file: prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, use_key_in_widget_constructors, must_be_immutable, unused_field, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:foodie_app/Screens/map_screen.dart';
import 'package:foodie_app/Screens/onboard_screen.dart';
import 'package:foodie_app/providers/auth_provider.dart';
import 'package:foodie_app/providers/location_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();
    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOGIN',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          myState(() {
                            _validPhoneNumber = true;
                          });
                        } else {
                          myState(() {
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
                            child: FlatButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number =
                                    '+977${_phoneNumberController.text}';
                                auth
                                    .verifyPhone(
                                  context: context,
                                  number: number,
                                  latitude: locationData.latitiude,
                                  longitude: locationData.longitude,
                                  address: locationData.selectedAddress,
                                )
                                    .then((value) {
                                  _phoneNumberController.clear();
                                  auth.loading = false;
                                });
                              },
                              color: _validPhoneNumber
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              child: auth.loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
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
          },
        ),
      );
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.8,
              top: 10.0,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  'SKIP',
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: OnBoardScreen(),
                ),
                Text(
                  'Ready to order food from canteen ?',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  color: Colors.deepOrangeAccent,
                  child: locationData.loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('SET DELIVERY LOCATION',
                          style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      locationData.loading = true;
                    });

                    await locationData.getCurrentPosition();
                    if (locationData.permissionAllowed == true) {
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading = false;
                      });
                    } else {
                      print('permisiion not allowed');
                      setState(() {
                        locationData.loading = true;
                      });
                    }
                  },
                ),
                FlatButton(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already a customer ?',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent))
                      ],
                    ),
                  ),
                  onPressed: () {
                    showBottomSheet(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
