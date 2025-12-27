import 'package:flutter/services.dart';

class MaxWordsInputFormatter extends TextInputFormatter {
  final int maxWords = 30;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final words = newValue.text.trim().split(RegExp(r'\s+'));
    final wordCount = newValue.text.isEmpty ? 0 : words.where((w) => w.isNotEmpty).length;

    if (wordCount > maxWords) {
      return oldValue; // Revert to previous value if exceeding limit
    }
    return newValue;
  }
}