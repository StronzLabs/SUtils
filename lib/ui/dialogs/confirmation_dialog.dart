import 'dart:async';

import 'package:flutter/material.dart';

class ConfirmationDialog {
    static Future<bool> ask({
        required BuildContext context,
        required String title,
        String? text,
        TextSpan? content,
        String confirm = "Conferma",
        String cancel = "Annulla"
    }) async {
        assert((text == null) != (content == null));
        return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(title),
                content: content != null ? RichText(text: content) : Text(text!),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(cancel)
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(confirm)
                    )
                ],
            )
        ) ?? false;
    }
}
