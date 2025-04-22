import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:app_cybersoft/services/baihoc/baihoc-service.dart';
import 'package:app_cybersoft/component/quizCarousel.dart';
import 'package:app_cybersoft/component/videoplayer.dart';
import 'dart:convert';

class DetailContentScreen extends StatefulWidget {
  final dynamic item;

  DetailContentScreen({required this.item});

  @override
  State<DetailContentScreen> createState() => _DetailContentScreenState();
}

class _DetailContentScreenState extends State<DetailContentScreen> {
  List<String> sections = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.item['maLoai'] == 'TEXT') {
      String rawContent = widget.item['noiDung'];
      if (rawContent.contains('<img')) {
        rawContent = convertImgTagToMarkdown(rawContent);
      }
      sections = rawContent.split(RegExp(r'\n(?=#)')); // Tách theo các tiêu đề
    }
  }

  String convertImgTagToMarkdown(String rawContent) {
    final regex = RegExp(r'<img\s+[^>]*src="([^"]+)"[^>]*>');
    return rawContent.replaceAllMapped(regex, (match) {
      final src = match.group(1) ?? "";
      return '![]($src)';
    });
  }

 @override
Widget build(BuildContext context) {
  Widget content = SizedBox.shrink(); // default

  if (widget.item['maLoai'] == 'VIDEO') {
    try {
      List<dynamic> videoList = jsonDecode(widget.item['noiDung']);
      if (videoList.isNotEmpty && videoList.first['url'] != null) {
        String url = videoList.first['url'];
        content = FutureBuilder<String>(
          future: BaiHocServices().getVideo(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi khi tải video'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có video để phát'));
            }
            return VideoPlayerWidget(
              videoUrl: snapshot.data!,
              videoPlayerController: null,
              isMiniplayer: false,
            );
          },
        );
      }
    } catch (e) {
      content = Text('Lỗi khi xử lý video: $e');
    }
  } else if (widget.item['maLoai'] == 'QUIZ') {
    content = QuizCarouselWidget(quizContent: widget.item['noiDung']);
  } else {
    // Nếu là TEXT
    content = Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: sections[currentIndex],
              imageBuilder: (uri, title, alt) {
                return Image.network(uri.toString(), fit: BoxFit.contain);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentIndex > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentIndex--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Trước'),
                )
              else
                SizedBox(width: 100),
              Text(
                '${currentIndex + 1}/${sections.length}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (currentIndex < sections.length - 1)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentIndex++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Tiếp'),
                )
              else
                SizedBox(width: 100),
            ],
          ),
        ),
      ],
    );
  }

  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.flag),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Báo cáo nội dung'),
                  content: Text('Bạn có muốn báo cáo nội dung này không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Huỷ'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã gửi báo cáo')),
                        );
                      },
                      child: Text('Báo cáo'),
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    ),
    body: Column(
      children: [
        if (widget.item['maLoai'] == 'TEXT')
          LinearProgressIndicator(
            value: (currentIndex + 1) / sections.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 6,
          ),
        Expanded(child: content),
      ],
    ),
  );
}

}
