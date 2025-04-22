import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String courseName;
  final String courseLink; // Link của khóa học

  ShareButton({required this.courseName, required this.courseLink});

  void _shareCourse(BuildContext context) {
    final String message = '$courseName \n https://eduzy.io/en/course/$courseLink';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _shareCourse(context),
      icon: Icon(Icons.share, color: Colors.white),
      label: Text('Chia sẻ'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}
