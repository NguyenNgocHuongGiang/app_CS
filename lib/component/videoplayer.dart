// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:http/http.dart' as http;

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isVideoInitialized = false;
//   String? _errorMessage;
//   String? _mimeType;
//   int _retryCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     try {
//       print("🔗 Kiểm tra URL: ${widget.videoUrl}");

//       // Kiểm tra URL có hợp lệ không
//       if (widget.videoUrl.isEmpty || !Uri.parse(widget.videoUrl).isAbsolute) {
//         throw Exception("URL video không hợp lệ");
//       }

//       // Kiểm tra trạng thái HTTP và MIME Type
//       final response = await http.head(Uri.parse(widget.videoUrl));
//       print("📡 Trạng thái HTTP: ${response.statusCode}");

//       // Xử lý mã trạng thái HTTP
//       if (response.statusCode == 404) {
//         throw Exception("Video không tồn tại (404).");
//       } else if (response.statusCode == 403) {
//         throw Exception(
//             "Truy cập bị từ chối (403). Vui lòng kiểm tra quyền truy cập.");
//       } else if (response.statusCode != 200) {
//         throw Exception("Lỗi server: ${response.statusCode}");
//       }

//       // Kiểm tra MIME Type
//       String? contentType = response.headers['content-type'];
//       print("📌 MIME Type: $contentType");

//       if (mounted) {
//         setState(() {
//           _mimeType = contentType;
//         });
//       }

//       // Nếu không phải video hoặc HLS, báo lỗi
//       if (contentType == null ||
//           (!contentType.startsWith("video/") &&
//               !contentType.contains("application/x-mpegURL") &&
//               !contentType.contains("application/vnd.apple.mpegurl"))) {
//         throw Exception("Không phải định dạng video hợp lệ");
//       }

//       // Khởi tạo VideoPlayerController
//       _videoPlayerController = VideoPlayerController.networkUrl(
//         Uri.parse(widget.videoUrl),
//         formatHint: VideoFormat.hls, // Chỉ dùng nếu chắc chắn video là HLS
//         httpHeaders: {
//           'User-Agent': 'app_cybersoft/1.0',
//         },
//         videoPlayerOptions: VideoPlayerOptions(
//           mixWithOthers: true,
//           allowBackgroundPlayback: false,
//         ),
//       );

//       print("⏳ Đang khởi tạo video...");
//       await _videoPlayerController.initialize();
//       print(
//           "✅ Video đã khởi tạo thành công: ${_videoPlayerController.value.isInitialized}");

//       if (mounted) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController,
//             aspectRatio: _videoPlayerController.value.aspectRatio,
//             autoPlay: false,
//             looping: false,
//             showControls: true,
//           );
//           _isVideoInitialized = true;
//         });
//       }
//     } catch (e) {
//       print("❌ Lỗi khi tải video: $e");

//       if (mounted) {
//         setState(() {
//           _errorMessage = e.toString();
//           _isVideoInitialized = false;
//         });

//         // Chỉ thử lại nếu lỗi không phải do URL không tồn tại (404)
//         if (_retryCount < 3 && !e.toString().contains("404")) {
//           _retryCount++;
//           print("🔄 Thử lại lần $_retryCount...");
//           Future.delayed(const Duration(seconds: 2), () {
//             _initializeVideo();
//           });
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _chewieController?.dispose();
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_mimeType != null) const SizedBox(height: 10),
//             _errorMessage != null
//                 ? Column(
//                     children: [
//                       Text(_errorMessage!,
//                           style: const TextStyle(color: Colors.red)),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _errorMessage = null;
//                             _retryCount = 0;
//                           });
//                           _initializeVideo();
//                         },
//                         child: const Text("Thử lại"),
//                       ),
//                     ],
//                   )
//                 : _isVideoInitialized && _chewieController != null
//                     ? AspectRatio(
//                         aspectRatio: _videoPlayerController.value.aspectRatio,
//                         child: Chewie(controller: _chewieController!),
//                       )
//                     : const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VideoPlayerController?
      videoPlayerController; // Truyền controller từ ngoài
  final bool isMiniplayer; // Xác định chế độ miniplayer hay toàn màn hình
  final VoidCallback? onExpand; // Callback khi mở rộng miniplayer
  final VoidCallback? onClose; // Callback khi đóng miniplayer

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.videoPlayerController,
    this.isMiniplayer = false,
    this.onExpand,
    this.onClose,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  String? _errorMessage;
  String? _mimeType;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      print("🔗 Kiểm tra URL: ${widget.videoUrl}");

      // Kiểm tra URL có hợp lệ không
      if (widget.videoUrl.isEmpty || !Uri.parse(widget.videoUrl).isAbsolute) {
        throw Exception("URL video không hợp lệ");
      }

      // Kiểm tra trạng thái HTTP và MIME Type
      final response = await http.head(Uri.parse(widget.videoUrl));
      print("📡 Trạng thái HTTP: ${response.statusCode}");

      // Xử lý mã trạng thái HTTP
      if (response.statusCode == 404) {
        throw Exception("Video không tồn tại (404).");
      } else if (response.statusCode == 403) {
        throw Exception(
            "Truy cập bị từ chối (403). Vui lòng kiểm tra quyền truy cập.");
      } else if (response.statusCode != 200) {
        throw Exception("Lỗi server: ${response.statusCode}");
      }

      // Kiểm tra MIME Type
      String? contentType = response.headers['content-type'];
      print("📌 MIME Type: $contentType");

      if (mounted) {
        setState(() {
          _mimeType = contentType;
        });
      }

      // Nếu không phải video hoặc HLS, báo lỗi
      if (contentType == null ||
          (!contentType.startsWith("video/") &&
              !contentType.contains("application/x-mpegURL") &&
              !contentType.contains("application/vnd.apple.mpegurl"))) {
        throw Exception("Không phải định dạng video hợp lệ");
      }

      // Sử dụng controller từ bên ngoài nếu có, nếu không thì khởi tạo mới
      _videoPlayerController = widget.videoPlayerController ??
          VideoPlayerController.networkUrl(
            Uri.parse(widget.videoUrl),
            formatHint: VideoFormat.hls,
            httpHeaders: {
              'User-Agent': 'app_cybersoft/1.0',
            },
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: false,
            ),
          );

      print("⏳ Đang khởi tạo video...");
      await _videoPlayerController.initialize();
      print(
          "✅ Video đã khởi tạo thành công: ${_videoPlayerController.value.isInitialized}");

      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: false,
            looping: false,
            showControls: true, // Luôn bật controls // Bình thường hiển thị full controls
          );
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print("❌ Lỗi khi tải video: $e");

      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isVideoInitialized = false;
        });

        // Chỉ thử lại nếu lỗi không phải do URL không tồn tại (404)
        if (_retryCount < 3 && !e.toString().contains("404")) {
          _retryCount++;
          print("🔄 Thử lại lần $_retryCount...");
          Future.delayed(const Duration(seconds: 2), () {
            _initializeVideo();
          });
        }
      }
    }
  }

  @override
  void dispose() {
    // Chỉ dispose ChewieController, không dispose VideoPlayerController nếu được truyền từ ngoài
    _chewieController?.dispose();
    if (widget.videoPlayerController == null) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMiniplayer ? _buildMiniplayer() : _buildFullScreenPlayer();
  }

  // Giao diện cho chế độ miniplayer
  Widget _buildMiniplayer() {
    return Positioned(
      bottom: 30,
      right: 20,
      child: Container(
        width: 200, // Đặt kích thước miniplayer
        height: 112, // Set a default height for the miniplayer
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _isVideoInitialized && _chewieController != null
              ? Chewie(controller: _chewieController!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

// Giao diện cho chế độ toàn màn hình
  Widget _buildFullScreenPlayer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_errorMessage != null)
            Column(
              children: [
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                      _retryCount = 0;
                    });
                    _initializeVideo();
                  },
                  child: const Text("Thử lại"),
                ),
              ],
            )
          else if (_isVideoInitialized && _chewieController != null)
            AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(controller: _chewieController!),
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

