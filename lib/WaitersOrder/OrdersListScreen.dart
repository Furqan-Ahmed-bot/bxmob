// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/ApiResponse/ApiResponse.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderListDataModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/StarterData.dart';
import 'package:ts_app_development/DataLayer/Providers/ThemeProvider/themeProvider.dart';
import 'package:ts_app_development/DataLayer/Services/genericService.dart';
import 'package:ts_app_development/Generic/APIConstant/apiConstant.dart';
import 'package:ts_app_development/UserControls/MasterWidget/ConfirmOrderDetailWidget.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/UserControls/PopUpDialog/popupDialog.dart';

import '../UserControls/PageRouteBuilder/pageRouteBuilder.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  //final CartController controller = Get.find();

  List<OrderListDataModel>? orderListData;
  List<OrderListDataModel>? orderListDataUpdated;

  String? dateTimeFormat;

  Future<void> fetchOrderListData() async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';

    Map<String, dynamic> userMap = jsonDecode(user);

    String username = 'E00103013';
    String password = 'a';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    String url =
        '${prefs.getString('LocalApiUrl')}/TSBE/EStore/Order/SalesmanOrderStatus';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Authorization': 'Basic dGVjaG5vc3lzOlRlY2g3MTA=',
        //'Authorization': basicAuth,
        // "UserId": "${userMap['UserId']}",
        // "token": "${userMap['GUID']}",
        // "Content-type" : 'application/json',
        //'TS-AppKey':'foodsinn',
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      orderListData = jsonDecode(response.body)
          .map((item) => OrderListDataModel.fromJson(item))
          .toList()
          .cast<OrderListDataModel>();

      print(orderListData!.length);

      setState(() {
        orderListDataUpdated = orderListData;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchOrderListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (orderListDataUpdated == null) {
      return PopUpDialog(
        title: 'Awaiting Result',
        content: IntrinsicHeight(
          child: Column(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        onPressYes: () => {},
        isAction: false,
        isCloseBtn: false,
        isHeader: false,
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacement(
              context, CustomPageRouteBuilder.createRoute('/HandheldOrder'));
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                // itemCount: controller.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderListDataUpdated!.length,
                itemBuilder: (BuildContext context, int index) {
                  String invoiceDate =
                      orderListDataUpdated![index].invoiceDate!;
                  DateTime now = DateTime.parse(invoiceDate);
                  dateTimeFormat = DateFormat('dd-MMM-yyyy h:mm a').format(now);

                  return InkWell(
                    onTap: () {
                      Get.to(ConfirmOrderWidget(
                        saleInvoiceId: orderListDataUpdated![index]
                            .saleInvoiceId
                            .toString(),
                        tableNo: orderListDataUpdated![index].tableName!,
                        noOfPerson: '',
                        totalAmount:
                            orderListDataUpdated![index].netAmount.toString(),
                      ));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // height: 110,
                            color: Color(0xFFFFFFFF),
                            child: Column(children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.table_bar_outlined,
                                    color: Color(0xFFb54f40),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      'Table Number: ' +
                                          orderListDataUpdated![index]
                                              .tableName!,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.list_alt,
                                    color: Color(0xFFb54f40),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      'Order Number: ' +
                                          orderListDataUpdated![index]
                                              .tokenNumber
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.date_range,
                                    color: Color(0xFFb54f40),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      dateTimeFormat!,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        Text('Net Amount'),
                                        Text(orderListDataUpdated![index]
                                            .netAmount
                                            .toString())
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

            // SizedBox(height: 40,),
            // Text('Order Detail',style: TextStyle(color: Colors.black,fontSize: 24),textAlign: TextAlign.center,),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// class OrderListCard extends StatefulWidget {
//   // final CartController controller;
//   // final StarterData product;
//   // final int quantity;
//   // final int index;
//   const OrderListCard({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<OrderListCard> createState() => _OrderListCardState();
// }
//
// class _OrderListCardState extends State<OrderListCard> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('dd-EEE-yyyy h:mm a').format(now);
//
//     return InkWell(
//       onTap: (){
//         Get.to(ConfirmOrderWidget());
//       },
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: 100,
//               color: Color(0xFFFFFFFF),
//               child: Column(children: [
//                 SizedBox(height: 10,),
//                 Row(
//                   children: [
//                     SizedBox(width: 10,),
//                     Icon(Icons.list_alt , color: Color(0xFFb54f40),),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 2),
//                       child: Text(
//                         'Order No: 1234',
//                         style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(width: 10,),
//                     Icon(Icons.table_bar_outlined , color: Color(0xFFb54f40),),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 3),
//                       child: Text(
//                         'Table No: 210',
//                         style: TextStyle(color: Colors.black, fontSize: 18),
//                       ),
//                     ),
//
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(width: 10,),
//                     Icon(Icons.date_range , color: Color(0xFFb54f40),),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 3),
//                       child: Text(
//                         '${DateTime.now()}',
//                         style: TextStyle(color: Colors.black, fontSize: 15),
//                       ),
//                     ),
//                   ],
//                 ),
//               ]
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     // Row(
//     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //     children: [
//     //       Image.asset(widget.product.image,height: 70,width: 70,),
//     //       Expanded(child: Text(widget.product.itemName)),
//     //     ]
//     // );
//   }
// }