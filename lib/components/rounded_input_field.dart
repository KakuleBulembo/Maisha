import 'package:flutter/material.dart';
import 'package:maisha/components/text_field_container.dart';

import '../constant.dart';

class RoundedTextFormField extends StatelessWidget {
  const RoundedTextFormField({
    required this.hintText,
    required this.icon,
    required this.validator,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  final String hintText;
  final IconData icon;
  final dynamic validator;
  final ValueChanged<String> onChanged;


  @override
  Widget build(BuildContext context) {
    return TextFormFieldContainer(
      child: TextFormField(
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}