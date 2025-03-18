import 'dart:convert';
import 'package:app_cybersoft/templates/main_template.dart';
import 'package:app_cybersoft/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  Future<Map<String, String>?> login(String email, String matKhau) async {
    final data = {
      'email': email,
      'matKhau': matKhau,
      'deviceId': '',
      'deviceType': '',
    };
    print(data);

    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}nguoidung/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData != null && responseData['content'] != null) {
          String accessToken = responseData['content']['accessToken'];
          String id = responseData['content']['id'];

          print('AccessToken: $accessToken');
          print('User ID: $id');

          return {'accessToken': accessToken, 'id': id};
        }
      } else {
        throw Exception('Đăng nhập thất bại');
      }
    } catch (error) {
      throw Exception('Lỗi kết nối: $error');
    }
    return null;
  }

  Future<void> logoutUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userId');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainTemplate()),
    );
  }
}
