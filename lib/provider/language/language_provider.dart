import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('vi', ''); // Mặc định là Tiếng Việt

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Thay đổi ngôn ngữ
  Future<void> changeLanguage(Locale newLocale) async {
    _locale = newLocale;
    notifyListeners();

    // Lưu vào SharedPreferences để ghi nhớ
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }

  // Load ngôn ngữ từ SharedPreferences
  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguageCode = prefs.getString('languageCode');

    if (savedLanguageCode != null) {
      _locale = Locale(savedLanguageCode, '');
      notifyListeners();
    }
  }
}
