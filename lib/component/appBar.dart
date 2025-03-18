import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(56.0);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isDialogVisible = false;

  List<Map<String, dynamic>> notifications = [
    {'id': 1, 'title': 'Bạn có khóa học mới!', 'isRead': false},
    {'id': 2, 'title': 'Lịch học của bạn đã cập nhật.', 'isRead': true},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _toggleDialog() {
    setState(() {
      _isDialogVisible = !_isDialogVisible;
      if (_isDialogVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _markAsRead(int id) {
    setState(() {
      for (var notification in notifications) {
        if (notification['id'] == id) {
          notification['isRead'] = true;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = notifications.where((n) => !n['isRead']).length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppBar(
          title: Image.asset('assets/images/eduzy-only.png', height: 40),
          automaticallyImplyLeading: false,
          actions: [
            badges.Badge(
              showBadge: unreadCount > 0,
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeContent: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_active),
                onPressed: _toggleDialog,
              ),
            ),
          ],
        ),

        // Hiển thị danh sách thông báo
        if (_isDialogVisible)
          Positioned(
            top: kToolbarHeight + 15,
            right: 35,
            child: Material(
              color: Colors.transparent,
              elevation: 10,
              child: SlideTransition(
                position: _animation,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông báo',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 8),

                      // Hiển thị danh sách thông báo
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          children: notifications.map((notification) {
                            return InkWell(
                              onTap: () {
                                _markAsRead(notification['id']);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    if (!notification['isRead'])
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        notification['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: notification['isRead']
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
