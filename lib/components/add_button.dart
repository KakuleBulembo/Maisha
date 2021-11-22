import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.purple),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      icon: icon,
      label:  Text(addLabel, style: const TextStyle(color: Colors.white),),
    );
  }
}