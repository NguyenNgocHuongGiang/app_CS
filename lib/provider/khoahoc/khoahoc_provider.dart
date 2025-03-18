import 'package:app_cybersoft/services/baihoc/baihoc-service.dart';
import 'package:flutter/material.dart';

class KhoaHocProvider with ChangeNotifier {
  List<dynamic> _courses = [];
  List<dynamic> _filteredCourses = [];
  List<dynamic> _suggestedCourse = [];
  List<dynamic> _reviews = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get reviews => _reviews;
  List<dynamic> get courses => _filteredCourses;
  List<dynamic> get suggestedCourses => _suggestedCourse;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchReviewKhoaHoc(String bidanh) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<dynamic> fetchedReviews =
          await BaiHocServices().getReviewKhoaHoc(bidanh);
      _reviews = fetchedReviews;
    } catch (e) {
      _errorMessage = "Lỗi khi tải review khóa học: ${e.toString()}";
      _reviews = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchKhoaHocGoiY(String bidanh) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<dynamic> suggestedCourses =
          await BaiHocServices().getKhoaHocGoiY(bidanh);
      _suggestedCourse = suggestedCourses;
    } catch (e) {
      _errorMessage = e.toString();
      _suggestedCourse = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPopularCourses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _courses = await BaiHocServices().getKhoaHocPopular();
      _filteredCourses = List.from(_courses);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      _filteredCourses = List.from(_courses);
    } else {
      _filteredCourses = _courses
          .where((course) =>
              course['tenKhoaHoc'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void filterByCategory(String? category) {
    if (category == null) {
      _filteredCourses = _courses; // Hiển thị tất cả nếu không có bộ lọc
    } else {
      _filteredCourses =
          _courses.where((course) => course['maPhanLoai'] == category).toList();
    }
    notifyListeners();
  }
}
