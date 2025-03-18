import 'package:flutter/material.dart';

class AuthTemplate extends StatelessWidget {
  final String title;
  final Widget child;

  const AuthTemplate({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
