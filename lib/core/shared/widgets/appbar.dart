import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final String titleText;
  CustomAppBar({
    super.key,
    required this.titleText,
  });
  @override
  Widget? get title => Text(titleText);
  @override
  Color? get surfaceTintColor => Colors.transparent;
}
