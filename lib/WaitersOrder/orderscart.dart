// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_type_check, unnecessary_brace_in_string_interps, curly_braces_in_flow_control_structures, sized_box_for_whitespace, avoid_print, unnecessary_null_comparison, prefer_if_null_operators, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:expandable/expandable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/InvalidTableCheckModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderDetailModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/UserControls/MasterWidget/EditFromCartOrder.dart';
import 'package:ts_app_development/WaitersOrder/SelectTable.dart';

import '../UserControls/PageRouteBuilder/pageRouteBuilder.dart';

class CartProducts extends StatefulWidget {
  CartProducts(
      {Key? key,
      required this.tableNo,
      required this.saleInvoiceNo,
      required this.noOfPerson})
      : super(key: key);

  final String tableNo;
  final String saleInvoiceNo;
  final String noOfPerson;

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  List<OrderModel> ordersList = [];

  List<InvalidTableCheckModel>? invalidTableList;

  final CartController controller = Get.find();

  bool _isLoading = false;
  Uint8List? _bytesImage;

  final formKey = GlobalKey<FormState>();
  final TextEditingController masterCommentController = TextEditingController();
  final TextEditingController editedTableNumberController =
      TextEditingController();

  final TextEditingController noOfPersonController = TextEditingController();
  orderData(order, tableNo, masterComment, saleInvoiceId, diningPerson) async {
    String username = 'E00103013';
    String password = 'a';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    Map<String, dynamic> userMap = jsonDecode(user);

    setState(() {
      _isLoading = true;
    });
    var data = jsonEncode(<String, dynamic>{
      "TableName": tableNo,
      "SaleInvoiceId": saleInvoiceId,
      "DinePersons": diningPerson,
      "NetAmount": '749.0',
      "Comment": masterComment,
      "OrderLines": order,
    });
    try {
      final response = await http.post(
          Uri.parse(
            '${prefs.getString('LocalApiUrl')}/TSBE/EStore/Mobile/Order',
          ),
          headers: <String, String>{
            // 'Authorization': basicAuth,
            // 'TS-AppKey':'foodsinn',
            // 'content-type':'application/json'
            "UserId": "${userMap['UserId']}",
            "token": "${userMap['GUID']}",
            "Content-type": 'application/json'
          },
          body: data);
      // var datas = (jsonDecode(response.body));
      // print(datas);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          controller.clearCart();
        });
        print(jsonDecode(response.body));
        // var res = response.body;
        var jsonResponse = json.decode(response.body);
        // int code = jsonResponse['code'];
        String message = jsonResponse['message'];
        var detail = jsonResponse['detail'];
        var tokenNumber = jsonResponse['detail']['TokenNumber'];
        var orderId = jsonResponse['detail']['Id'];
        print(detail);
        print(message);
        print(tokenNumber);
        print(orderId);

        // Fluttertoast.showToast(
        //     msg: 'Order Created Successfully at Token Number: ' +
        //         tokenNumber.toString(),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     backgroundColor: Colors.white,
        //     textColor: Colors.black);

        showToast(
            'Order Created Successfully at Token Number: ' +
                tokenNumber.toString(),
            context: context,
            duration: Duration(seconds: 10),
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.center);
        Navigator.pushReplacement(
            context, CustomPageRouteBuilder.createRoute('/HandheldOrder'));
      } else if (response.statusCode == 422) {
        print('Response Code: ${response.statusCode}');
        print(jsonDecode(response.body));
        var jsonResponse = json.decode(response.body);
        var orderDetail = jsonResponse['detail'];
        // int code = jsonResponse['code'];
        String message = jsonResponse['message'];
        print(orderDetail);
        invalidTableList = orderDetail
            .map((item) => InvalidTableCheckModel.fromJson(item))
            .toList()
            .cast<InvalidTableCheckModel>();
        print(invalidTableList!.length);
        print(invalidTableList![0].vaildationMessage);

        showToast(invalidTableList![0].vaildationMessage!,
            context: context,
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.center);

        setState(() {
          _isLoading = false;
        });
      } else {
        print('Response Code: ${response.statusCode}');
        print(jsonDecode(response.body));

        showToast('Error',
            context: context,
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.center);

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<OrderDetailModel>? orderDetailModelList;
  List<OrderDetailModel>? orderDetailModelListUpdated;

  double? saleRateFromServer;

  @override
  void initState() {
    fetchOrderListDetailData();
    super.initState();
  }

  Future<void> fetchOrderListDetailData() async {
    if (widget.saleInvoiceNo.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      // Try reading data from the counter key. If it doesn't exist, return 0.
      final user = prefs.getString('user') ?? '';
      final appKey = prefs.getString('appKey') ?? '';
      Map<String, dynamic> userMap = jsonDecode(user);
      String url =
          '${prefs.getString('LocalApiUrl')}/TSBE/Sales/OrderHistory?SaleInvoiceId=' +
              widget.saleInvoiceNo +
              '&NoOfRecord=1&ShouldIncludeItems=true';
      // Try reading data from the counter key. If it doesn't exist, return 0.
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
        var res = response.body;
        var jsonResponse = json.decode(res);
        var orderDetailData = jsonResponse['Table1'];
        print(orderDetailData);
        orderDetailModelList = orderDetailData
            .map((item) => OrderDetailModel.fromJson(item))
            .toList()
            .cast<OrderDetailModel>();

        print(orderDetailModelList!.length);

        setState(() {
          orderDetailModelListUpdated = orderDetailModelList;
        });
      } else {
        print(response.statusCode);
      }
    } else {
      print('Something went Wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.saleInvoiceNo.isEmpty) ...[],
            if (widget.saleInvoiceNo.isNotEmpty) ...[
              // Expandiblewidget(ordersdetails: orderDetailModelListUpdated!, itemname: 'Already Ordered Items', quantity: 5 ,),
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(0),
                child: ScrollOnExpand(
                  child: Card(
                    elevation: 10,
                    // clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToExpand: true,
                            tapBodyToCollapse: true,
                            hasIcon: false,
                          ),
                          header: Column(
                            children: [
                              Container(
                                height: 80,
                                child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ExpandableIcon(
                                        theme: const ExpandableThemeData(
                                          expandIcon: Icons.arrow_right,
                                          collapseIcon: Icons.arrow_drop_down,
                                          iconColor: Color(0xFFC4996C),
                                          iconSize: 30.0,
                                          // iconRotationAngle: math.pi / 2,
                                          // iconPadding: EdgeInsets.only(right: 5),
                                          hasIcon: false,
                                          // iconPlacement:
                                        ),
                                      ),
                                      Text(
                                        'Already Ordered Items',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                          collapsed: Container(),
                          expanded: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFb54f40), width: 2),
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderDetailModelListUpdated!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Card(
                                          elevation: 10,
                                          child: Container(
                                              color: Color(0xFFFFFFFF),
                                              height: 120,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Image.asset(
                                                      'assets/images/placeholder.png',
                                                      height: 80,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 30),
                                                            child: Container(
                                                              width: 230,
                                                              child: Text(
                                                                orderDetailModelListUpdated![
                                                                        index]
                                                                    .longName!,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      //Spacer(),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    0,
                                                                    40,
                                                                    0),
                                                            child: Container(
                                                              height: 25,
                                                              child: Text(
                                                                "Rs: ${orderDetailModelListUpdated![index].saleRate.toString()}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text('Quantity: ' +
                                                              orderDetailModelListUpdated![
                                                                      index]
                                                                  .quantity
                                                                  .toString()),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  // Spacer(),
                                                ],
                                              )),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
            SizedBox(
              height: 10,
            ),
            Obx(
              () => SizedBox(
                height: 450,
                child: ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) => CartProductCard(
                    controller: controller,
                    product: controller.products.keys.toList()[index],
                    quantity: controller.products.values.toList()[index],
                    index: index,
                    tableNo: widget.tableNo,
                    invoiceNo: widget.saleInvoiceNo,
                    noOfGuests: widget.noOfPerson,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  //  CartTotal(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.saleInvoiceNo.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 50,
                          width: 170,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Table Number",
                                hintText: widget.tableNo ?? "Table Number",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            controller: editedTableNumberController,
                          ),
                        ),
                      ),
                    ],
                    if (widget.saleInvoiceNo.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 50,
                          width: 170,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: widget.tableNo ?? "Table Number",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            controller: editedTableNumberController,
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                    if (widget.saleInvoiceNo.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 50,
                          width: 170,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Number of Guests",
                                hintText: widget.noOfPerson ?? "No Of Persons",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            controller: noOfPersonController,
                          ),
                        ),
                      ),
                    ],
                    if (widget.saleInvoiceNo.isNotEmpty) ...[
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: Container(
                      //     height: 50,
                      //     width: 250,
                      //     margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      //     child: TextFormField(
                      //       decoration: InputDecoration(
                      //           hintText: widget.noOfPerson ?? "No Of Persons",
                      //           floatingLabelBehavior: FloatingLabelBehavior.always,
                      //           //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                      //           //  child: Icon(Icons.email,),),
                      //           contentPadding:
                      //           EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(1),
                      //             borderSide: BorderSide(color: Colors.black),
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(1),
                      //             borderSide: BorderSide(color: Colors.black),
                      //             gapPadding: 10,
                      //           )),
                      //       controller: noOfPersonController,
                      //       enabled: false,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.saleInvoiceNo.isEmpty) ...[
                  Center(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Comments",
                            hintText: "Comments",
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
                        controller: masterCommentController,
                      ),
                    ),
                  ),
                  if (widget.saleInvoiceNo.isNotEmpty) ...[],
                ],
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.saleInvoiceNo.isEmpty) ...[
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xff292929),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xffA8A8A8)),
                        strokeWidth: 4,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (controller.products.length == 0) {
                          print('No items in cart');
                        } else if (editedTableNumberController.text.isEmpty) {
                          String productsData =
                              jsonEncode(controller.products.keys.toList());
                          //ordersList.add(controller.products);
                          //List data = json.decode(controller.products.keys.toList());

                          var dataa = json.decode(productsData);
                          print('Json Decode: ${dataa}');

                          print(productsData);
                          print(widget.tableNo);
                          //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                          orderData(
                              controller.products.keys.toList(),
                              widget.tableNo,
                              masterCommentController.text,
                              '',
                              widget.noOfPerson);
                        } else if (editedTableNumberController
                            .text.isNotEmpty) {
                          String productsData =
                              jsonEncode(controller.products.keys.toList());
                          //ordersList.add(controller.products);
                          //List data = json.decode(controller.products.keys.toList());

                          var dataa = json.decode(productsData);
                          print('Json Decode: ${dataa}');

                          print(productsData);
                          print(widget.tableNo);
                          //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                          orderData(
                              controller.products.keys.toList(),
                              editedTableNumberController.text,
                              masterCommentController.text,
                              '',
                              widget.noOfPerson);
                        } else if (noOfPersonController.text.isEmpty) {
                          if (editedTableNumberController.text.isEmpty) {
                            String productsData =
                                jsonEncode(controller.products.keys.toList());
                            //ordersList.add(controller.products);
                            //List data = json.decode(controller.products.keys.toList());

                            var dataa = json.decode(productsData);
                            print('Json Decode: ${dataa}');

                            print(productsData);
                            print(widget.tableNo);
                            //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                            orderData(
                                controller.products.keys.toList(),
                                widget.tableNo,
                                masterCommentController.text,
                                '',
                                widget.noOfPerson);
                          }
                        } else if (noOfPersonController.text.isNotEmpty) {
                          if (editedTableNumberController.text.isNotEmpty) {
                            String productsData =
                                jsonEncode(controller.products.keys.toList());
                            //ordersList.add(controller.products);
                            //List data = json.decode(controller.products.keys.toList());

                            var dataa = json.decode(productsData);
                            print('Json Decode: ${dataa}');

                            print(productsData);
                            print(widget.tableNo);
                            //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                            orderData(
                                controller.products.keys.toList(),
                                editedTableNumberController.text,
                                masterCommentController.text,
                                '',
                                noOfPersonController.text);
                          }
                        } else if (widget.noOfPerson.isEmpty) {
                          String productsData =
                              jsonEncode(controller.products.keys.toList());
                          //ordersList.add(controller.products);
                          //List data = json.decode(controller.products.keys.toList());

                          var dataa = json.decode(productsData);
                          print('Json Decode: ${dataa}');

                          print(productsData);
                          print(widget.tableNo);
                          //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                          orderData(
                              controller.products.keys.toList(),
                              editedTableNumberController.text,
                              masterCommentController.text,
                              '',
                              noOfPersonController.text);
                        } else if (widget.noOfPerson.isNotEmpty) {
                          String productsData =
                              jsonEncode(controller.products.keys.toList());
                          //ordersList.add(controller.products);
                          //List data = json.decode(controller.products.keys.toList());

                          var dataa = json.decode(productsData);
                          print('Json Decode: ${dataa}');

                          print(productsData);
                          print(widget.tableNo);
                          //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                          orderData(
                              controller.products.keys.toList(),
                              editedTableNumberController.text,
                              masterCommentController.text,
                              '',
                              widget.noOfPerson);
                        }
                      },
                      child: Container(
                          height: 50,
                          width: 250,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(color: Color(0xFFb54f40)),
                          // ignore: prefer_const_constructors
                          child: Center(
                              child: Text(
                            'Create Order',
                            style: TextStyle(color: Colors.white),
                          ))),
                    ),
            ],
            if (widget.saleInvoiceNo.isNotEmpty) ...[
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xff292929),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xffA8A8A8)),
                        strokeWidth: 4,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (controller.products.length == 0) {
                          print('No items in cart');
                        } else if (editedTableNumberController.text.isEmpty) {
                          String productsData =
                              jsonEncode(controller.products.keys.toList());
                          //ordersList.add(controller.products);
                          //List data = json.decode(controller.products.keys.toList());

                          var dataa = json.decode(productsData);
                          print('Json Decode: ${dataa}');

                          print(productsData);
                          print(widget.tableNo);
                          //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                          orderData(
                            controller.products.keys.toList(),
                            widget.tableNo,
                            masterCommentController.text,
                            widget.saleInvoiceNo,
                            widget.noOfPerson,
                          );
                        } else if (editedTableNumberController
                            .text.isNotEmpty) {
                          String productsData =
                              jsonEncode(controller.products.keys.toList());
                          //ordersList.add(controller.products);
                          //List data = json.decode(controller.products.keys.toList());

                          var dataa = json.decode(productsData);
                          print('Json Decode: ${dataa}');

                          print(productsData);
                          print(widget.tableNo);
                          //Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OrderListScreen())));
                          orderData(
                              controller.products.keys.toList(),
                              editedTableNumberController.text,
                              masterCommentController.text,
                              widget.saleInvoiceNo,
                              widget.noOfPerson);
                        } else if (noOfPersonController.text.isEmpty) {
                          if (editedTableNumberController.text.isEmpty) {
                            String productsData =
                                jsonEncode(controller.products.keys.toList());
                            //ordersList.add(controller.products);
                            //List data = json.decode(controller.products.keys.toList());

                            var dataa = json.decode(productsData);
                            print('Json Decode: ${dataa}');

                            print(productsData);
                            print(widget.tableNo);

                            orderData(
                                controller.products.keys.toList(),
                                widget.tableNo,
                                masterCommentController.text,
                                widget.saleInvoiceNo,
                                widget.noOfPerson);
                          }
                        } else if (noOfPersonController.text.isNotEmpty) {
                          if (editedTableNumberController.text.isNotEmpty) {
                            String productsData =
                                jsonEncode(controller.products.keys.toList());

                            var dataa = json.decode(productsData);
                            print('Json Decode: ${dataa}');

                            print(productsData);
                            print(widget.tableNo);

                            orderData(
                                controller.products.keys.toList(),
                                editedTableNumberController.text,
                                masterCommentController.text,
                                widget.saleInvoiceNo,
                                noOfPersonController.text);
                          }
                        }
                      },
                      child: Container(
                          height: 50,
                          width: 250,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(color: Color(0xFFb54f40)),
                          child: Center(
                              child: Text(
                            'Update Order',
                            style: TextStyle(color: Colors.white),
                          ))),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}

class CartProductCard extends StatefulWidget {
  final CartController controller;
  final OrderModel product;

  final double quantity;
  final int index;
  final String tableNo, invoiceNo, noOfGuests;
  const CartProductCard(
      {Key? key,
      required this.controller,
      required this.product,
      required this.quantity,
      required this.index,
      required this.tableNo,
      required this.invoiceNo,
      required this.noOfGuests})
      : super(key: key);

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  late double itemTotalPrice;
  late double itemQuantity;
  late double itemPrice;

  Uint8List? _bytesImage;

  var itemComment;
  var dealItemComment;

  @override
  Widget build(BuildContext context) {
    if (widget.product.ItemImage == null) {
    } else {
      _bytesImage = Base64Decoder().convert(widget.product.ItemImage!);
    }

    itemPrice = double.parse(widget.product.Price.toString());
    assert(itemPrice is double);
    print(itemPrice);

    itemQuantity = double.parse(widget.quantity.toString());
    assert(itemQuantity is double);
    print(itemQuantity);

    itemTotalPrice = itemQuantity * itemPrice;

    itemComment = widget.product.ItemComment;
    print('ItemComment: ${itemComment}');

    if (widget.product.ItemName!.contains('DEAL') ||
        (widget.product.ItemName!.contains('PLATTER')) ||
        (widget.product.ItemName!.contains('BEEF STEAK')) ||
        (widget.product.ItemName!.contains('CHICKEN STEAK'))) {
      dealItemComment = widget.product.ItemComment;
      print('DealItemComment: ${dealItemComment}');

      //  int? index;
      return
          //  Expandiblewidget(ordersdetails:  widget.product.DealItems!, itemname: widget.product.DealItems![0].ItemName!.toString(), quantity: 5 , dealname: widget.product.ItemName!,);

          ExpandableNotifier(
              child: Padding(
        padding: const EdgeInsets.all(0),
        child: ScrollOnExpand(
          child: Card(
            elevation: 10,
            // clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: false,
                  ),
                  header: Column(
                    children: [
                      Container(
                        height: 120,
                        color: Color(0xFFFFFFFF),
                        child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ExpandableIcon(
                                theme: const ExpandableThemeData(
                                  expandIcon: Icons.arrow_right,
                                  collapseIcon: Icons.arrow_drop_down,
                                  iconColor: Color(0xFFC4996C),
                                  iconSize: 30.0,
                                  // iconRotationAngle: math.pi / 2,
                                  // iconPadding: EdgeInsets.only(right: 5),
                                  hasIcon: false,
                                  // iconPlacement:
                                ),
                              ),

                              widget.product.ItemImage == null
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        'assets/images/placeholder.png',
                                        height: 80,
                                        width: 80,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        child: Image.memory(_bytesImage!,
                                            fit: BoxFit.fill),
                                      ),
                                    ),

                              //     if (widget.product.ItemImage!.isNotEmpty) ...[
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10),
                              //   child: Container(
                              //     width: 80,
                              //     height: 80,
                              //     child: Image.memory(_bytesImage!, fit: BoxFit.fill),
                              //   ),
                              // ),
                              // ],

                              // if (widget.product.ItemImage!.isEmpty) ...[
                              //   Padding(
                              //     padding: const EdgeInsets.only(left: 10),
                              //     child: Image.asset(
                              //       'assets/images/placeholder.png',
                              //       height: 80,
                              //       width: 80,
                              //     ),
                              //   ),
                              // ],

                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10),
                              //   child: Image.asset(
                              //     'assets/images/placeholder.png',
                              //     height: 80,
                              //     width: 80,
                              //   ),
                              // ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          width: 60,
                                          child:
                                              Text(widget.product.ItemName!)),
                                      // SizedBox(width: 30,),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            'Rs: ' + itemTotalPrice.toString(),
                                            style: TextStyle(fontSize: 14),
                                          )),
                                      InkWell(
                                        onTap: () {
                                          print(widget.product.Barcode);
                                          setState(() {
                                            // if (widget.product.Barcode!
                                            //     .contains('DEAL')) {
                                            //   widget.controller.removeProduct(
                                            //       widget.product);
                                            // }
                                            widget.controller
                                                .removeProduct(widget.product);
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.delete,
                                            size: 25,
                                            color: Color(0xFFC4996C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (dealItemComment == "") ...[
                                        Visibility(
                                          visible: false,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Text(widget.product
                                                        .ItemComment!))),
                                          ),
                                        ),
                                      ],
                                      if (dealItemComment != "") ...[
                                        Visibility(
                                          visible: true,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Text(widget.product
                                                        .ItemComment!))),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ],
                  ),
                  collapsed: Container(),
                  expanded: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.product.DealItems!.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              height: 40,
                              color: Color.fromARGB(255, 240, 234, 234),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.product.DealItems![index]
                                            .ItemName!,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      widget.product.DealItems![index]
                                                  .ItemComment ==
                                              null
                                          ? Container(
                                              height: 0,
                                            )
                                          : Text(
                                              widget.product.DealItems![index]
                                                  .ItemComment!,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                    ],
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    'Quantity: ${widget.product.DealItems![index].Quantity.toString()}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              )),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              if (widget.invoiceNo.isEmpty) {
                return EditorFromCartWidget(
                  itemName: widget.product.ItemName,
                  price: widget.product.Price.toString(),
                  image: '',
                  productListBottomSheet: widget.product,
                  tableNo: widget.tableNo,
                  invoiceNo: '',
                  noOfGuests: widget.noOfGuests,
                );
              } else {
                return EditorFromCartWidget(
                  itemName: widget.product.ItemName,
                  price: widget.product.Price.toString(),
                  image: '',
                  productListBottomSheet: widget.product,
                  tableNo: widget.tableNo,
                  invoiceNo: widget.invoiceNo,
                  noOfGuests: widget.noOfGuests,
                );
              }
              // return EditorFromCartWidget(itemName: widget.product.ItemName,price: widget.product.Price.toString(),image: '',productListBottomSheet: widget.product,);
            });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              elevation: 10,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Color(0xFFFFFFFF),
                  ),
                  height: 130,
                  child: Row(
                    children: [
                      if (widget.product.ItemImage!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Image.memory(_bytesImage!, fit: BoxFit.fill),
                          ),
                        ),
                      ],

                      if (widget.product.ItemImage!.isEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            'assets/images/placeholder.png',
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ],

                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Total ${widget.controller.total}'),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Container(
                                  width: 230,
                                  child: Text(
                                    widget.product.ItemName!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          //Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                child: Container(
                                  height: 25,
                                  // width: 80,
                                  child: Text(
                                    'Rs: ' + widget.product.Price.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              //Spacer(),
                              IconButton(
                                icon: Icon(Icons.remove),
                                color: Color(0xFFC4996C),
                                onPressed: () {
                                  // widget.controller.removeProduct(widget.product);
                                  setState(() {
                                    if (widget.product.Quantity != null)
                                      widget.product.Quantity =
                                          widget.product.Quantity! - 1;
                                  });
                                  OrderModel _orderModel = OrderModel(
                                      Barcode: widget.product.Barcode,
                                      Quantity: widget.product.Quantity,
                                      Price: 420,
                                      ItemComment: 'testComment',
                                      DealItems: []);
                                  String orderData = jsonEncode(_orderModel);
                                  print(orderData);
                                  setState(() {
                                    if (widget.product.Quantity == 0) {
                                      widget.controller.products.removeWhere(
                                          ((item, value) =>
                                              item.Barcode ==
                                              widget.product.Barcode));
                                    }
                                  });

                                  // setState(() {
                                  //   widget.controller.decreaseQuantityUpdate(widget.product);
                                  // });
                                },
                              ),
                              Text('${widget.product.Quantity}'),
                              //SizedBox(width: 4,),
                              // InkWell(
                              //   onTap: () {
                              //     print(widget.product.Barcode);
                              //     setState(() {
                              //       // if (widget.product.Barcode!.contains('DEAL')) {
                              //       //   widget.controller.removeProduct(widget.product);
                              //       // }
                              //       widget.controller.removeProduct(widget.product);
                              //     });
                              //   },
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(right: 10),
                              //     child: Icon(
                              //       Icons.delete,
                              //       size: 25,
                              //       color: Color(0xFFC4996C),
                              //     ),
                              //   ),
                              // ),
                              IconButton(
                                icon: Icon(Icons.add),
                                color: Color(0xFFC4996C),
                                onPressed: () {
                                  // setState(() {

                                  // });
                                  if (widget.product.Quantity != null)
                                    widget.product.Quantity =
                                        widget.product.Quantity! + 1;
                                  OrderModel _orderModel = OrderModel(
                                      Barcode: widget.product.Barcode,
                                      Quantity: widget.product.Quantity,
                                      Price: 420,
                                      ItemComment: 'testComment',
                                      DealItems: []);
                                  String orderData = jsonEncode(_orderModel);
                                  print(orderData);
                                  widget.controller.addProduct(widget.product);
                                },
                              ),
                            ],
                          ),
                          if (itemComment == null) ...[
                            Visibility(
                              visible: false,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Text('ItemComment' ??
                                            widget.product.ItemComment!))),
                              ),
                            ),
                          ],
                          if (itemComment != null) ...[
                            Visibility(
                              visible: true,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0))),
                                child: Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child:
                                            Text(widget.product.ItemComment!))),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Spacer(),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}


// class ExpandeableWidget extends StatefulWidget {
// final String title;
// final List ordersdetail = [];
//    ExpandeableWidget({
//     required ordersdetail,
    
//     Key? key, 
//     required this.title,
//   }) : super(key: key);

//   @override
//   State<ExpandeableWidget> createState() => _ExpandeableWidgetState();
// }

// class _ExpandeableWidgetState extends State<ExpandeableWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//       padding: const EdgeInsets.all(0),
//       child: ScrollOnExpand(
//         child: Card(
//           elevation: 10,
//           // clipBehavior: Clip.antiAlias,
//           child: Column(
//             children: <Widget>[
//               ExpandablePanel(
                
                
//                 theme: const ExpandableThemeData(
                  
//                   headerAlignment:
//                       ExpandablePanelHeaderAlignment.center,
//                   tapBodyToExpand: true,
//                   tapBodyToCollapse: true,
//                   hasIcon: false,
//                 ),
//                 header: Column(
//                   children: [
//                     Container(
//                       height: 80,
                     
//                       child: Row(
//                           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ExpandableIcon(
//                               theme: const ExpandableThemeData(
//                                 expandIcon: Icons.arrow_right,
//                                 collapseIcon: Icons.arrow_drop_down,
//                                 iconColor: Color(0xFFC4996C),
//                                 iconSize: 30.0,
//                                 // iconRotationAngle: math.pi / 2,
//                                 // iconPadding: EdgeInsets.only(right: 5),
//                                 hasIcon: false,
//                                 // iconPlacement:
//                               ),
//                             ),
//                             Text(
//                               widget.title,
//                               style: TextStyle(color: Colors.black),
//                             )
//                           ]),
//                     ),
//                   ],
//                 ),
//                 collapsed: Container(),
//                 expanded: Container(
//                   decoration: BoxDecoration(
//                                    border: Border.all(color: Color(0xFFb54f40),
//                                    width: 2
//                                    ),
                                   
//                                   ),

//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: widget.ordersdetail.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Card(
//                                 elevation: 10,
//                                 child: Container(
//                                     color: Color(0xFFFFFFFF),
//                                     height: 120,
//                                     child: Row(
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(
//                                                   left: 10),
//                                           child: Image.asset(
//                                             'assets/images/placeholder.png',
//                                             height: 80,
//                                             width: 80,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets
//                                                               .only(
//                                                           top: 30),
//                                                   child: Container(
//                                                     width: 230,
//                                                     child: Text(
//                                                       widget.ordersdetail[
//                                                               index],
                                                          
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                               'Poppins',
//                                                           fontWeight:
//                                                               FontWeight
//                                                                   .bold,
//                                                           fontSize: 14),
//                                                       overflow:
//                                                           TextOverflow
//                                                               .ellipsis,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             //Spacer(),
//                                             Row(
//                                               children: <Widget>[
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets
//                                                               .fromLTRB(
//                                                           0, 0, 40, 0),
//                                                   child: Container(
//                                                     height: 25,
//                                                     child: Text(
//                                                       "Rs: ${widget.ordersdetail[index]}",
//                                                       style: TextStyle(
//                                                           color: Colors
//                                                               .black,
//                                                           fontSize: 14),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 20,
//                                                 ),
//                                                 Text('Quantity: ' +
//                                                     widget.ordersdetail[
//                                                             index]
                                                        
//                                                         ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         // Spacer(),
//                                       ],
//                                     )),
//                               ),
//                             )
//                           ],
//                         );
//                       }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
