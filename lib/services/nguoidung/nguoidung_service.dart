import 'dart:convert';
import 'package:app_cybersoft/util/constants.dart';
import 'package:app_cybersoft/util/helper.dart';
import 'package:http/http.dart' as http;

class NguoiDungServices {
  Future<Map<String, dynamic>> getThongTinNguoiDung() async {
    final userInfo = await getUserInfo();
    final token = userInfo['accessToken'];

    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}nguoidung/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }
      return decodedData['content'];
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> getDanhSachKhoaHocUser() async {
    final url = Uri.parse('${Constants.BASE_URL}khoahoc_nguoidung/user');
    final userInfo = await getUserInfo();
    final token = userInfo['accessToken'];

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi ${response.statusCode}: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> luuKhoaHoc({
    required String maNguoiDung,
    required int maKhoaHoc,
  }) async {
    final url = Uri.parse('${Constants.BASE_URL}khoahoc_nguoidung/luu-khoahoc');

    final data = {
        "maNguoiDung": maNguoiDung,
        "maKhoaHoc": maKhoaHoc,
      };

    print(data);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi ${response.statusCode}: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> getDanhSachKhoaHocDaLuu() async {
    final userInfo = await getUserInfo();
    final userId = userInfo['userId'];
    final url = Uri.parse(
        '${Constants.BASE_URL}khoahoc_nguoidung/lay-khoahoc-da-luu/user/${userId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Lỗi ${response.statusCode}: ${response.body}");
    }
  }

  // Future<Map<String, dynamic>> updateThongTinNguoiDung(
  //     Map<String, dynamic> newData) async {
  //   try {
  //     final userInfo = await getUserInfo();
  //     final token = userInfo['accessToken'];
  //     print(newData);

  //     print('${Constants.BASE_URL}nguoidung');
  //     final response = await http.put(
  //       Uri.parse('${Constants.BASE_URL}nguoidung'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode(newData),
  //     );

  //     print(response.statusCode);

  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     print('Lỗi khi cập nhật thông tin người dùng: $e');
  //     throw Exception('Failed to update user data');
  //   }
  // }
}
