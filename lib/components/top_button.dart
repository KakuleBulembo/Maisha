import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopButton extends StatelessWidget {
  const TopButton({
    Key? key,
    required this.title,
    required this.addLabel,
    required this.onPressed
  }) : super(key: key);
  final String title;
  final String addLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.acme(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        ButtonBlue(onPressed: onPressed, addLabel: addLabel, color: Colors.purple, icon:const Icon(Icons.add),),
      ],
    );
  }
}

class ButtonBlue extends StatelessWidget {
  const ButtonBlue({
    Key? key,
    required this.onPressed,
    required this.addLabel,
    required this.color,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String addLabel;
  final Color color;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20.0),
      ),
      onPressed: onPressed,
      icon: icon,
      label:  Text(addLabel, style: const TextStyle(
          color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      ),
    );
  }
}
