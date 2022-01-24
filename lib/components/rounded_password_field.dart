import 'package:flutter/material.dart';
import 'package:maisha/components/text_field_container.dart';

import '../constant.dart';

class RoundedPasswordField extends StatefulWidget {
  const RoundedPasswordField({
    Key? key,
    required this.hintText,
    required this.onTap,
    this.obscureText = true,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);
  final String hintText;
  final VoidCallback onTap;
  final bool obscureText;
  final dynamic validator;
  final ValueChanged<String> onChanged;

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormFieldContainer(
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(Icons.lock, color: kPrimaryColor),
          suffixIcon: InkWell(
            child:const Icon(Icons.visibility, color: kPrimaryColor),
            onTap: widget.onTap,
          ),
          border: InputBorder.none,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}