import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String toShortDate() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

extension ContextExtension on BuildContext {
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
