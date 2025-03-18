import 'package:app_cybersoft/screen/Homepage/detailReview.dart';
import 'package:flutter/material.dart';
// import 'review_detail_screen.dart'; // Import màn hình chi tiết

class ReviewList extends StatefulWidget {
  final Future<List<dynamic>> futureReviews;
  final String courseName;

  ReviewList({required this.futureReviews, required this.courseName});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  int displayedReviews = 3;
  TextEditingController _commentController = TextEditingController();
  int _selectedRating = 5;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Không có đánh giá nào!"));
        }

        List<dynamic> reviews = snapshot.data!;
        bool hasMoreReviews = reviews.length > displayedReviews;
        reviews.sort((a, b) {
          DateTime timeA = DateTime.parse(a['ngayTao']);
          DateTime timeB = DateTime.parse(b['ngayTao']);
          return timeB.compareTo(timeA);
        });

        double totalRating =
            reviews.fold(0, (sum, review) => sum + (review['rating'] ?? 0));
        double averageRating =
            reviews.isNotEmpty ? totalRating / reviews.length : 0;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8), // Tạo khoảng cách giữa số và chữ
                Text(
                  "xếp hạng khóa học",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
              ],
            ),

            SizedBox(height: 16), // Khoảng cách
            _buildRatingDistribution(
                reviews), // Gọi hàm hiển thị biểu đồ đánh giá
            SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: displayedReviews > reviews.length
                  ? reviews.length
                  : displayedReviews,
              itemBuilder: (context, index) {
                var review = reviews[index];
                int rating = review['rating'] ?? 0;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review['hoTen'] ?? 'Người dùng ẩn danh',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_horiz, color: Colors.grey),
                            onPressed: () {},
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
                      SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),

            // Nút "Xem thêm"
            if (hasMoreReviews)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewDetailScreen(
                        courseName: widget.courseName,
                        allReviews: reviews,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Xem thêm",
                  style: TextStyle(color: Colors.amber),
                ),
              ),

            // Divider(),
          ],
        );
      },
    );
  }
}

Widget _buildRatingDistribution(List<dynamic> reviews) {
  // Đếm số lượng đánh giá theo từng mức sao
  Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  for (var review in reviews) {
    int rating = review['rating'] ?? 0;
    if (ratingCounts.containsKey(rating)) {
      ratingCounts[rating] = ratingCounts[rating]! + 1;
    }
  }

  int totalReviews = reviews.length;

  return Column(
    children: List.generate(5, (index) {
      int star = 5 - index;
      double percentage =
          totalReviews > 0 ? (ratingCounts[star]! / totalReviews) * 100 : 0.0;

      return Row(
        children: [
          Text(
            "$star ★",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[500],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 10,
            ),
          ),
          SizedBox(width: 8),
          Text(
            "${percentage.toStringAsFixed(0)}%",
            style: TextStyle(fontSize: 14, color: Colors.amber),
          ),
        ],
      );
    }),
  );
}
