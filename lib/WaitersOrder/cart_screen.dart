// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_app_development/WaitersOrder/OrderScreen.dart';
import 'package:ts_app_development/WaitersOrder/orderscart.dart';

class Cart extends StatefulWidget {
  const Cart(
      {Key? key,
      required this.tableNo,
      required this.saleInvoiceId,
      required this.noOfPerson})
      : super(key: key);

  final String tableNo;
  final String saleInvoiceId;
  final String noOfPerson;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        // leading: BackButton(onPressed: (){
        //   Get.to(OrdersPage(title: '', tableNo: widget.tableNo, saleInvoiceNo: widget.saleInvoiceId, noOfPerson: widget.noOfPerson));
        // },),
      ),
      body: CartProducts(
          tableNo: widget.tableNo,
          saleInvoiceNo: widget.saleInvoiceId,
          noOfPerson: widget.noOfPerson),
    );
  }
}
