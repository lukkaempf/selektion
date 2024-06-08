import 'package:flutter/material.dart';

class ErrorDialog {
  static genericError(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Etwas ist schief gelaufen.'),
      backgroundColor: Colors.grey,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      elevation: 30,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static customError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.grey,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(50),
      elevation: 30,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
