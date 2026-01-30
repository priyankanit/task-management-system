import 'package:flutter/material.dart';

class AppDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    Color? color,
    Widget? customContent,
    String buttonText = 'OK',
    VoidCallback? onPressed,
     bool showCancel = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.lightBlueAccent.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(title),
        content: customContent ?? Text(message),
        actions: [
          if (showCancel)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          TextButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
