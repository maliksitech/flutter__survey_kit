import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration({String hint = ''}) => InputDecoration(
      contentPadding: const EdgeInsets.only(
        left: 10,
        bottom: 10,
        top: 10,
        right: 10,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.black.withValues(alpha: (0.2 * 255).round().toDouble()),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.black.withValues(alpha: (0.2 * 255).round().toDouble()),
        ),
      ),
      hintText: hint,
    );
