import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinner/constants.dart';
import 'package:flutter_spinner/decorated_title.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_rect_tween.dart';
import 'num_button.dart';

class BetPopup extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const BetPopup({Key key}) : super(key: key);
  static const String _heroBet = 'bet-hero';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: _heroBet,
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
                        child: DecoratedTitle('BET PAGE', kTitleGreen),
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kYellowColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: Container(
                            width: 200,
                            height: 50,
                            child: Center(
                              child: Text(
                                "PLACE BET",
                                style: GoogleFonts.sourceSansPro(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
