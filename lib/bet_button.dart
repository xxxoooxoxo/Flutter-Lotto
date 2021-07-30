
import 'package:flutter/material.dart';
import 'package:flutter_spinner/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class BetButton extends StatefulWidget {

  final String num;
  //final onPress;

  const BetButton(this.num, {Color colorWhite});

  @override
  _BetButtonState createState() => _BetButtonState();
}

class _BetButtonState extends State<BetButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kYellowColor,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30),
          ),
        ),
        onPressed: (){setState(() {

        });},
        child: Container(
          width: 45,
          child: Center(
            child: Text(
              widget.num,
              style: GoogleFonts.sourceSansPro(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
