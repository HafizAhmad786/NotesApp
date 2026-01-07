import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomColumn extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomColumn({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,style: TextStyle(color: Colors.grey),),
        Text(
          subTitle,
          style: TextStyle(fontWeight: .w600),
        ),
      ],
    );
  }
}
