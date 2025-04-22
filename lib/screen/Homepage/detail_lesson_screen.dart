import 'package:app_cybersoft/component/quizCarousel.dart';
import 'package:app_cybersoft/component/videoplayer.dart';
import 'package:app_cybersoft/screen/Homepage/detail_content_screen.dart';
import 'package:app_cybersoft/services/baihoc/baihoc-service.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DetailLessonScreen extends StatefulWidget {
  final String bidanh;
  final String tenBaiHoc;

  DetailLessonScreen({required this.bidanh, required this.tenBaiHoc});

  @override
  _DetailLessonScreenState createState() => _DetailLessonScreenState();
}

class _DetailLessonScreenState extends State<DetailLessonScreen> {
  late Future<Map<String, dynamic>> detailLesson;
  ScrollController _scrollController = ScrollController();
  VideoPlayerController? _videoPlayerController;
  bool _isMiniplayerVisible = false;
  String videoUrl = '';
  List<bool> expandedList = [];

  @override
  void initState() {
    super.initState();
    detailLesson = BaiHocServices().getBaiHocTheoBiDanh(widget.bidanh);

    _scrollController.addListener(() {
      if (_scrollController.offset > 200) {
        setState(() {
          _isMiniplayerVisible = true;
        });
      } else if (_scrollController.offset <= 200 && _isMiniplayerVisible) {
        setState(() {
          _isMiniplayerVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _scrollController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(70, 250, 239, 44),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tenBaiHoc,
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: detailLesson,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu!'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu!'));
          }

          var data = snapshot.data!;
          var originalList = data['danhSachNoiDung'] as List<dynamic>;
          List<Map<String, dynamic>> mergedContent = [];

          int i = 0;
          while (i < originalList.length) {
            if (originalList[i]['maLoai'] == 'TEXT') {
              String combinedText = originalList[i]['noiDung'];
              int j = i + 1;
              while (j < originalList.length &&
                  originalList[j]['maLoai'] == 'TEXT') {
                combinedText += '\n\n' + originalList[j]['noiDung'];
                j++;
              }
              mergedContent.add({
                'maLoai': 'TEXT',
                'noiDung': combinedText,
              });
              i = j;
            } else {
              mergedContent.add(originalList[i]);
              i++;
            }
          }

          var danhSachNoiDung = mergedContent;
          expandedList = List<bool>.filled(danhSachNoiDung.length, false);

          return ListView.builder(
            controller: _scrollController,
            itemCount: danhSachNoiDung.length,
            itemBuilder: (context, index) {
              var item = danhSachNoiDung[index];
              String title = '';
              IconData icon;

              switch (item['maLoai']) {
                case 'VIDEO':
                  title = 'Video bài học';
                  icon = Icons.play_circle_fill;
                  break;
                case 'QUIZ':
                  title = 'Quiz kiểm tra';
                  icon = Icons.quiz;
                  break;
                default:
                  title = 'Nội dung văn bản';
                  icon = Icons.text_snippet;
              }

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Icon(icon, color: Colors.amber),
                  title: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailContentScreen(item: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(dynamic item) {
    if (item['maLoai'] == 'VIDEO') {
      try {
        List<dynamic> videoList = jsonDecode(item['noiDung']);
        if (videoList.isNotEmpty && videoList.first['url'] != null) {
          String url = videoList.first['url'];
          return FutureBuilder<String>(
            future: BaiHocServices().getVideo(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Lỗi khi tải video");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Không có video để phát");
              }

              videoUrl = snapshot.data!;
              return VideoPlayerWidget(
                videoUrl: videoUrl,
                videoPlayerController: _videoPlayerController,
                isMiniplayer: false,
              );
            },
          );
        }
      } catch (e) {
        return Text('Lỗi khi xử lý video: $e');
      }
    } else if (item['maLoai'] == 'QUIZ') {
      try {
        String quizContent = item['noiDung'];
        return SizedBox(
          height: 600,
          child: QuizCarouselWidget(quizContent: quizContent),
        );
      } catch (e) {
        return Text('Lỗi khi hiển thị quiz: $e');
      }
    } else {
      String rawContent = item['noiDung'];
      if (rawContent.contains('<img')) {
        rawContent = convertImgTagToMarkdown(rawContent);
      }
      return MarkdownBody(
        data: rawContent,
        imageBuilder: (uri, title, alt) {
          return Image.network(uri.toString(), fit: BoxFit.contain);
        },
      );
    }
    return Text('Không thể hiển thị nội dung'); // Default return statement
  }
}
