import 'package:flutter/material.dart';


class PostInputField extends StatelessWidget {
  const PostInputField({
    Key? key,
    this.initialValue = '',
    required this.label,
    required this.hintText,
    required this.maxLines,
    required this.minLines,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);
  final String label;
  final String hintText;
  final int maxLines;
  final int minLines;
  final ValueChanged<String> onChanged;
  final String initialValue;
  final dynamic validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shadowColor: Colors.purple,
        elevation: 5.0,
        shape:const RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.purple,
            ),
            TextFormField(
              validator: validator,
              initialValue: initialValue,
              textAlign: TextAlign.center,
              cursorColor: Colors.purple,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              maxLines: maxLines,
              minLines: minLines,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
