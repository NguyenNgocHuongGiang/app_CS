import 'package:app_cybersoft/screen/Homepage/detai_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';
// import 'package:app_cybersoft/screen/Homepage/detail_course_screen.dart';
import 'package:app_cybersoft/util/constants.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider =
          Provider.of<NguoiDungProvider>(context, listen: false);
      userProvider.fetchUserData();
      userProvider.fetchUserCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<NguoiDungProvider>(context);
    final userCourses = userProvider.userCourses;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Các khóa học của tôi",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: userCourses?.isEmpty ?? true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Bạn sẽ học gì đầu tiên?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Khóa học của bạn sẽ xuất hiện ở đây.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: userCourses?.length,
              itemBuilder: (context, index) {
                final course = userCourses?[index];
                print(course);
                final progress = (course?['phanTramHoanThanh'] ?? 0) / 10;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCourse(
                            bidanh: course?['biDanh'],
                            tenKhoaHoc: course?['tenKhoaHoc'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          // Vòng tròn tiến độ với hình ảnh khóa học bên trong
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.green,
                                  strokeWidth: 6,
                                ),
                              ),
                              ClipOval(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    '${Constants.IMAGE_URL}${course?['hinhAnh'] ?? ''}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 30,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Tên khóa học và thông tin khác
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course?['tenKhoaHoc'] ?? 'Không có tên',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tiến độ: ${(progress * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}