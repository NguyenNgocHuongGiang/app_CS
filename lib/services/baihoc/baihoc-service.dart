import 'dart:convert';
import 'package:app_cybersoft/util/constants.dart';
import 'package:app_cybersoft/util/helper.dart';
import 'package:http/http.dart' as http;

class BaiHocServices {
  Future<List<dynamic>> getKhoaHocTheoSkill() async {
    final response =
        await http.get(Uri.parse('${Constants.BASE_URL}khoahoc/list-skill'));

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }
      final List<dynamic> content = decodedData['content'];

      return content;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<dynamic>> getKhoaHocGoiY(String bidanh) async {
    print(bidanh);
    final response = await http.get(
        Uri.parse('${Constants.BASE_URL}khoahoc/skill?alias=$bidanh'));
    print(response.body);

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }
      final List<dynamic> content = decodedData['content'];
      return content;
    } else {
      throw Exception('Failed to load courses');
    }
  }

    Future<List<dynamic>> getReviewKhoaHoc(String bidanh) async {
    print(bidanh);
    final response = await http.get(
        Uri.parse('${Constants.BASE_URL}reviewcourse/course?alias=$bidanh'));
    print(response.body);

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }
      final List<dynamic> content = decodedData['content'];
      return content;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<dynamic>> getKhoaHocPopular() async {
    final response =
        await http.get(Uri.parse('${Constants.BASE_URL}khoahoc/popular'));

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }
      final List<dynamic> content = decodedData['content'];
      return content;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<Map<String, dynamic>> getDetailKhoaHoc(String bidanh) async {
    final response = await http
        .get(Uri.parse('${Constants.BASE_URL}khoahoc/alias?alias=$bidanh'));

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }
      final Map<String, dynamic> course = decodedData['content'];
      return course;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<dynamic>> getChuongHocTheoId(List<int> ids) async {
    List<Future<http.Response>> requests = ids.map((id) {
      return http.get(Uri.parse('${Constants.BASE_URL}chuonghoc/$id'));
    }).toList();

    List<http.Response> responses = await Future.wait(requests);

    List<dynamic> result = [];

    for (var response in responses) {
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final decodedData = decodedBody['content'];
        result.add(decodedData);
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> getBaiHocTheoBiDanh(String bidanh) async {
    final userInfo = await getUserInfo();
    final token = userInfo['accessToken'];
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}baihoc/alias?alias=$bidanh'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(response.statusCode);

    final decodedData = json.decode(response.body);

    if (decodedData['statusCode'] == 200) {
      if (decodedData['content'] == null || decodedData['content'].isEmpty) {
        throw Exception('Dữ liệu trống');
      }

      final content = decodedData['content'];

      return content;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<String> getVideo(String url) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}file/ftp-video-eduzy-digital/$url'),
    );

    return response.body;
  }
}
