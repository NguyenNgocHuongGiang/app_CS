import 'package:app_cybersoft/screen/Homepage/detai_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';
import 'package:app_cybersoft/util/constants.dart';
import 'package:intl/intl.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String formatCurrency(double price) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return format.format(price);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider =
          Provider.of<NguoiDungProvider>(context, listen: false);
      userProvider.fetchUserSaveCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<NguoiDungProvider>(context);
    final saveCourses = userProvider.saveCourses;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Các khóa học đã lưu",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: saveCourses?.isEmpty ?? true
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
                    "Bạn có muốn lưu điều gì để dành cho sau này không ?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Danh sách mong ước của bạn sẽ bắt đầu tại đây.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: saveCourses?.length,
              itemBuilder: (context, index) {
                final course = saveCourses?[index]['khoaHoc'];
                final price = course?['price'] ?? 0;
                return InkWell(
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
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            '${Constants.IMAGE_URL}${course?['hinhAnh'] ?? ''}',
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 30,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
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
                                '${price == 0 ? 'Miễn phí' : formatCurrency(price.toDouble())}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
