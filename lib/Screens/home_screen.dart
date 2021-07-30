import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinner/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'package:flutter/rendering.dart';
import 'package:flutter_spinner/add_todo_button.dart';
import 'package:flutter_spinner/popup.dart';
import 'dart:async';
import 'dart:math';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:flutter_spinner/constants.dart';
import 'package:flutter_spinner/hero_dialog_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../custom_rect_tween.dart';
import '../decorated_title.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'shop_screen.dart';

const String _heroAddTodo = 'add-todo-hero';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
var userBalance;
const int maxFailedLoadAttempts = 3;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  var data;
  var winningNumber;
  var canUserInput = true;
  var incrementedBalance;
  int _counter;
  final StreamController _dividerController = StreamController<int>();
  final _wheelNotifier = StreamController<double>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  String getPlatformAdUnit() {
    if (Platform.isAndroid == true) {
      return 'ca-app-pub-2736804238343131/9307016674';
    } else {
      return 'ca-app-pub-2736804238343131/1161412271';
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getPlatformAdUnit(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  dispose() {
    _dividerController.close();
    _wheelNotifier.close();
  }

  addIntRoundToSF(int roundNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('roundNumber', roundNumber);
  }

  addIntTimeRemainingSF(int timeRemaining) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('timeRemaining', timeRemaining);
  }

  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedNumber', int.parse(selectedNumber.toString()));
    prefs.setInt('selectedBet', int.parse(selectedBet.toString()));
    selectedNumber = 'SELECT BET';
    selectedBet = 'PLACE BET';
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("selectedNumber");
    //Remove bool
    prefs.remove("selectedBet");
    //Remove int
  }

  Future<int> getIntSelectedSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt('selectedNumber');
    return intValue;
  }

  Future<int> getIntBetSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt('selectedBet');
    return intValue;
  }

  updateBalance() async {
    var selectedBetSP = await getIntBetSF();
    var selectedNumSP = await getIntSelectedSF();
    _showInterstitialAd();
    if (selectedBetSP != null || selectedNumSP != null) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Successfully Placed Bet")));
      print('getIntBetSF ' + selectedBetSP.toString());
      print('winningSelected ' + selectedNumSP.toString());
      print('winningSelected ' + winningNumber.toString());
      if (selectedNumSP == winningNumber) {
        incrementedBalance = 9 * selectedBetSP;
        addBalance();
        _showWinDialog(context, incrementedBalance);
      } else {
        incrementedBalance = selectedBetSP;
        decreaseBalance();
        _showLoseDialog(context, incrementedBalance);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("No Bets Placed. New Round Will Start Soon.")));
    }
    selectedBetSP = 10;
    selectedNumSP = 10;
    removeValues();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addBalance() {
    return users
        .doc(_auth.currentUser.uid)
        .update({
          'Balance': FieldValue.increment(incrementedBalance),
        })
        .then((value) => print("Balance Updated"))
        .catchError((error) => print("Failed to update time: $error"));
  }

  Future<void> decreaseBalance() {
    return users
        .doc(_auth.currentUser.uid)
        .update({
          'Balance': FieldValue.increment(-incrementedBalance),
        })
        .then((value) => print("Balance Updated"))
        .catchError((error) => print("Failed to update time: $error"));
  }

  CollectionReference spinner =
      FirebaseFirestore.instance.collection('spinner');
  Future<void> clearBets() {
    return spinner
        .doc('config')
        .update({
          '0': 0,
          '1': 0,
          '2': 0,
          '3': 0,
          '4': 0,
          '5': 0,
          '6': 0,
          '7': 0,
          '8': 0,
          '9': 0,
        })
        .then((value) => print("Bets Updated"))
        .catchError((error) => print("Failed to update time: $error"));
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 65000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;

  _showWinDialog(BuildContext context, int reward) {
    showDialog(
      context: context,
      builder: (context) => Container(
        width: 500,
        child: AlertDialog(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WINNING DRAW: ' + winningNumber.toString(),
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kYellowColor,
                    ),
                  ),
                  Text(
                    'YOU WIN!',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '$reward',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        color: kYellowColor,
                        width: 50,
                        height: 1,
                      ),
                      Text(
                        "BALANCE",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          textStyle: TextStyle(
                            letterSpacing: 1,
                            color: kYellowColor,
                          ),
                        ),
                      ),
                      Container(
                        color: kYellowColor,
                        width: 50,
                        height: 1,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Text(
                    (userBalance + reward).toString(),
                    style: GoogleFonts.sourceSansPro(
                      color: kYellowColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  _showLoseDialog(BuildContext context, int reward) {
    showDialog(
      context: context,
      builder: (context) => Container(
        child: AlertDialog(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WINNING DRAW: ' + winningNumber.toString(),
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kYellowColor,
                    ),
                  ),
                  Text(
                    'YOU LOSE!',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '-' + '$reward',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                          width: 50,
                          height: 1,
                        ),
                        Text(
                          "BALANCE",
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            textStyle: TextStyle(
                              letterSpacing: 1,
                              color: kYellowColor,
                            ),
                          ),
                        ),
                        Container(
                          color: kYellowColor,
                          width: 50,
                          height: 1,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (userBalance - reward).toString(),
                    style: GoogleFonts.sourceSansPro(
                      color: kYellowColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 15, 15),
                      child: Container(
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.shopping_cart_outlined),
                            iconSize: 30,
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopScreen()));
                              });
                            },
                          ),
                        ),
                        height: 50,
                        width: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('spinner')
                                .doc('config')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              var firestoreData = snapshot.data;

                              var roundStartedTime;
                              int roundNumber = 0;

                              try {
                                if (firestoreData['TimeStamp'] == null) {
                                  roundStartedTime = DateTime.now();
                                } else {
                                  roundStartedTime =
                                      firestoreData['TimeStamp'].toDate();
                                }
                              } catch (e) {}

                              if (firestoreData == null) {
                                winningNumber = 0;
                              } else {
                                winningNumber = firestoreData['winningNumber'];
                              }

                              if (firestoreData == null) {
                                roundNumber = 0;
                              } else {
                                roundNumber = firestoreData['round'];
                                addIntRoundToSF(roundNumber);
                              }

                              var roundEndTime = roundStartedTime
                                  .add(const Duration(minutes: 1));

                              if (roundEndTime.isAfter(DateTime.now())) {
                                //  _wheelNotifier.sink
                                //      .add(_generateRandomVelocity());

                                var diff = roundEndTime
                                    .difference(DateTime.now())
                                    .inSeconds;

                                _counter = diff;
                                Timer _timer;

                                _counter = diff;
                                if (_timer != null) {
                                  _timer.cancel();
                                }
                                _timer = Timer.periodic(Duration(seconds: 1),
                                    (timer) {
                                  setState(() {
                                    if (_counter > 0) {
                                      _counter--;
                                    } else {
                                      _timer.cancel();
                                    }
                                  });
                                });
                                addIntTimeRemainingSF(_counter);
                                if (_counter <= 30) {
                                  canUserInput = false;
                                  _wheelNotifier.sink
                                      .add(_generateRandomVelocity());
                                } else {
                                  canUserInput = true;
                                }

                                return Center(
                                  child: Text(
                                    'NEXT SPIN: ' +
                                        _counter.toString() +
                                        ' SECONDS',
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else {
                                CollectionReference config = FirebaseFirestore
                                    .instance
                                    .collection('spinner');

                                List<int> myList = new List();
                                Future<void> updateConfig() {
                                  for (int i = 0; i < 10; i++) {
                                    myList.add(int.parse(
                                        firestoreData[i.toString()]
                                            .toString()));
                                  }
                                  for (int i = 0; i < 10; i++) {
                                    if (myList.reduce(min) ==
                                        int.parse(firestoreData[i.toString()]
                                            .toString())) {
                                      winningNumber = i;
                                      return config
                                          .doc('config')
                                          .update({
                                            'TimeStamp':
                                                FieldValue.serverTimestamp(),
                                            'round': roundNumber + 1,
                                            'winningNumber': i
                                          })
                                          .then((value) =>
                                              print("Config Updated"))
                                          .catchError((error) => print(
                                              "Failed to update time: $error"));
                                    }
                                  }
                                }

                                updateConfig();
                                updateBalance();
                                myList.clear();
                                clearBets();
                                return Center(
                                  child: Text(
                                    '0',
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            }),
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          color: Color(0xff089A62),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: _dividerController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        data = int.parse(snapshot.data.toString());
                        return RouletteScore(
                            int.parse(snapshot.data.toString()));
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 360,
                    decoration: BoxDecoration(
                      color: kYellowColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: SpinningWheel(
                        Image.asset('assets/images/spinnergreen.png'),
                        width: 300,
                        height: 300,
                        initialSpinAngle: 0,
                        spinResistance: 0.6,
                        canInteractWhileSpinning: false,
                        dividers: 10,
                        onUpdate: _dividerController.add,
                        onEnd: _dividerController.add,
                        secondaryImage:
                            Image.asset('assets/images/spinnercenter.png'),
                        secondaryImageHeight: 110,
                        secondaryImageWidth: 110,
                        shouldStartOrStop: _wheelNotifier.stream,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (canUserInput == true) {
                              Navigator.of(context).push(
                                HeroDialogRoute(
                                  builder: (context) {
                                    return const PopUp();
                                  },
                                ),
                              );
                            }
                          });
                        },
                        child: Hero(
                          tag: _heroAddTodo,
                          // createRectTween: (begin, end) {
                          //   return CustomRectTween(begin: begin, end: end);
                          // },
                          child: Container(
                            height: 50,
                            width: 200,
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
                                      'SELECT NUMBER',
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 20,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: new BorderRadius.circular(30),
                  //     ),
                  //     primary: Color(0xff31B683),
                  //   ),
                  //   onPressed: () {
                  //     //_showLoseDialog(context);
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 165,
                  //     child: Center(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             "LAST DRAW:",
                  //             style: GoogleFonts.sourceSansPro(
                  //                 fontSize: 20, fontWeight: FontWeight.bold),
                  //           ),
                  //           Container(
                  //             width: 30,
                  //             child: Text(
                  //               "  " + data.toString(),
                  //               style: GoogleFonts.sourceSansPro(
                  //                   fontSize: 20, fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RouletteScore extends StatelessWidget {
  RouletteScore(this.selected);

  final int selected;

  addIntBalanceToSF(int balance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userBalance', balance);
  }

  final Map<int, String> labels = {
    1: '1',
    2: '2',
    3: '3',
    4: '4',
    5: '5',
    6: '6',
    7: '7',
    8: '8',
    9: '9',
    10: '0',
  };

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Firebase Realtime listener

  dynamic data;
  var winningNumber = 0;

  String getNumberLanded() {
    return labels[selected];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 150,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            color: Colors.white,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: DecoratedTitle('BALANCE', kTitleGreen),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              var firestoreData = snapshot.data;

                              CollectionReference config = FirebaseFirestore
                                  .instance
                                  .collection('users');
                              Future<void> updateNegativeBalance() {
                                return config
                                    .doc(_auth.currentUser.uid)
                                    .update({
                                      'Balance': 2,
                                    })
                                    .then((value) => print("Balance Updated"))
                                    .catchError((error) =>
                                        print("Failed to update time: $error"));
                              }

                              if (firestoreData == null) {
                                userBalance = 0;
                              } else {
                                userBalance = firestoreData['Balance'];
                                if (userBalance < 2) {
                                  updateNegativeBalance();
                                }
                                addIntBalanceToSF(userBalance);
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Center(
                                  child: Text(
                                    userBalance.toString(),
                                    style: GoogleFonts.sourceSansPro(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 38,
                                        color: kYellowColor),
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 38,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({Key key}) : super(key: key);

  @override
  _RazorPayPageState createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  Razorpay razorpay;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
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

  void openCheckout() {
    var options = {
      "key": "rzp_test_cz1rQchl6WAlY1",
      "amount": 1000,
      "Name": "Sample App",
      "description": "Payment For Coins",
      "prefil": {
        "contact": _auth.currentUser.phoneNumber,
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

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('payment success');
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('payment success');
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print('payment success');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
