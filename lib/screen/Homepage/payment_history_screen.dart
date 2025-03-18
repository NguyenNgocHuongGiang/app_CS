import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_cybersoft/provider/nguoidung/nguoidung_provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider =
          Provider.of<NguoiDungProvider>(context, listen: false);
    });
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
        //   paymentHistory.isEmpty
        //       ? const Center(
        //           child: Text("Bạn chưa có giao dịch nào."),
        //         )
        //       : ListView.builder(
        //           padding: const EdgeInsets.all(10),
        //           itemCount: paymentHistory.length,
        //           itemBuilder: (context, index) {
        //             final transaction = paymentHistory[index];
        //             return Card(
        //               elevation: 3,
        //               margin: const EdgeInsets.symmetric(vertical: 8),
        //               child: ListTile(
        //                 leading: const Icon(Icons.payment, color: Colors.green),
        //                 title: Text("Giao dịch #${transaction['id']}"),
        //                 subtitle: Text("Ngày: ${transaction['date']} - Số tiền: ${transaction['amount']}"),
        //                 trailing: Text(transaction['status'],
        //                     style: TextStyle(
        //                         color: transaction['status'] == 'Thành công' ? Colors.green : Colors.red,
        //                         fontWeight: FontWeight.bold)),
        //               ),
        //             );
        //           },
        //         ),
        );
  }
}
