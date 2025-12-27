import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Helpers {
  static void showSnackbar(String message, {bool error = false}) {
    Get.snackbar(
      error ? 'Error' : 'Success',
      message,
      backgroundColor: error
          ? const Color(0xFFD32F2F)
          : const Color(0xFF388E3C),
      colorText: const Color(0xFFFFFFFF),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}
