import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_mobile_page/Screen/otpscreen.dart';

class HomePgae extends StatefulWidget {
  const HomePgae({super.key});
  static String verify = "";
  @override
  State<HomePgae> createState() => _HomePgaeState();
}

class _HomePgaeState extends State<HomePgae> {
  TextEditingController _codecontroller = TextEditingController();
  var phone = "";
  @override
  void initState() {
    _codecontroller.text = "+91";
    super.initState();
  }

  bool? _validatePhone(value) {
    if (value!.isEmpty || value.length != 10) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
             
              children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('Images/playing-music.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              Text(
                'Login Page',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _codecontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                      onChanged: (value) {
                        phone = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      _validatePhone(phone) == true
                          ? SnackBar(
                              content:
                                  Text("Please enter a correct phone number"),
                            )
                          : optsend();
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void optsend() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${_codecontroller.text + phone}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        HomePgae.verify = verificationId;
        Navigator.push(context, MaterialPageRoute(builder: (_) => OtpPage()));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
