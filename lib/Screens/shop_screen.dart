import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinner/Screens/home_screen.dart';
import 'package:flutter_spinner/constants.dart';
import 'package:flutter_spinner/decorated_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Razorpay razorpay = new Razorpay();
  FirebaseAuth _auth = FirebaseAuth.instance;
  int buyAmount;

  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(int amount) {
    var options = {
      "key": "rzp_test_SsLJFJLoWdZEuE",
      "amount": amount,
      "Name": "Add Coins to Wallet",
      "description": "Payment For Coins",
      "prefil": {
        "contact": "",
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addBalance() {
    return users
        .doc(_auth.currentUser.uid)
        .update({
          'Balance': FieldValue.increment(buyAmount),
        })
        .then((value) => print("Balance Updated"))
        .catchError((error) => print("Failed to update time: $error"));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('payment success');
    addBalance();
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("Successfully Added Points")));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('payment success');
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Adding Points Failed. Please Try Again")));
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print('payment success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 480,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 10),
                      child: DecoratedTitle("SHOP", kTitleGreen),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            openCheckout(100000);
                            buyAmount = 1000;
                          },
                          child: Container(
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: kYellowColor),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'BUY 1000 POINTS',
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.5),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            openCheckout(500000);
                            buyAmount = 5000;
                          },
                          child: Container(
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: kYellowColor),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'BUY 5000 POINTS',
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            openCheckout(1000000);
                            buyAmount = 10000;
                          },
                          child: Container(
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: kYellowColor),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'BUY 10000 POINTS',
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.5),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.red),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'EXIT SHOP',
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
