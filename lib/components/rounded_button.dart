import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    required this.onPressed,
    required this.color,
    this.textColor = Colors.white,
    Key? key,
  }) : super(key: key);
  final String label;
  final VoidCallback onPressed;
  final Color color, textColor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            padding:const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          ),
          child: Text(
              label.toUpperCase(),
            style: TextStyle(color: textColor),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

