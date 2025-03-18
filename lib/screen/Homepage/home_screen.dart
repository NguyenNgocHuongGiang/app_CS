import 'package:app_cybersoft/component/course.dart';
import 'package:app_cybersoft/screen/Auth/login_screen.dart';
import 'package:app_cybersoft/templates/auth_template.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_cybersoft/services/baihoc/baihoc-service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> khoaHocFuture;
  late PageController _pageController;
  int _currentTabIndex = 0; // Quản lý chỉ số tab hiện tại
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    khoaHocFuture = BaiHocServices().getKhoaHocTheoSkill();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Handcrafted Courses for Developers.\nPersonalized by AI.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Build more reliable software with AI companion. AI is also trained to detect lazy developers who do nothing and just complain on Twitter.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      // color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
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
                        child: const Text(
                          "Get started",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Border radius 10
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          "Live demo",
                          style: TextStyle(color: Colors.amber),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.amber, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Border radius 10
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "New",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "FULL LOOP INTERVIEW",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "The shortest path to Coding and System Design interview prep",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.check, color: Colors.green, size: 16),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Skip the LeetCode grind with PAL (Personalized Adaptive Learning)",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: const [
                            Icon(Icons.check, color: Colors.green, size: 16),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Full-loop practice with AI Mock Interviews built into the curriculum",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Get Started",
                                  style: TextStyle(fontSize: 12)),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow, size: 16),
                              label: const Text("See how it works",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder<List<dynamic>>(
                    future: khoaHocFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Không có dữ liệu.'));
                      }

                      final khoaHocList = snapshot.data!;

                      // Lấy danh sách tiêu đề (tieuDe)
                      List<String> tieuDeList = khoaHocList
                          .map((item) => item['tieuDe'] as String)
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Wrap CarouselSlider trong Stack để thêm nút mũi tên
                          SizedBox(
                            height: 70,
                            child: Stack(
                              children: [
                                CarouselSlider.builder(
                                  carouselController: _carouselController,
                                  itemCount: tieuDeList.length,
                                  itemBuilder: (context, index, realIndex) {
                                    final tieuDe = tieuDeList[index];

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentTabIndex = index; // Cập nhật chỉ số tab khi nhấn
                                          _pageController.animateToPage(
                                            _currentTabIndex,
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Center(
                                          child: Text(
                                            tieuDe,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 100.0,
                                    viewportFraction: 0.3,
                                    enableInfiniteScroll: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentTabIndex = index;
                                      });
                                    },
                                  ),
                                ),
                                // Nút mũi tên bên trái
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios, size: 12),
                                      onPressed: () {
                                        _carouselController.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Nút mũi tên bên phải
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward_ios, size: 12),
                                      onPressed: () {
                                        _carouselController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Phần hiển thị nội dung dựa vào tab đang chọn
                          SizedBox(
                            height: 400, // Đặt chiều cao cố định cho PageView
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: khoaHocList.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentTabIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final item = khoaHocList[index];
                                final List<dynamic> khoaHocDetails = item['danhSachKhoaHoc'] ?? [];

                                return ListView.builder(
                                  itemCount: (khoaHocDetails.length / 2).ceil(),
                                  itemBuilder: (context, index) {
                                    final detail1 = khoaHocDetails[index * 2];
                                    final detail2 = index * 2 + 1 < khoaHocDetails.length
                                        ? khoaHocDetails[index * 2 + 1]
                                        : null;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 220,
                                              child: CardCourse(course: detail1),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: detail2 != null
                                                ? SizedBox(
                                                    height: 220,
                                                    child: CardCourse(course: detail2),
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
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
