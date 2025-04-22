import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(70, 250, 239, 44), 
        elevation: 0, 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber), 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Lịch sử thanh toán',
          style: TextStyle(
            color: Colors.amber, // Màu chữ
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
        body: Text("payment history")
        );
  }
}
