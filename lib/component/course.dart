import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';
import 'package:app_cybersoft/screen/Homepage/detai_course_screen.dart';
import 'package:app_cybersoft/services/nguoidung/nguoidung_service.dart';
import 'package:app_cybersoft/util/constants.dart';
import 'package:app_cybersoft/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardCourse extends StatefulWidget {
  final course;

  const CardCourse({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  _CardCourseState createState() => _CardCourseState();
}

class _CardCourseState extends State<CardCourse> {
  bool isSaved = false; // Trạng thái lưu/đã lưu

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usersProvider =
          Provider.of<NguoiDungProvider>(context, listen: false);
      final int maKhoaHoc = widget.course['id'];

      setState(() {
        isSaved = usersProvider.saveCourses
                ?.any((course) => course['khoaHoc']['id'] == maKhoaHoc) ??
            false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Chuyển hướng tới đường dẫn có bidanh của khóa học
        final bidanh =
            widget.course['biDanh']; // Lấy bidanh từ dữ liệu khóa học
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCourse(
              bidanh: bidanh,
              tenKhoaHoc: widget.course['tenKhoaHoc'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 90, // Chiều cao cố định
                    child: Image.network(
                      '${Constants.IMAGE_URL}${widget.course['hinhAnh']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://fbm.neu.edu.vn/wp-content/uploads/2022/06/Free-Online-Course.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                // Nút "Lưu" ở góc trên bên phải của hình ảnh
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape
                            .rectangle, // Làm nền hình tròn để trông đẹp hơn
                        color: const Color.fromARGB(
                            201, 255, 255, 255), // Nền trắng
                        borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.amber : Colors.amber,
                        size: 32,
                      ),
                      onPressed: () async {
                        final userInfo = await getUserInfo();
                        final maNguoiDung = userInfo['userId'];
                        final bidanh = widget.course['biDanh'];
                        // print(widget.course);
                        int maKhoaHoc = widget.course['id'];

                        try {
                          final result = await NguoiDungServices().luuKhoaHoc(
                            maNguoiDung: maNguoiDung ?? '',
                            maKhoaHoc: maKhoaHoc,
                          );

                          setState(() {
                            isSaved = !isSaved; // Cập nhật trạng thái
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isSaved
                                  ? 'Đã lưu khóa học!'
                                  : 'Đã xóa khóa học khỏi danh sách lưu!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi khi lưu khóa học: $e'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        // Thêm logic xử lý lưu/đã lưu, ví dụ: lưu vào database hoặc API
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(isSaved
                        //         ? 'Đã lưu khóa học!'
                        //         : 'Đã xóa khóa học khỏi danh sách lưu!'),
                        //     duration: Duration(seconds: 1),
                        //   ),
                        // );
                      },
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course['tenKhoaHoc'].length > 75
                        ? '${widget.course['tenKhoaHoc'].substring(0, 72)}...'
                        : widget.course['tenKhoaHoc'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    widget.course['moTa'].length > 35
                        ? widget.course['moTa'].substring(0, 32) + '...'
                        : widget.course['moTa'],
                    style: TextStyle(fontSize: 8),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.course['maPhanLoai'] == 'platium'
                          ? const Color.fromARGB(255, 186, 186, 186)
                          : widget.course['maPhanLoai'] == 'titan'
                              ? Colors.blue[300]
                              : widget.course['maPhanLoai'] == 'gold'
                                  ? Colors.amber[500]
                                  : Colors.green[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.course['maPhanLoai'] ?? 'silver',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
