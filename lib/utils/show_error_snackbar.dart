import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String text,
    {int durationInSeconds = 5}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Colors.red.shade400,
    duration: Duration(seconds: durationInSeconds),
  ));
}
