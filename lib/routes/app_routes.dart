import 'package:app_cybersoft/screen/Auth/login_screen.dart';
import 'package:app_cybersoft/screen/Auth/register_screen.dart';
import 'package:app_cybersoft/templates/auth_template.dart';
import 'package:app_cybersoft/templates/main_template.dart';
import 'package:app_cybersoft/util/helper.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => FutureBuilder<Map<String, String?>>(
        future: getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data!['userId'] != null) {
            return MainTemplate();
          }
          return AuthTemplate(title: 'Login', child: LoginScreen());
        },
      ),
    );
  }
}