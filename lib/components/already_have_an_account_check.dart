import 'package:flutter/material.dart';

import '../constant.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.onTap,
  }) : super(key: key);
  final bool login;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have an account ? " : 'Already have an account ? ',
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          child: Text(
            login ? 'Sign Up' : 'Sign In',
            style:const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onTap,
        )
      ],
    );
  }
}
