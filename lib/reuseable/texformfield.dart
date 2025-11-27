import 'package:flutter/material.dart';

class TexFormfield extends StatelessWidget {
  final String? hintText;
  final Text labelText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;
  final void Function(String)? onFieldSubmitted;
  final Icon? prefixIcon;
  final Color? decorationColor; // NEW: border color & label color
  final TextStyle? style; // NEW: input text style
  final Color? cursorColor; // NEW: cursor color

  const TexFormfield({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.validator,
    this.obscureText,
    this.onFieldSubmitted,
    this.decorationColor,
    this.style,
    this.cursorColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final baseBorderColor = decorationColor ?? Colors.blue;

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: cursorColor ?? baseBorderColor,
      style: style ?? const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        label: labelText,
        labelStyle: TextStyle(color: baseBorderColor),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: baseBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: baseBorderColor.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: baseBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
    );
  }
}
