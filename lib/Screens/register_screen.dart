import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinner/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinner/Screens/login_screen.dart';
import 'package:flutter_spinner/constants.dart';
import 'package:flutter_spinner/firebase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final otpController = TextEditingController();

  var verificationId;
  bool showLoading = false;
  String UID = "";

  //firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(_auth.currentUser.uid)
        .set({
          'Phone Number': phoneController.text.trim(), // John Doe
          'Balance': 1000, // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void signInWithPhoneAuthCredential(phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential?.user != null) {
        //firebase code
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (!documentSnapshot.exists) {
            print('This user does not exist');
            addUser();
          }
        });

        String email = phoneController.text.toString().trim() + '@spinner.com';

        AuthCredential userCredentials = EmailAuthProvider.credential(
            email: email,
            password: passwordConfirmController.text.toString().trim());
        await _auth.currentUser.linkWithCredential(userCredentials);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      // TODO
      setState(() {
        showLoading = false;
      });
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  getMobileFormWidget(context) {
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
                    height: 630,
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
                                  width: 65,
                                  height: 1,
                                ),
                                Text(
                                  "REGISTER",
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    textStyle: TextStyle(
                                      letterSpacing: 1,
                                      color: Color(0xff91D8B6),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Color(0xff91D8B6),
                                  width: 65,
                                  height: 1,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextField(
                              controller: phoneController,
                              textAlignVertical: TextAlignVertical.bottom,
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
                                  focusColor: Colors.white,
                                  hintText: "Phone Number",
                                  hintStyle:
                                      TextStyle(color: Color(0xff626E89)),
                                  labelText: 'Enter Mobile',
                                  labelStyle: TextStyle(
                                      color: Color(0xff626E89),
                                      fontSize: 18,
                                      height: 4),
                                  filled: true,
                                  alignLabelWithHint: true,
                                  fillColor: Color(0xffd3f0e2)),
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
                                  labelText: 'Enter Password',
                                  labelStyle: TextStyle(
                                      color: Color(0xff626E89),
                                      fontSize: 18,
                                      height: 4),
                                  filled: true,
                                  alignLabelWithHint: true,
                                  fillColor: Color(0xffd3f0e2)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              obscureText: true,
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: passwordConfirmController,
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
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                      color: Color(0xff626E89),
                                      fontSize: 18,
                                      height: 4),
                                  filled: true,
                                  alignLabelWithHint: true,
                                  fillColor: Color(0xffd3f0e2)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: ElevatedButton(
                              onPressed: () async {

                                  if (passwordController.text
                                          .toString()
                                          .isEmpty ||
                                      passwordConfirmController.text
                                          .toString()
                                          .isEmpty ||
                                      phoneController.text.toString().isEmpty) {
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please Input All Fields')));
                                  } else {
                                    if (passwordController.text.length >= 6 &&
                                        passwordConfirmController.text.length >=
                                            6) {
                                      if (passwordController.text.toString() ==
                                          passwordConfirmController.text
                                              .toString()) {
                                        await _auth.verifyPhoneNumber(
                                            phoneNumber: phoneController.text,
                                            verificationCompleted:
                                                (phoneAuthCredential) async {
                                              setState(() {
                                                showLoading = false;
                                              });
                                              // signInWithPhoneAuthCredential(phoneAuthCredential);
                                            },
                                            verificationFailed:
                                                (verificationFailed) async {
                                              setState(() {
                                                showLoading = false;
                                              });
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    verificationFailed.message),
                                              ));
                                            },
                                            codeSent: (verificationId,
                                                resendingToken) async {
                                              setState(() {
                                                showLoading = false;
                                                currentState =
                                                    MobileVerificationState
                                                        .SHOW_OTP_FORM_STATE;
                                                this.verificationId =
                                                    verificationId;
                                              });
                                            },
                                            codeAutoRetrievalTimeout:
                                                (verificationId) async {});
                                      } else {
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Passwords Are Not The Same'),
                                        ));
                                      }
                                    } else {
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Password Must Be At Least 6 Characters')));
                                    }
                                  }

                                  showLoading = true;

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
                                    'REGISTER',
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .popUntil(ModalRoute.withName('/'));
                            },
                            child: new Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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

  getOtpFormWidget(context) {
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
                  padding: EdgeInsets.fromLTRB(20, 70, 20, 200),
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                color: Color(0xff91D8B6),
                                width: 50,
                                height: 1,
                              ),
                              Text(
                                "OTP CODE",
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  textStyle: TextStyle(
                                    letterSpacing: 1,
                                    color: Color(0xff91D8B6),
                                  ),
                                ),
                              ),
                              Container(
                                color: Color(0xff91D8B6),
                                width: 50,
                                height: 1,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.bottom,
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
                                focusColor: Colors.white,
                                hintText: "OTP CODE",
                                hintStyle: TextStyle(color: Color(0xff626E89)),
                                labelText: 'Enter OTP',
                                labelStyle: TextStyle(
                                    color: Color(0xff626E89),
                                    fontSize: 20,
                                    height: 3),
                                filled: true,
                                alignLabelWithHint: true,
                                fillColor: Color(0xffd3f0e2)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              AuthCredential phoneAuthCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: otpController.text);
                              signInWithPhoneAuthCredential(
                                  phoneAuthCredential);
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
                                  'SUBMIT',
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: showLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
    );
  }
}
