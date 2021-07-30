
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DecoratedTitle extends StatelessWidget {

  final String title;
  final Color color;

  const DecoratedTitle(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 20,
        ),
        Container(
          color: color,
          width: 70,
          height: 1,
        ),
        Text(
          "$title",
          style: GoogleFonts.sourceSansPro(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            textStyle: TextStyle(
              letterSpacing: 1,
              color: color,
            ),
          ),
        ),
        Container(
          color: color,
          width: 70,
          height: 1,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
