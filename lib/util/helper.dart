import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String?>> getUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  String? accessToken = prefs.getString('accessToken');

  return {'userId': userId, 'accessToken': accessToken};
}


Future<void> saveUserData(String accessToken, String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('userId', id);
  // await prefs.setString('fullname', fullname);
}


Future<void> saveUserCredentials(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}