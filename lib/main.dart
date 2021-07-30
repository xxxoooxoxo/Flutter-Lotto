// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinner/Screens/home_screen.dart';
import 'package:flutter_spinner/Screens/login_screen.dart';
import 'package:flutter_spinner/Screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class HomeScreenRoute extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class Roulette extends StatelessWidget {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: -30,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
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
                  height: 700,
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
                                width: 90,
                                height: 1,
                              ),
                              Text(
                                "Register",
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
                                width: 90,
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
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: null,
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
                                hintStyle: TextStyle(color: Color(0xff626E89)),
                                labelText: 'Enter Mobile',
                                labelStyle: TextStyle(
                                    color: Color(0xff626E89),
                                    fontSize: 20,
                                    height: 3),
                                filled: true,
                                fillColor: Color(0xffd3f0e2)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: null,
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
                                hintStyle: TextStyle(color: Color(0xff626E89)),
                                labelText: 'Enter Password',
                                labelStyle: TextStyle(
                                    color: Color(0xff626E89),
                                    fontSize: 20,
                                    height: 3),
                                filled: true,
                                fillColor: Color(0xffd3f0e2)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: null,
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
                                hintStyle: TextStyle(color: Color(0xff626E89)),
                                labelText: 'Confirm Password',
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
                            onPressed: () {},
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
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "myRoute");
                              },
                              child: new Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "myRoute");
                              },
                              child: new Text(
                                'Forgot Password?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )),
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
    );
  }
}
//const kLightGreen = Color(0xff91D8B6);
//
// const kTextFieldAccent = Color(0xff626E89);
