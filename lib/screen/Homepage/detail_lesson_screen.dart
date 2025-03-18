// import 'package:app_cybersoft/component/quizCarousel.dart';
// import 'package:app_cybersoft/component/videoplayer.dart';
// import 'package:app_cybersoft/services/baihoc/baihoc-service.dart';
// import 'dart:convert';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class DetailLessonScreen extends StatefulWidget {
//   final String bidanh;

//   DetailLessonScreen({required this.bidanh});

//   @override
//   _DetailLessonScreenState createState() => _DetailLessonScreenState();
// }

// class _DetailLessonScreenState extends State<DetailLessonScreen> {
//   late Future<Map<String, dynamic>> detailLesson;
//    ScrollController _scrollController = ScrollController();
//    VideoPlayerController? _videoPlayerController;
//    bool _isMiniplayerVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     detailLesson = BaiHocServices().getBaiHocTheoBiDanh(widget.bidanh);

//     _scrollController.addListener(() {
//       if (_scrollController.offset > 200 && !_isMiniplayerVisible) {
//         // Khi cuộn xuống quá 200px, hiển thị miniplayer
//         setState(() {
//           _isMiniplayerVisible = true;
//         });
//       } else if (_scrollController.offset <= 200 && _isMiniplayerVisible) {
//         // Khi cuộn lên trên, ẩn miniplayer
//         setState(() {
//           _isMiniplayerVisible = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   String convertImgTagToMarkdown(String rawContent) {
//     final regex = RegExp(r'<img\s+[^>]*src="([^"]+)"[^>]*>');
//     return rawContent.replaceAllMapped(regex, (match) {
//       final src = match.group(1) ?? "";
//       return '![]($src)';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor:
//             const Color.fromARGB(70, 250, 239, 44),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.amber),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Stack(
//       children: [FutureBuilder<Map<String, dynamic>>(
//         future: detailLesson,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Lỗi khi tải dữ liệu!'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Không có dữ liệu!'));
//           }

//           var data = snapshot.data!;
//           var danhSachNoiDung = data['danhSachNoiDung'] as List<dynamic>;
//           Widget? videoWidget;
//           List<Widget> contentWidgets = [];

//           for (var item in danhSachNoiDung) {
//             if (item['maLoai'] == "VIDEO") {
//               try {
//                 List<dynamic> videoList = jsonDecode(item['noiDung']);
//                 if (videoList.isNotEmpty) {
//                   var videoItem = videoList.first;
//                   if (videoItem is Map && videoItem.containsKey('url')) {
//                     String url = videoItem['url'];
//                     videoWidget = FutureBuilder<String>(
//                       future: BaiHocServices().getVideo(url),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return Center(child: Text("Lỗi khi tải video"));
//                         } else if (!snapshot.hasData ||
//                             snapshot.data!.isEmpty) {
//                           return Center(child: Text("Không có video để phát"));
//                         }
//                         return ConstrainedBox(
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width,
//                             maxHeight: MediaQuery.of(context).size.height * 0.3,
//                           ),
//                           child: VideoPlayerWidget(videoUrl: snapshot.data!,
//                               videoPlayerController: _videoPlayerController,
//                               isMiniplayer: false, // Chế độ toàn màn hình
//                               ),
//                         );
//                       },
//                     );
//                   }
//                 }
//               } catch (e) {
//                 videoWidget = Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 8.0, horizontal: 16.0),
//                   child: Text('Lỗi khi xử lý video: $e'),
//                 );
//               }
//             } else if (item['maLoai'] == "QUIZ") {
//               String quizContent = item['noiDung'];
//               List<dynamic> quizData = jsonDecode(quizContent);
//               if (quizData.isNotEmpty) {
//                 contentWidgets.add(SizedBox(
//                   height: 700,
//                   child: QuizCarouselWidget(quizContent: quizContent),
//                 ));
//               }
//             } else {
//               String rawContent = item['noiDung'];
//               if (rawContent.contains('<img')) {
//                 rawContent = convertImgTagToMarkdown(rawContent);
//               }
//               contentWidgets.add(Padding(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 30.0, horizontal: 16.0),
//                 child: MarkdownBody(
//                   data: rawContent,
//                   imageBuilder: (uri, title, alt) {
//                     return Image.network(uri.toString(), fit: BoxFit.contain);
//                   },
//                 ),
//               ));
//             }
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 color: Colors.brown[900],
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//                 child: Text(
//                   data['tenBaiHoc'],
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.amber[300],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               if (!_isMiniplayerVisible && videoWidget != null) videoWidget!,
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: contentWidgets,
//                 ),
//               ),
//               // Hiển thị miniplayer khi cuộn
//         if (_isMiniplayerVisible && _videoPlayerController != null)
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: SizedBox(
//               width: 200, // Kích thước miniplayer
//               height: 112, // Tỷ lệ 16:9
//               child: VideoPlayerWidget(
//                 videoUrl: '', // Không cần URL vì đã có controller
//                 videoPlayerController: _videoPlayerController,
//                 isMiniplayer: true,
//                 onExpand: () {
//                   // Khi nhấn vào miniplayer, cuộn lên trên để hiển thị video full-screen
//                   _scrollController.animateTo(
//                     0,
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                   );
//                 },
//                 onClose: () {
//                   // Khi nhấn nút đóng, dừng video và ẩn miniplayer
//                   setState(() {
//                     _isMiniplayerVisible = false;
//                     _videoPlayerController?.pause();
//                   });
//                 },
//               ),
//             ),
//           ),
//             ],
//           );
//         },
//       ),
//     ],
//   ),
// );
//   }
// }

import 'package:app_cybersoft/component/quizCarousel.dart';
import 'package:app_cybersoft/component/videoplayer.dart';
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

  GlobalKey videoKey = GlobalKey();

  String videoUrl = '';

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
            color: Colors.amber, // Màu chữ
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
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
              var danhSachNoiDung = data['danhSachNoiDung'] as List<dynamic>;
              Widget? videoWidget;
              List<Widget> contentWidgets = [];

              for (var item in danhSachNoiDung) {
                if (item['maLoai'] == "VIDEO") {
                  try {
                    List<dynamic> videoList = jsonDecode(item['noiDung']);
                    if (videoList.isNotEmpty) {
                      var videoItem = videoList.first;
                      if (videoItem is Map && videoItem.containsKey('url')) {
                        String url = videoItem['url'];
                        videoWidget = FutureBuilder<String>(
                          future: BaiHocServices().getVideo(url),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text("Lỗi khi tải video"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text("Không có video để phát"));
                            }

                            videoUrl = snapshot.data as String;

                            // Hiển thị video
                            Widget videoPlayer = VideoPlayerWidget(
                              videoUrl: videoUrl,
                              videoPlayerController: _videoPlayerController,
                              isMiniplayer: _isMiniplayerVisible,
                            );

                            // Nếu **_isMiniplayerVisible == false**, hiển thị video trong danh sách nội dung
                            if (!_isMiniplayerVisible) {
                              contentWidgets.add(videoPlayer);
                            }

                            return videoPlayer;
                          },
                        );
                      }
                    }
                  } catch (e) {
                    videoWidget = Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text('Lỗi khi xử lý video: $e'),
                    );
                  }
                } else if (item['maLoai'] == "QUIZ") {
                  String quizContent = item['noiDung'];
                  List<dynamic> quizData = jsonDecode(quizContent);
                  if (quizData.isNotEmpty) {
                    contentWidgets.add(SizedBox(
                      height: 700,
                      child: QuizCarouselWidget(quizContent: quizContent),
                    ));
                  }
                } else {
                  String rawContent = item['noiDung'];
                  if (rawContent.contains('<img')) {
                    rawContent = convertImgTagToMarkdown(rawContent);
                  }
                  contentWidgets.add(Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: MarkdownBody(
                      data: rawContent,
                      imageBuilder: (uri, title, alt) {
                        return Image.network(uri.toString(),
                            fit: BoxFit.contain);
                      },
                    ),
                  ));
                }
              }

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   color: Colors.brown[900],
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: 16.0, horizontal: 16.0),
                    //   child: Text(
                    //     data['tenBaiHoc'],
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.amber[300],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 8),

                    // Nếu `_isMiniplayerVisible == false`, video hiển thị bình thường
                    if (!_isMiniplayerVisible && videoWidget != null)
                      videoWidget!,

                    ...contentWidgets,
                  ],
                ),
              );
            },
          ),

          // MiniPlayer ở góc phải khi cuộn xuống
          if (_isMiniplayerVisible)
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  // Khi nhấn vào mini player, cuộn lên đầu trang và mở full màn hình
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 210,
                  height: 118,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: VideoPlayerWidget(
                        videoUrl: videoUrl,
                        videoPlayerController: _videoPlayerController,
                        isMiniplayer: _isMiniplayerVisible,
                      )),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

