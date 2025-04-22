import 'package:app_cybersoft/screen/Auth/login_screen.dart';
import 'package:app_cybersoft/services/auth/auth_services.dart';
import 'package:app_cybersoft/templates/auth_template.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();

      await AuthServices().register(email, name);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AuthTemplate(title: 'Login', child: LoginScreen())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text(' ')),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
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
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Họ và tên',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Vui lòng nhập họ và tên'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _register,
                        child: const Text(
                          'Đăng Ký',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(width > 600 ? 200.0 : width * 0.8, 50),
                          backgroundColor: Colors.amber[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),

                                            Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ',
                              style: TextStyle(fontSize: 14)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthTemplate(
                                        title: 'Login', child: LoginScreen())),
                              );
                            },
                            child: Text('Login',
                                style: TextStyle(color: Colors.amber[500])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]))),
        ));
  }
}
