// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_brace_in_string_interps, non_constant_identifier_names, prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/DataLayer/Models/Orders/TableValidationModel.dart';
import 'package:ts_app_development/Screens/genericScreen.dart';
import '../UserControls/MasterWidget/ConfirmOrderDetailWidget.dart';
import 'OrderScreen.dart';
import 'package:ripple_button/ripple_button.dart';

import 'OrdersListScreen.dart';

class PointOfSell extends StatefulWidget {
  final String? route;
  const PointOfSell({Key? key, this.route}) : super(key: key);

  @override
  State<PointOfSell> createState() => _PointOfSellState();
}

class _PointOfSellState extends State<PointOfSell> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController tableNoController = TextEditingController();
  final TextEditingController noOfPersonsController = TextEditingController();

  List<TableValidationModel>? tableValidationList;
  List orderList = [];
  bool tableFound = false;
  bool isNoOfGuestVisible = false;
  bool navigateToOrdersMenu = false;
  int? saleInvoiceid;
  dynamic netAmount = '';
  @override
  void initState() {
    //fetchTableData();
    fetchOrderListData();
    getOrderModuleUrl();
    super.initState();
  }

  Future<void> fetchTableData(tableNo, noOfPerson) async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';

    String url =
        '${prefs.getString('ApiUrl')}/TSBE/EStore/Mobile/DiningTableForOrder?TableName=' +
            tableNo +
            '&DinePersons=' +
            noOfPerson;
    Map<String, dynamic> userMap = jsonDecode(user);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Authorization': 'Basic dGVjaG5vc3lzOlRlY2g3MTA=',
        // 'TS-AppKey':'foodsinn'
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));

      //Get.to(OrdersPage(title: 'Menu Screen',tableNo: tableNoController.text,));

      var res = response.body;
      var jsonResponse = json.decode(res);
      tableValidationList = jsonResponse
          .map((item) => TableValidationModel.fromJson(item))
          .toList()
          .cast<TableValidationModel>();

      print(tableValidationList!.length);
      String msg = "";
      if (tableValidationList!.length > 0) {
        tableValidationList!.forEach((ele) => {
              //msg+= msg.isNotEmpty ? '\n':''+ ele.vaildationMessage!
              msg = ele.vaildationMessage!
            });

        showToast(msg,
            context: context,
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.center);
      } else {
        Get.to(OrdersPage(
            title: 'Menu Screen',
            tableNo: tableNo,
            saleInvoiceNo: '',
            noOfPerson: noOfPerson));
      }
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getOrderModuleUrl() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('LocalApiUrl', prefs.getString('ApiUrl').toString());

    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    Map<String, dynamic> userMap = jsonDecode(user);

    String url = '${prefs.getString('ApiUrl')}/TSBE/CompanyBranch/LocalApiUrl';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      if (jsonResponse['LocalApiUrl']?.length > 0) {
        prefs.setString('LocalApiUrl', jsonResponse['LocalApiUrl']);
      }
    } else {
      print(response.statusCode);
    }
    print('local api url: ${prefs.getString('LocalApiUrl')}');
  }

  Future<void> fetchOrderListData() async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    Map<String, dynamic> userMap = jsonDecode(user);
    String url =
        '${prefs.getString('ApiUrl')}/TSBE/EStore/Order/SalesmanOrderStatus';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      orderList = jsonResponse;
      print('OrderList ${orderList}');
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isNoOfGuestVisible == true) {
      setState(() {
        navigateToOrdersMenu = true;
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text('Select Table' , style: TextStyle(color: Colors.black),),
      //   leading: BackButton(
      //   onPressed: (){
      //     Get.to(GenericScreen(route: '',));
      //   },
      // ),
      // actions: [
      //      IconButton(
      //         onPressed: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
      //         },
      //         icon: const Icon(
      //           Icons.edit_note,
      //           size: 30,
      //         ),
      //       ),
      // ],),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        color: Color(0xFFb54f40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BackButton(
                              color: Colors.white,
                              onPressed: () {
                                Get.to(GenericScreen(
                                  route: '',
                                ));
                              },
                            ),
                            Text(
                              'Select Table',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => OrderListScreen())));
                              },
                              icon: const Icon(
                                Icons.edit_note,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    //Text('Table Details.' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20)),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Table No',
                            hintText: "Table No",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                            //  child: Icon(Icons.email,),),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1),
                              borderSide: BorderSide(color: Colors.black),
                              gapPadding: 10,
                            )),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Fields must not be empty';
                          }
                          return null;
                        },
                        controller: tableNoController,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    isNoOfGuestVisible
                        ? Container(
                            width: 250,
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Number of Guests',
                                    hintText: "Number of Guests",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    //  child: Icon(Icons.email,),),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(1),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(1),
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      gapPadding: 10,
                                    )),
                                // validator: (text) {
                                //   if (text == null || text.isEmpty) {
                                //     return 'Fields must not be empty';
                                //   }
                                //   return null;
                                // },
                                controller: noOfPersonsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9a-zA-Z]")),
                                ]),
                          )
                        : Container(),
                    Container(
                      width: 280,
                      height: 70,
                      child: RippleButton(
                        'OK',
                        padding: EdgeInsets.all(16),
                        color: RippleButtonColor(
                          background: Color(0xFFb54f40),
                        ),
                        style: RippleButtonStyle(
                          text: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            letterSpacing: 0.1,
                            wordSpacing: 0.5,
                          ),
                        ),
                        onPressed: () {
                          for (var i = 0; i < orderList.length; i++) {
                            if (tableNoController.text.toString() ==
                                orderList[i]['TableName'].toString()) {
                              tableFound = true;
                              saleInvoiceid = orderList[i]['SaleInvoiceId'];
                              // print('saleInvoiceidd ${saleInvoiceid}');
                              break;
                            } else {
                              tableFound = false;
                            }
                          }
                          if (formKey.currentState!.validate()) {
                            if (tableFound) {
                              Get.to(ConfirmOrderWidget(
                                saleInvoiceId: saleInvoiceid.toString(),
                                tableNo: tableNoController.text,
                                noOfPerson: '',
                                totalAmount: netAmount,
                              ));
                            } else {
                              setState(() {
                                isNoOfGuestVisible = true;
                              });
                              // fetchTableData(tableNoController.text,
                              //     noOfPersonsController.text);
                            }

                            //   //Get.to(OrdersPage(title: 'Menu Screen',tableNo: tableNoController.text,saleInvoiceNo: '',noOfPerson: noOfPersonsController.text));
                            //   //Get.to(OrdersPage(title: 'Menu Screen',tableNo: tableNoController.text,));
                          }
                          if (navigateToOrdersMenu == true) {
                            fetchTableData(tableNoController.text,
                                noOfPersonsController.text);
                          }

                          // setState(() => {isEnabled = !isEnabled});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
