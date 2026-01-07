import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String? title;
  final TextEditingController controller;
  final bool? showPassword;
  final IconButton? iconButton;
  final int? maxLines;
  final Function(String?)? onChange;
  final String? Function(String?)? validator;

  CustomTextField({
    super.key,
    this.title,
    required this.controller,
    this.showPassword,
    this.validator,
    this.iconButton,
    this.maxLines, this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        if(title != null && title!.isNotEmpty) Text(title ?? ""),
        TextFormField(
          controller: controller,
          maxLines: maxLines ?? 1,
          obscureText: showPassword ?? false,
          decoration: InputDecoration(
            hintText: title ?? "",
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: .circular(10),
              borderSide: BorderSide(color: Colors.red),
            ),
            suffixIcon: iconButton,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          onChanged: onChange,
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill the $title field";
                }
                return null;
              },
        ),
      ],
    );
  }
}
