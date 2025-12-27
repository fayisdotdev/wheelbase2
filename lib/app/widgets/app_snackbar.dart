import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show(String message, {bool error = false}) {
    Get.snackbar(
      error ? 'Error' : 'Success',
      message,
      backgroundColor: error ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}
