import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Colors.red.shade400,
  ));
}
