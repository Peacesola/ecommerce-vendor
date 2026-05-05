import 'package:flutter/material.dart';

class ReusableTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final void Function (String)? onChanged;
  const ReusableTextFormField({super.key, required this.controller, required this.labelText, this.keyboardType, this.validator, this.textInputAction, this.maxLines, this.minLines, required this.obscureText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      style: TextStyle(fontWeight: FontWeight.w600),
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black
          ),
          borderRadius: BorderRadius.circular(10),
         // borderSide:
        ),
        labelStyle: TextStyle(
            color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 20
        ),
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
