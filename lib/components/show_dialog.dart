import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  const ShowDialog({
    Key? key,
    required this.dialogTitle,
    required this.dialogContent,
    required this.actions,
  }) : super(key: key);
  final String dialogTitle;
  final String dialogContent;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        dialogTitle,
        style:const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize:20
        ),
      ),
      content: Text(
        dialogContent,
        style:const TextStyle(
            color: Colors.white
        ),
      ),
      actions: actions,
    );
  }
}
