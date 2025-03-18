import 'package:app_cybersoft/component/course.dart';
import 'package:app_cybersoft/provider/khoahoc/khoahoc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCoursesScreen extends StatefulWidget {
  @override
  _SearchCoursesScreenState createState() => _SearchCoursesScreenState();
}

class _SearchCoursesScreenState extends State<SearchCoursesScreen> {
  String? selectedCategory; // Giá trị của bộ lọc

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KhoaHocProvider>(context, listen: false)
          .fetchPopularCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KhoaHocProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: provider.searchCourses,
                    decoration: InputDecoration(
                      labelText: "Tìm kiếm khóa học",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Nút lọc với PopupMenu
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: Colors.black), // Icon lọc
                  onSelected: (value) {
                    setState(() {
                      selectedCategory = value == "Tất cả" ? null : value;
                      provider.filterByCategory(selectedCategory);
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: "Tất cả", child: Text("Tất cả")),
                    PopupMenuItem(value: "platium", child: Text("Platinum")),
                    PopupMenuItem(value: "titan", child: Text("Titan")),
                    PopupMenuItem(value: "gold", child: Text("Gold")),
                    PopupMenuItem(value: "silver", child: Text("Silver")),
                    // PopupMenuItem(value: "diamond", child: Text("Diamond")),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                    ? Center(child: Text(provider.errorMessage))
                    : provider.courses.isEmpty
                        ? Center(child: Text("Không có khóa học nào"))
                        : SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(10),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: provider.courses.length,
                              itemBuilder: (context, index) {
                                final course = provider.courses[index];
                                return SizedBox(
                                  child: CardCourse(course: course),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
