import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        child:Text(
          label,
          style: GoogleFonts.adventPro(
            textStyle:const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
    );
  }
}
