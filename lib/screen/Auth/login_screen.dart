import 'package:app_cybersoft/services/auth/auth_services.dart';
import 'package:app_cybersoft/templates/main_template.dart';
import 'package:app_cybersoft/util/helper.dart';
import 'package:flutter/material.dart';
// import 'auth_service.dart'; // Import AuthService

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Biến để kiểm soát hiển thị mật khẩu

  String? _errorMessage;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập email và mật khẩu';
      });
      return;
    }

    final result = await AuthServices().login(email, password);

    if (result == null) {
      setState(() {
        _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại!';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thất bại!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        _errorMessage = null;
      });

      saveUserData(result['accessToken']!, result['id']!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainTemplate()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/eduzy-only.png',
                  height: width > 600 ? 150.0 : 100.0,
                ),
                SizedBox(height: 40.0),

                SizedBox(
                  width: width > 600 ? 400.0 : width * 0.8,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Trường nhập mật khẩu với khả năng hiển thị/ẩn
                SizedBox(
                  width: width > 600 ? 400.0 : width * 0.8,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // Điều chỉnh hiển thị mật khẩu
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width > 600 ? 200.0 : width * 0.8, 50),
                    backgroundColor: Colors.amber[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? ', style: TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed: () {
                        // Chuyển hướng đến trang đăng ký
                      },
                      child: Text('Register', style: TextStyle(color: Colors.amber[500])),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.mail),
                      label: Text('Google', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        iconColor: Colors.white,
                        minimumSize: Size(width > 600 ? 200.0 : width * 0.38, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.facebook),
                      label: Text('Facebook', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        iconColor: Colors.white,
                        minimumSize: Size(width > 600 ? 200.0 : width * 0.38, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
