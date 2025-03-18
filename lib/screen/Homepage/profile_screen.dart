import 'package:app_cybersoft/provider/language/language_provider.dart';
import 'package:app_cybersoft/screen/Homepage/payment_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';
import 'package:app_cybersoft/provider/theme/theme_provider.dart';
import 'package:app_cybersoft/screen/Auth/login_screen.dart';
import 'package:app_cybersoft/services/auth/auth_services.dart';
import 'package:app_cybersoft/templates/auth_template.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider =
          Provider.of<NguoiDungProvider>(context, listen: false);
      userProvider.fetchUserData();
      userProvider.fetchUserCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final userProvider = Provider.of<NguoiDungProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      body: Center(
        child: user == null
            ? _buildLoginPrompt(context)
            : _buildUserProfile(context, user, themeProvider, userProvider),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 50, color: Colors.amber),
              const SizedBox(height: 10),
              const Text(
                "Bạn cần đăng nhập để xem thông tin cá nhân!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AuthTemplate(title: 'Login', child: LoginScreen())),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  "Đăng nhập ngay",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, dynamic user,
      ThemeProvider themeProvider, NguoiDungProvider userProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user['avatar'] ??
                'https://icons.veryicon.com/png/o/miscellaneous/user-avatar/user-avatar-male-5.png'),
          ),
          const SizedBox(height: 10),
          Text(
            user['hoTen'] ?? "Không có tên",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Email
          Text(
            user['email'] ?? "Không có email",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Danh sách tùy chọn dưới email
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.purple),
                  title: const Text("Lịch sử thanh toán"),
                  onTap: () {
                    // Xử lý hiển thị lịch sử thanh toán
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentHistoryScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: Colors.blue),
                  title: const Text("Chuyển đổi giao diện"),
                  onTap: () => themeProvider.toggleTheme(),
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.green),
                  title: const Text("Chuyển đổi ngôn ngữ"),
                  onTap: () {
                    // Xử lý chuyển đổi ngôn ngữ
                    showLanguageSelectionDialog(context);
                  },
                ),
                
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.orange),
                  title: const Text("Giới thiệu về Eduzy"),
                  onTap: () {
                    // Mở trang giới thiệu
                    showAboutDialog(
                      context: context,
                      applicationName: "Eduzy",
                      applicationVersion: "1.0.0",
                      applicationIcon: const Icon(Icons.school),
                      children: [
                        const Text("Eduzy là nền tảng giáo dục trực tuyến."),
                      ],
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    user == null ? Icons.login : Icons.logout,
                    color: user == null ? Colors.green : Colors.red,
                  ),
                  title: Text(user == null ? "Đăng nhập" : "Đăng xuất"),
                  onTap: () {
                    if (user == null) {
                      // Chuyển đến màn hình đăng nhập
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthTemplate(
                              title: 'Login', child: LoginScreen()),
                        ),
                      );
                    } else {
                      // Xử lý đăng xuất
                      AuthServices().logoutUser(context);
                      userProvider.clearUser();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showLanguageSelectionDialog(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chọn ngôn ngữ"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("Tiếng Việt"),
                onTap: () {
                  languageProvider.changeLanguage(const Locale('vi', ''));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("English"),
                onTap: () {
                  languageProvider.changeLanguage(const Locale('en', ''));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}