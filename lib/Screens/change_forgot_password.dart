import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinner/Screens/home_screen.dart';
import 'package:flutter_spinner/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChnageForgotPassword extends StatefulWidget {
  const ChnageForgotPassword({Key key}) : super(key: key);

  @override
  _ChnageForgotPasswordState createState() => _ChnageForgotPasswordState();
}

class _ChnageForgotPasswordState extends State<ChnageForgotPassword> {
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            Color(0xff00955C),
            Color(0xff8FF5CE),
          ],
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  color: Color(0xff91D8B6),
                                  width: 40,
                                  height: 1,
                                ),
                                Text(
                                  "Change Password",
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    textStyle: TextStyle(
                                      letterSpacing: 1,
                                      color: Color(0xffd3f0e2),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Color(0xff91D8B6),
                                  width: 40,
                                  height: 1,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              obscureText: true,
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 35, 20, 30),
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hoverColor: Colors.white,
                                  focusColor: Colors.green[100],
                                  hintText: "Password",
                                  hintStyle:
                                      TextStyle(color: Color(0xff626E89)),
                                  labelText: 'Enter New Password',
                                  labelStyle: TextStyle(
                                      color: Color(0xff626E89),
                                      fontSize: 20,
                                      height: 3),
                                  filled: true,
                                  fillColor: Color(0xffd3f0e2)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                print('bruh');
                                if (passwordController.text
                                        .toString()
                                        .isEmpty ==
                                    false) {
                                  //Pass in the password to updatePassword.
                                  await FirebaseAuth.instance.currentUser
                                      .updatePassword(passwordController.text
                                          .toString()
                                          .trim())
                                      .then((_) {
                                    print("Your password changed Succesfully ");
                                    setState(() {
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Successfully Changed Password')));

                                      Future.delayed(
                                          const Duration(milliseconds: 2000),
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreenRoute()),
                                        );
                                      });
                                    });
                                  }).catchError((err) {
                                    print("You can't change the Password" +
                                        err.toString());

                                    setState(() {
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Password Change Failed. Please Try Again')));

                                      Future.delayed(
                                          const Duration(milliseconds: 2000),
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()),
                                        );
                                      });
                                    });

                                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30),
                                  ),
                                  primary: Color(0xffd3f0e2)),
                              child: Container(
                                height: 50,
                                width: 200,
                                child: Center(
                                  child: Text(
                                    'CHANGE PASSWORD',
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
