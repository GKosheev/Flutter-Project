import 'package:flutter/material.dart';

void showSuccessSnackbar(BuildContext context, String text,
    {int durationInSeconds = 5}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Colors.blue.shade400,
    duration: Duration(seconds: durationInSeconds),
  ));
}
