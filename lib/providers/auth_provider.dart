// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, empty_catches, unused_field, prefer_final_fields, avoid_print, unused_local_variable, await_only_futures, prefer_function_declarations_over_variables, unnecessary_this, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_null_comparison, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:foodie_app/Screens/home_screen.dart';
import 'package:foodie_app/Services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = '';
  UserServices _userServicer = UserServices();
  bool loading = false;

  Future<void> verifyPhone(
      {BuildContext? context,
      String? number,
      double? latitude,
      double? longitude,
      String? address}) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      this.verificationId = verId;
      smsOtpDialog(context!, number!);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number!,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future? smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter ^ digit OTP received as SMS',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsOtp);
                    final User? user =
                        (await _auth.signInWithCredential(credential)).user;

                    _createUser(id: user!.uid, number: user.phoneNumber!);

                    if (user != null) {
                      Navigator.of(context).pop();

                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    } else {
                      print(' login Faild');
                    }
                  } catch (e) {
                    this.error = 'Invalid OTP';
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        });
  }

  void _createUser(
      {required String id,
      required String number,
      double? latitude,
      double? longitude,
      String? address}) {
    _userServicer.crateUserData({
      'id': id,
      'number': number,
      'Location': GeoPoint(latitude!, longitude!)
      'address': address!,
    });
  }

  void updateUser(
      {required String id,
      required String number,
      double? latitude,
      double? longitude,
      String? address}) {
    _userServicer.crateUserData({
      'id': id,
      'number': number,
      'location': GeoPoint(latitude!, longitude!).toString(),
      'address': address!,
    });
  }
}
