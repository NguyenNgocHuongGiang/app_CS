import 'package:app_cybersoft/component/reviewCourse.dart';
import 'package:app_cybersoft/provider/khoahoc/khoahoc_provider.dart';
import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';
import 'package:app_cybersoft/screen/Auth/login_screen.dart';
import 'package:app_cybersoft/screen/Homepage/detail_lesson_screen.dart';
import 'package:app_cybersoft/services/baihoc/baihoc-service.dart';
import 'package:app_cybersoft/services/nguoidung/nguoidung_service.dart';
import 'package:app_cybersoft/templates/auth_template.dart';
import 'package:app_cybersoft/util/constants.dart';
import 'package:app_cybersoft/util/helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailCourse extends StatefulWidget {
  final String bidanh;
  final String tenKhoaHoc;

  const DetailCourse({
    Key? key,
    required this.bidanh,
    required this.tenKhoaHoc,
  }) : super(key: key);

  @override
  _DetailCourseState createState() => _DetailCourseState();
}

Future<List<dynamic>> fetchReviewKhoaHoc(String bidanh) async {
  final response = await BaiHocServices().getReviewKhoaHoc(bidanh);
  if (response != null) {
    return response;
  }
  return [];
}

class _DetailCourseState extends State<DetailCourse> {
  late Future<Map<String, dynamic>> khoaHocFuture;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    khoaHocFuture = BaiHocServices().getDetailKhoaHoc(widget.bidanh);
    final userProvider = Provider.of<NguoiDungProvider>(context, listen: false);
    final khoaHocProvider =
        Provider.of<KhoaHocProvider>(context, listen: false);
    userProvider.fetchUserCourses();
    userProvider.fetchUserSaveCourses();
    khoaHocProvider.fetchKhoaHocGoiY(widget.bidanh);
    khoaHocProvider.fetchReviewKhoaHoc(widget.bidanh);
  }

  Future<List<dynamic>> fetchSuggestedCourses() async {
    final response = await BaiHocServices().getKhoaHocGoiY(widget.bidanh);
    if (response != null) {
      return response; // Danh sách khóa học
    }
    return [];
  }

  // Hàm tìm khóa học phù hợp trong userCourses dựa trên bidanh
  Map<String, dynamic>? findMatchingCourse(
      List<dynamic> userCourses, String bidanh) {
    for (var course in userCourses) {
      if (course['biDanh'] == bidanh) {
        return course;
      }
    }
    return null;
  }

  Map<String, dynamic>? findSaveMatchingCourse(
      List<dynamic> userCourses, String bidanh) {
    for (var course in userCourses) {
      if (course['khoaHoc']['biDanh'] == bidanh) {
        return course;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true, // Giúp AppBar tràn xuống dưới ảnh
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(70, 250, 239, 44), // Làm trong suốt
        elevation: 0, // Loại bỏ bóng
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber), // Nút quay lại
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tenKhoaHoc,
          style: TextStyle(
            color: Colors.amber, // Màu chữ
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: khoaHocFuture,
        builder: (context, snapshot) {
          final userProvider =
              Provider.of<NguoiDungProvider>(context, listen: false);
          final saveCourses = userProvider.saveCourses;

          var isSaveCourse = saveCourses != null
              ? findSaveMatchingCourse(saveCourses, widget.bidanh)
              : null;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu.'));
          }

          final course = snapshot.data!;
          String description = course['moTa'];
          String shortDescription = description.length > 200
              ? description.substring(0, 200) + '...'
              : description;

          String danhSachChuong = course['danhSachChuongHoc'];
          List<int> chaptersList = List<int>.from(jsonDecode(danhSachChuong));
          int totalChapters = chaptersList.length;

          // Giải mã metaData từ chuỗi JSON
          final metaData = jsonDecode(course['metaData']);
          final courseLevel = metaData['Level'];
          final totalTime = metaData['TotalTime'];
          // final overview = metaData['Overview'];
          // final willLearn = metaData['WillLearn'];
          final layout = metaData['Layout'];

          final responseChapter =
              BaiHocServices().getChuongHocTheoId(chaptersList);

          // final suggestedCourses =
          //     BaiHocServices().getKhoaHocGoiY(widget.bidanh);

          // final reviewCourse = BaiHocServices().getReviewKhoaHoc(widget.bidanh);
          // print(reviewCourse);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 5.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(
                        '${Constants.IMAGE_URL}${course['hinhAnh']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    course['tenKhoaHoc'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 16),
                  // Hiển thị số chương
                  Row(
                    children: [
                      Icon(
                        Icons.book,
                        size: 20,
                        color: Colors.amber[700],
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tổng số chương: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$totalChapters',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  // Hiển thị thông tin trạng thái khóa học (online/offline)
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 20,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text(
                        'Hình thức học: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              course['isOnline'] ? Colors.green : Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          course['isOnline'] ? "Online" : "Offline",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  if (metaData != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: Icon(
                            Icons.grade,
                            size: 18,
                            color: Colors.grey,
                          ),
                          label: Text(
                            '$courseLevel',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        Chip(
                          avatar: Icon(
                            Icons.timer,
                            size: 18,
                            color: Colors.grey,
                          ),
                          label: Text(
                            '$totalTime giờ',
                            style: TextStyle(fontSize: 14),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),

                  SizedBox(height: 8),
                  // Hiển thị thông tin giá khóa học
                  Text(
                    '${NumberFormat("#,##0").format(course['price'] ?? 0)} ${course['donViTienTe'] ?? ''}',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),

                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.amber,
                          side: BorderSide(
                            color: Colors.yellow,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          'Mua ngay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () async {
                          if (isSaveCourse == null) {
                            try {
                              final userInfo = await getUserInfo();
                              final maNguoiDung = userInfo['userId'];

                              await NguoiDungServices().luuKhoaHoc(
                                maNguoiDung: maNguoiDung ?? '',
                                maKhoaHoc: course['id'],
                              );

                              // Gọi Provider để cập nhật danh sách đã lưu
                              Provider.of<NguoiDungProvider>(context,
                                      listen: false)
                                  .fetchUserSaveCourses();

                              // Cập nhật trạng thái
                              setState(() {
                                isSaveCourse = {
                                  'khoaHoc': {'biDanh': widget.bidanh}
                                };
                              });

                              // Hiển thị thông báo
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Đã thêm vào danh sách mong ước!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Lỗi khi thêm vào danh sách mong ước: $e'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.amber,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          isSaveCourse == null
                              ? 'Thêm vào danh sách mong ước'
                              : "Đã thêm vào danh sách mong ước",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  // Hiển thị layout
                  if (layout != '')
                    Container(
                      height: 500.0, // Đặt chiều cao rõ ràng
                      child: Markdown(
                        data: layout,
                        styleSheet: MarkdownStyleSheet(
                          h1: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          h2: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          p: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),

                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Nội dung khóa học:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: responseChapter,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData) {
                        return Center(child: Text('Không có dữ liệu.'));
                      }

                      var chapters = snapshot.data!;
                      // print(userCourses);

                      // Hàm kiểm tra trạng thái hoàn thành của bài học dựa trên maBaiHoc
                      bool isLessonCompleted(
                          List<dynamic> lsBaiTapDone, int maBaiHoc) {
                        for (var item in lsBaiTapDone) {
                          if (item['maBaiHoc'] == maBaiHoc &&
                              item['done'] == true) {
                            return true;
                          }
                        }
                        return false;
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: chapters.length,
                        itemBuilder: (context, index) {
                          var chuong = chapters[index];

                          return ExpansionTile(
                            title: Text(
                              chuong["tenChuong"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            children:
                                chuong["thongTinBaiHoc"].map<Widget>((baiHoc) {
                              return FutureBuilder<Map<String, String?>>(
                                future: getUserInfo(),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListTile(
                                      title: Text(
                                        baiHoc["tenBaiHoc"],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: 10.0,
                                      ),
                                    );
                                  }

                                  final userInfo = userSnapshot.data ?? {};
                                  final isLoggedIn =
                                      userInfo['accessToken'] != null &&
                                          userInfo['accessToken']!.isNotEmpty;

                                  // Nếu chưa đăng nhập, hiển thị chấm xám
                                  if (!isLoggedIn) {
                                    return ListTile(
                                      title: Text(
                                        baiHoc["tenBaiHoc"],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: 10.0,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AuthTemplate(
                                              title: 'Login',
                                              child: LoginScreen(),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  // Nếu đã đăng nhập, kiểm tra trạng thái hoàn thành bài học
                                  final userProvider =
                                      Provider.of<NguoiDungProvider>(context);
                                  final userCourses = userProvider.userCourses;
                                  // final saveCourses = userProvider.saveCourses;

                                  final matchingCourse = userCourses != null
                                      ? findMatchingCourse(
                                          userCourses, widget.bidanh)
                                      : null;

                                  // Nếu matchingCourse không null, kiểm tra trạng thái hoàn thành
                                  if (matchingCourse != null) {
                                    List<dynamic> lsBaiTapDone =
                                        matchingCourse['lsBaiTapDone'] ?? [];
                                    bool isCompleted = isLessonCompleted(
                                        lsBaiTapDone, baiHoc['id']);

                                    return ListTile(
                                      title: Text(
                                        baiHoc["tenBaiHoc"],
                                        style: isCompleted
                                            ? TextStyle(
                                                fontSize: 13,
                                                color: Colors.green)
                                            : TextStyle(fontSize: 13),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: isCompleted
                                            ? Colors.green
                                            : Colors.grey[300],
                                        radius: 10.0,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailLessonScreen(
                                                    bidanh: baiHoc["biDanh"],
                                                    tenBaiHoc:
                                                        baiHoc["tenBaiHoc"]),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    // Nếu matchingCourse là null, chỉ cho phép nhấn vào bài học có isDemo là true
                                    // bool isDemo = baiHoc['isDemo'] == true; // Kiểm tra isDemo
                                    // print(isDemo);
                                    return ListTile(
                                      title: Text(
                                        baiHoc["tenBaiHoc"],
                                        style: baiHoc['isDemo']
                                            ? TextStyle(fontSize: 13)
                                            : TextStyle(
                                                fontSize: 13,
                                                color: Colors
                                                    .grey), // Làm mờ nếu không phải demo
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: baiHoc['isDemo']
                                            ? Colors.grey[300]
                                            : Colors.grey[100],
                                        radius: 10.0,
                                      ),
                                      enabled: !baiHoc[
                                          'isDemo'], // Chỉ cho phép nhấn nếu isDemo là true
                                      onTap: baiHoc['isDemo']
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailLessonScreen(
                                                          bidanh:
                                                              baiHoc["biDanh"],
                                                          tenBaiHoc: baiHoc[
                                                              "tenBaiHoc"]),
                                                ),
                                              );
                                            }
                                          : null, // Vô hiệu hóa onTap nếu không phải demo
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Căn chỉnh các phần tử theo chiều dọc
                    children: [
                      Text(
                        'Mô tả:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _isExpanded ? description : shortDescription,
                        style: TextStyle(fontSize: 14),
                      ),
                      if (description.length > 100)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.zero), // Xóa padding thừa
                              alignment: Alignment
                                  .centerLeft, // Căn chỉnh text bên trái
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              _isExpanded ? 'Thu gọn' : 'Hiển thị thêm',
                              style: TextStyle(
                                  color: Colors.amber[700], fontSize: 14.0),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Học viên cũng mua:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: fetchSuggestedCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("Không có khóa học nào."));
                      }

                      final courses = snapshot.data!;
                      final displayedCourses =
                          courses.length > 3 ? courses.sublist(0, 3) : courses;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: displayedCourses.length,
                            itemBuilder: (context, index) {
                              final course = displayedCourses[index];
                              return Column(
                                children: [
                                  // Nội dung khóa học
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailCourse(
                                            bidanh: course['biDanh'],
                                            tenKhoaHoc: course['tenKhoaHoc'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                '${Constants.IMAGE_URL}${course['hinhAnh']}' ??
                                                    'https://fbm.neu.edu.vn/wp-content/uploads/2022/06/Free-Online-Course.jpg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                16), // Khoảng cách giữa ảnh và nội dung
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course['tenKhoaHoc'] ??
                                                    "Không có tên",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                course['price'] != null
                                                    ? "${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(course['price'])}"
                                                    : "Miễn phí",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (index < displayedCourses.length - 1)
                                    Divider(color: Colors.grey.shade300),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (courses.length > 3)
                            Center(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.amber, // Màu nền của nút
                                  foregroundColor: Colors.white, // Màu chữ
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Bo tròn góc
                                  ),
                                  elevation: 3, // Đổ bóng nhẹ
                                ),
                                child: Text(
                                  "Xem thêm khóa học",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Phản hồi của học viên:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  ReviewList(
                    futureReviews: fetchReviewKhoaHoc(widget.bidanh),
                    courseName: widget.tenKhoaHoc,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
