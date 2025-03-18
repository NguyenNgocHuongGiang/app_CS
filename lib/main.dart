import 'package:app_cybersoft/provider/khoahoc/khoahoc_provider.dart';
import 'package:app_cybersoft/provider/language/language_provider.dart';
import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cybersoft/provider/theme/theme_provider.dart';
// import 'package:app_cybersoft/provider/language_provider.dart';
import 'package:app_cybersoft/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NguoiDungProvider()),
        ChangeNotifierProvider(create: (context) => KhoaHocProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()), // Thêm LanguageProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
