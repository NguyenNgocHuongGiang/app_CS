import 'package:app_cybersoft/services/nguoidung/nguoidung_service.dart';
import 'package:flutter/material.dart';

class NguoiDungProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
   List<Map<String, dynamic>> _userCourses = [];
   List<Map<String, dynamic>> _saveCourses = [];
  final NguoiDungServices _nguoiDungService = NguoiDungServices();

  Map<String, dynamic>? get user => _user;
  List<Map<String, dynamic>>? get userCourses => _userCourses;
  List<Map<String, dynamic>>? get saveCourses => _saveCourses;

  Future<void> fetchUserData() async {
    try {
      final userData = await _nguoiDungService.getThongTinNguoiDung();
      _user = userData as Map<String, dynamic>?;
      // print(_user);
      notifyListeners();
    } catch (e) {
      print('Lỗi khi lấy thông tin người dùng: $e');
    }
  }

  Future<void> fetchUserCourses() async {
    try {
      final response = await _nguoiDungService.getDanhSachKhoaHocUser();

      if (response['statusCode'] == 200 && response['content'] is List) {
        _userCourses = List<Map<String, dynamic>>.from(response['content']);
        // print(_userCourses);
        notifyListeners();
      } else {
        print("❌ Lỗi lấy danh sách khóa học: ${response['message']}");
      }
    } catch (e) {
      print("⚠️ Lỗi khi gọi API: $e");
    }
  }


  Future<void> fetchUserSaveCourses() async {
    try {
      final response = await _nguoiDungService.getDanhSachKhoaHocDaLuu();

      if (response['statusCode'] == 200 && response['content'] is List) {
        _saveCourses = List<Map<String, dynamic>>.from(response['content']);;
        notifyListeners();
      } else {
        print("❌ Lỗi lấy danh sách khóa học: ${response['message']}");
      }
    } catch (e) {
      print("⚠️ Lỗi khi gọi API: $e");
    }
  }

  // Future<void> updateUserData(Map<String, dynamic> newUserData) async {
  //   try {
  //     final response =
  //         await _nguoiDungService.updateThongTinNguoiDung(newUserData);
  //     print(response);

  //     if (response['statusCode'] == 200) {
  //       _user = response['content']
  //           as Map<String, dynamic>?; // Cập nhật thông tin mới
  //       notifyListeners(); // Cập nhật UI
  //     } else {
  //       print("Lỗi cập nhật: ${response['message']}");
  //     }
  //   } catch (e) {
  //     print("Lỗi khi cập nhật thông tin người dùng: $e");
  //   }
  // }

  void clearUser() {
    _user = null;
    _userCourses = [];
    _saveCourses = [];
    notifyListeners();
  }
}
