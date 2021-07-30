import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinner/bet_button.dart';
import 'package:flutter_spinner/bet_popup.dart';
import 'package:flutter_spinner/constants.dart';
import 'package:flutter_spinner/decorated_title.dart';
import 'package:flutter_spinner/hero_dialog_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_rect_tween.dart';
import 'num_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String selectedNumber = 'SELECT BET';
String selectedBet = 'PLACE BET';
Color buttonDefault = kLightGreen;
final textController = TextEditingController();

class PopUp extends StatefulWidget {
  const PopUp({Key key}) : super(key: key);
  static const String _heroAddTodo = 'add-todo-hero';
  static const String _heroBet = 'bet-hero';
  @override
  PopUpState createState() => PopUpState();
}

class PopUpState extends State<PopUp> {
  Widget popUpWidget = NumberSelectScreen();
  bool betReady = false;
  String buttonText = 'SELECT BET';
  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedNumber', int.parse(selectedNumber.toString()));
    prefs.setInt('selectedBet', int.parse(selectedBet.toString()));
    selectedNumber = 'SELECT BET';
    selectedBet = 'PLACE BET';
  }

  Future<int> getIntBalanceSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt('userBalance');
    return intValue;
  }

  Future<int> getIntTimeRemainingSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt('timeRemaining');
    return intValue;
  }

  CollectionReference spinner =
      FirebaseFirestore.instance.collection('spinner');
  Future<void> placeBetNumber(String number) {
    return spinner
        .doc('config')
        .update({
          number: FieldValue.increment(1),
        })
        .then((value) => print("Bet Number Updated"))
        .catchError((error) => print("Failed to update time: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: PopUp._heroAddTodo,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Material(
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 470,
                width: 320,
                child: Column(
                  children: [
                    popUpWidget,
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kYellowColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          print("selectedBet: " + selectedBet);
                          print("selectedNum: " + selectedNumber);
                          var timeRemaining = await getIntTimeRemainingSF();
                          print("TimeR " + timeRemaining.toString());
                          if (timeRemaining >= 30) {
                            if (selectedNumber != 'SELECT BET') {
                              setState(() {
                                popUpWidget = BetSelectScreen();
                                buttonText = 'PLACE BET';
                                //   print(int.parse(selectedNumber.toString()));
                                betReady = true;
                                //  selectedNumber = 'SELECT BET';
                              });
                            }
                            if (selectedBet != 'PLACE BET') {
                              if (betReady == true) {
                                var userBalance = await getIntBalanceSF();
                                if (userBalance >= int.parse(selectedBet)) {
                                  addIntToSF();
                                  placeBetNumber(selectedNumber);
                                  // selectedBet = 'PLACE BET';
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "Successfully Placed Bet",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.grey[900],
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.of(context)
                                        .pop(BetSelectScreen());
                                  });
                                } else {
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "Insufficient Balance",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.grey[900],
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                }
                              } else {}
                            }
                            // selectedNumber = 'SELECT BETdß';
                            // selectedBet = 'PLACE BET';
                          } else {
                            setState(() {
                              selectedNumber = 'SELECT BET';
                              selectedBet = 'PLACE BET';
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                  msg:
                                      "You Must Bet Within 30 Seconds of the Round. Try Again Next Round.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.grey[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            });
                          }
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          child: Center(
                            child: Text(
                              '$buttonText',
                              style: GoogleFonts.sourceSansPro(
                                  color: Colors.white,
                                  fontSize: 27,
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
        ),
      ),
    );
  }
}

class BetSelectScreen extends StatefulWidget {
  const BetSelectScreen({
    Key key,
  }) : super(key: key);

  @override
  _BetSelectScreenState createState() => _BetSelectScreenState();
}

class _BetSelectScreenState extends State<BetSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: kYellowColor,
                    width: 70,
                    height: 1,
                  ),
                  Container(
                    width: 140,
                    child: Center(
                      child: Text(
                        "$selectedBet",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          textStyle: TextStyle(
                            letterSpacing: 1,
                            color: kYellowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: kYellowColor,
                    width: 70,
                    height: 1,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kYellowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedBet = 1.toString();
                        });
                      },
                      child: Container(
                        width: 45,
                        child: Center(
                          child: Text(
                            '1',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kYellowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedBet = 2.toString();
                        });
                      },
                      child: Container(
                        width: 45,
                        child: Center(
                          child: Text(
                            '2',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kYellowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedBet = 5.toString();
                        });
                      },
                      child: Container(
                        width: 45,
                        child: Center(
                          child: Text(
                            '5',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kYellowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedBet = 10.toString();
                        });
                      },
                      child: Container(
                        width: 45,
                        child: Center(
                          child: Text(
                            '10',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kYellowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedBet = 100.toString();
                        });
                      },
                      child: Container(
                        width: 45,
                        child: Center(
                          child: Text(
                            '100',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 180,
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    selectedBet = text.toString().trim();
                  });
                },
                style: GoogleFonts.sourceSansPro(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                cursorWidth: 0,
                maxLength: 6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hoverColor: Colors.white,
                    focusColor: Colors.white,
                    hintText: 'ENTER BET',
                    hintStyle: GoogleFonts.sourceSansPro(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    labelStyle:
                        TextStyle(color: Colors.white, fontSize: 18, height: 2),
                    filled: true,
                    alignLabelWithHint: true,
                    fillColor: kYellowColor),
              ),
            ),
            SizedBox(
              height: 103,
            )
          ],
        ),
      ),
    );
  }
}

class NumberSelectScreen extends StatefulWidget {
  const NumberSelectScreen({
    Key key,
  }) : super(key: key);

  @override
  NumberSelectScreenState createState() => NumberSelectScreenState();
}

class NumberSelectScreenState extends State<NumberSelectScreen> {
  int count = 0;

  void update(int count) {
    setState(() {
      count = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      color: kTitleGreen,
                      width: 65,
                      height: 1,
                    ),
                    Container(
                      width: 125,
                      child: Center(
                        child: Text(
                          "$selectedNumber",
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            textStyle: TextStyle(
                              letterSpacing: 1,
                              color: kTitleGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: kTitleGreen,
                      width: 65,
                      height: 1,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 1.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '1',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 2.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '2',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 3.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '3',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 4.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '4',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 5.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '5',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 6.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '6',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          setState(() {
                            selectedNumber = 7.toString();
                          });
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '7',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 8.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '8',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        primary: buttonDefault,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 9.toString();
                        });
                      },
                      child: Container(
                        width: 50,
                        child: Center(
                          child: Text(
                            '9',
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30),
                    ),
                    primary: buttonDefault,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedNumber = 0.toString();
                    });
                  },
                  child: Container(
                    width: 50,
                    child: Center(
                      child: Text(
                        '0',
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}

class NumButton extends StatefulWidget {
  final ValueChanged<int> update;
  final String num;
  Color color;

  NumButton(this.num, this.color, this.update);

  @override
  _NumButtonState createState() => _NumButtonState();
}

class _NumButtonState extends State<NumButton> {
  @override
  bool isPressed = false;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30),
          ),
          primary: buttonDefault,
        ),
        onPressed: () {},
        child: Container(
          width: 50,
          child: Center(
            child: Text(
              '1',
              style: GoogleFonts.sourceSansPro(
                  color: isPressed ? kLightGreen : Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
