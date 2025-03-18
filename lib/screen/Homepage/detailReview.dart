import 'package:flutter/material.dart';

class ReviewDetailScreen extends StatelessWidget {
  final String courseName;
  final List<dynamic> allReviews;

  ReviewDetailScreen({required this.courseName, required this.allReviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          courseName,
          style: TextStyle(
            color: Colors.amber, // Màu chữ
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: allReviews.length,
        itemBuilder: (context, index) {
          var review = allReviews[index];
          int rating = review['rating'] ?? 0;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['hoTen'] ?? 'Người dùng ẩn danh',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      Icons.star,
                      color: i < rating ? Colors.amber : Colors.grey,
                      size: 16,
                    );
                  }),
                ),
                SizedBox(height: 4),
                Text(review['comment'] ?? 'Không có nội dung'),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
