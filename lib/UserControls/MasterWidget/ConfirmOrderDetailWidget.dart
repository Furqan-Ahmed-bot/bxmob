// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, iterable_contains_unrelated_type, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, unnecessary_null_comparison

import 'dart:convert';
import 'dart:typed_data';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderDetailModel.dart';
import 'package:ts_app_development/DataLayer/Providers/ThemeProvider/themeProvider.dart';
import 'package:ts_app_development/UserControls/PopUpDialog/popupDialog.dart';
import '../../WaitersOrder/OrderScreen.dart';

class ConfirmOrderWidget extends StatefulWidget {
  final String saleInvoiceId;
  final String tableNo;
  final String noOfPerson;
  final String totalAmount;

  const ConfirmOrderWidget(
      {Key? key,
      required this.saleInvoiceId,
      required this.tableNo,
      required this.noOfPerson,
      required this.totalAmount})
      : super(key: key);

  @override
  State<ConfirmOrderWidget> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrderWidget> {
  List<OrderDetailModel>? orderDetailModelList;
  List<OrderDetailModel>? orderDetailModelListUpdated;
  List dealitems = [];
  List orderInfo = [];
  Uint8List? _bytesImage;
  Map data = {
    "longName": "DEAL",
  };

  double? saleRateFromServer;

  @override
  void initState() {
    fetchOrderListDetailData();
    super.initState();
  }

  Future<void> fetchOrderListDetailData() async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    Map<String, dynamic> userMap = jsonDecode(user);
    String url =
        '${prefs.getString('ApiUrl')}/TSBE/Sales/OrderHistory?SaleInvoiceId=' +
            widget.saleInvoiceId +
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
      dealitems = jsonResponse['Table1'];
      orderInfo = jsonResponse['Table'];
      // var orderDetailDatas = jsonResponse['Table1']['DealItems'];
      // dealitems = jsonResponse['Table1']['DealItems'];
      // dealitems = jsonResponse[];
      print('orderDetailData${orderDetailData}');
      print('Deal Items${dealitems}');
      print('OrderInfo ${orderInfo}');

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
  }

  @override
  Widget build(BuildContext context) {
    if (orderDetailModelListUpdated == null) {
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
      appBar: AppBar(
        title: Text('Order Details'),
        // leading: BackButton(onPressed: (){
        //   Get.to(PointOfSell());

        // }),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(OrdersPage(
                title: 'Menu Screen',
                tableNo: widget.tableNo,
                saleInvoiceNo: widget.saleInvoiceId,
                noOfPerson: widget.noOfPerson,
              ));
            },
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 2),
                //   child: Text(
                //     'Edit Order',
                //     style: TextStyle(
                //         fontFamily: 'Poppins',
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            // GestureDetector(
            //   onTap: (){
            //     Get.to(OrdersPage(title: 'Menu Screen',tableNo: widget.tableNo,saleInvoiceNo: widget.saleInvoiceId,noOfPerson: widget.noOfPerson,));
            //   },
            //   child: Row(
            //     children: [
            //       SizedBox(width: 100,),
            //       Icon(Icons.edit , color: Color(0xFFb54f40),),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 2),
            //         child: Text(
            //           'Edit Order',
            //           style: TextStyle(
            //               fontFamily: 'Poppins',
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.list_alt,
                  color: Color(0xFFb54f40),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    'Order No: ' + widget.saleInvoiceId,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.table_bar_outlined,
                  color: Color(0xFFb54f40),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    'Table No: ' + widget.tableNo,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.money,
                  color: Color(0xFFb54f40),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    'Total Amount: ' + orderInfo[0]['NetAmount'].toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                ),
                Icon(
                  Icons.person,
                  color: Color(0xFFb54f40),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    'Customer: ' + orderInfo[0]['ClientName'],
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),

            // ExpandeableWidget(ordersdetail: deallist.length, title: 'Deals',),
            // Expandiblewidget(ordersdetails: deallist, itemname: deallist[0], quantity: 5, dealname: 'Crispy Deal', ),
            // for (var i = 0; i < dealitems.length; i++)
            //   dealitems[i]['LongName'].contains('DEAL')?
            //   Container()
            // ? ExpandableNotifier(
            //     child: Padding(
            //     padding: const EdgeInsets.all(0),
            //     child: ScrollOnExpand(
            //       child: Card(
            //         elevation: 10,
            //         // clipBehavior: Clip.antiAlias,
            //         child: Column(
            //           children: <Widget>[
            //             // orderDetailModelListUpdated!.contains(data)?
            //             ExpandablePanel(
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
            //                       height: 120,
            //                       color: Color(0xFFFFFFFF),
            //                       child: Row(
            //                           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             ExpandableIcon(
            //                               theme:
            //                                   const ExpandableThemeData(
            //                                 expandIcon: Icons.arrow_right,
            //                                 collapseIcon:
            //                                     Icons.arrow_drop_down,
            //                                 iconColor: Color(0xFFC4996C),
            //                                 iconSize: 30.0,
            //                                 // iconRotationAngle: math.pi / 2,
            //                                 // iconPadding: EdgeInsets.only(right: 5),
            //                                 hasIcon: false,
            //                                 // iconPlacement:
            //                               ),
            //                             ),

            //                             // widget.product.ItemImage == null?
            //                             Padding(
            //                               padding: const EdgeInsets.only(
            //                                   left: 10),
            //                               child: Image.asset(
            //                                 'assets/images/placeholder.png',
            //                                 height: 80,
            //                                 width: 80,
            //                               ),
            //                             ),

            //                             SizedBox(
            //                               width: 20,
            //                             ),
            //                             Column(
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.center,
            //                               crossAxisAlignment:
            //                                   CrossAxisAlignment.start,
            //                               children: [
            //                                 SizedBox(
            //                                   height: 20,
            //                                 ),
            //                                 Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .spaceEvenly,
            //                                   children: [
            //                                     Container(
            //                                         width: 60,
            //                                         child: Text(dealitems[
            //                                             i]['LongName'])),
            //                                     Container(
            //                                         margin:
            //                                             EdgeInsets.only(
            //                                                 left: 20,
            //                                                 right: 20),
            //                                         child: Text(
            //                                           dealitems[i]
            //                                                   ['SaleRate']
            //                                               .toString(),
            //                                           // + itemTotalPrice.toString(),
            //                                           style: TextStyle(
            //                                               fontSize: 14),
            //                                         )),
            //                                     InkWell(
            //                                       onTap: () {},
            //                                       child: Padding(
            //                                         padding:
            //                                             const EdgeInsets
            //                                                     .only(
            //                                                 right: 10),
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                                 SizedBox(
            //                                   height: 20,
            //                                 ),
            //                                 Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.start,
            //                                   children: [],
            //                                 ),
            //                               ],
            //                             )
            //                           ]),
            //                     ),
            //                   ],
            //                 ),
            //                 collapsed: Container(),
            //                 expanded: Container()

            //                 // ListView.builder(
            //                 //         physics: ClampingScrollPhysics(),
            //                 //         shrinkWrap: true,
            //                 //         itemCount: dealitems[index]['DealItems']
            //                 //                     .length >
            //                 //                 0
            //                 //             ? dealitems[index]['DealItems']
            //                 //                 .length
            //                 //             : 0,
            //                 //         itemBuilder: ((context, i) {
            //                 //           return Padding(
            //                 //             padding: const EdgeInsets.all(8.0),
            //                 //             child: Container(
            //                 //               color: Colors.blue,
            //                 //               child: Text(
            //                 //                   // 'Hello'
            //                 //                   dealitems[index]['DealItems']
            //                 //                       [i]['LongName']
            //                 //                       ),
            //                 //             ),
            //                 //           );
            //                 //         }),
            //                 //       );

            //                 // ListView.builder(
            //                 //     shrinkWrap: true,
            //                 //     itemCount: dealitems.length,
            //                 //     // widget.product.DealItems!.length,
            //                 //     itemBuilder: (BuildContext context, index) {
            //                 //       return
            //                 //       ListView.builder(
            //                 //         physics: ClampingScrollPhysics(),
            //                 //         shrinkWrap: true,
            //                 //         itemCount: dealitems[index]['DealItems']
            //                 //                     .length >
            //                 //                 0
            //                 //             ? dealitems[index]['DealItems']
            //                 //                 .length
            //                 //             : 0,
            //                 //         itemBuilder: ((context, i) {
            //                 //           return Padding(
            //                 //             padding: const EdgeInsets.all(8.0),
            //                 //             child: Container(
            //                 //               color: Colors.blue,
            //                 //               child: Text(
            //                 //                   // 'Hello'
            //                 //                   dealitems[index]['DealItems']
            //                 //                       [i]['LongName']),
            //                 //             ),
            //                 //           );
            //                 //         }),
            //                 //       );
            //                 //     }),
            //                 )
            //             //  Text('')
            //           ],
            //         ),
            //       ),
            //     ),
            //   ))
            // : Container(),
            // SizedBox(height: 20,),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderDetailModelListUpdated!.length,
                itemBuilder: (BuildContext context, int index) {
                  double? netAmount =
                      orderDetailModelListUpdated![index].saleRate;
                  String inString = netAmount!.toStringAsFixed(2); // '2.35'
                  double inDouble = double.parse(inString);
                  if (orderDetailModelListUpdated![index].imageBlock == null) {
                  } else {
                    _bytesImage = Base64Decoder().convert(
                        orderDetailModelListUpdated![index]
                            .imageBlock
                            .toString());
                  }

                  saleRateFromServer =
                      orderDetailModelListUpdated![index].saleRate;

                  print(
                      'SaleRate: ${orderDetailModelListUpdated![index].saleRate}');

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          elevation: 10,
                          child: orderDetailModelListUpdated![index]
                                  .longName!
                                  .contains('DEAL')
                              ? ExpandableNotifier(
                                  child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: ScrollOnExpand(
                                    child: Card(
                                      elevation: 10,
                                      // clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        children: <Widget>[
                                          // orderDetailModelListUpdated!.contains(data)?
                                          ExpandablePanel(
                                              theme: const ExpandableThemeData(
                                                headerAlignment:
                                                    ExpandablePanelHeaderAlignment
                                                        .center,
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
                                                            theme:
                                                                const ExpandableThemeData(
                                                              expandIcon: Icons
                                                                  .arrow_right,
                                                              collapseIcon: Icons
                                                                  .arrow_drop_down,
                                                              iconColor: Color(
                                                                  0xFFC4996C),
                                                              iconSize: 30.0,
                                                              // iconRotationAngle: math.pi / 2,
                                                              // iconPadding: EdgeInsets.only(right: 5),
                                                              hasIcon: false,
                                                              // iconPlacement:
                                                            ),
                                                          ),

                                                          // widget.product.ItemImage == null?
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: dealitems[
                                                                              index]
                                                                          [
                                                                          'ImageBlock'] ==
                                                                      null
                                                                  ? Image.asset(
                                                                      'assets/images/placeholder.png',
                                                                      height:
                                                                          80,
                                                                      width: 80,
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          80,
                                                                      width: 80,
                                                                      child: Image.memory(
                                                                          _bytesImage!,
                                                                          fit: BoxFit
                                                                              .fill))),

                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                      width: 60,
                                                                      child: Text(
                                                                          dealitems[index]
                                                                              [
                                                                              'LongName'])),
                                                                  Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        dealitems[index]['SaleRate']
                                                                            .toString(),
                                                                        // + itemTotalPrice.toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      )),
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [],
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
                                                  itemCount: dealitems[index]
                                                                  ['DealItems']
                                                              .length >
                                                          0
                                                      ? dealitems[index]
                                                              ['DealItems']
                                                          .length
                                                      : 0,
                                                  itemBuilder: ((context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 40,
                                                        color: Color.fromARGB(
                                                            255, 240, 234, 234),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(dealitems[
                                                                        index][
                                                                    'DealItems']
                                                                [
                                                                i]['LongName']),
                                                            // SizedBox(width: 30,),
                                                            Spacer(),
                                                            Text(dealitems[index]
                                                                        [
                                                                        'DealItems']
                                                                    [
                                                                    i]['Quantity']
                                                                .toString())
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  })))
                                          //  Text('')
                                        ],
                                      ),
                                    ),
                                  ),
                                ))

                              // Container(
                              //     color: Colors.blue,
                              //     child: Text(
                              //         orderDetailModelListUpdated![index]
                              //             .longName
                              //             .toString()),
                              //   )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  height: 120,
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: orderDetailModelListUpdated![
                                                          index]
                                                      .imageBlock ==
                                                  null
                                              ? Image.asset(
                                                  'assets/images/placeholder.png',
                                                  height: 80,
                                                  width: 80,
                                                )
                                              : Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.memory(
                                                      _bytesImage!,
                                                      fit: BoxFit.fill))),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30),
                                                child: Container(
                                                  child: Text(
                                                    orderDetailModelListUpdated![
                                                            index]
                                                        .longName!,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  width: 230,
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
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 40, 0),
                                                child: Container(
                                                  height: 25,
                                                  child: Text(
                                                    "Rs: ${inString}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              // Spacer(),
                                              // IconButton(
                                              //   icon: Icon(Icons.remove),
                                              //   color: Color(0xFFC4996C),
                                              //   onPressed: () {
                                              //     setState(() {
                                              //       if (widget.product.Quantity != null)
                                              //         widget.product.Quantity = widget.product.Quantity! - 1;
                                              //     });
                                              //     OrderModel _orderModel = OrderModel(
                                              //         Barcode: widget.product.Barcode,
                                              //         Quantity: widget.product.Quantity,
                                              //         Price: 420,
                                              //         ItemComment: 'testComment',
                                              //         DealItems: []);
                                              //     String orderData = jsonEncode(_orderModel);
                                              //     print(orderData);
                                              //     if(widget.product.Quantity == 0){
                                              //       widget.controller.products
                                              //           .removeWhere(((item,
                                              //           value) =>
                                              //       item.Barcode ==
                                              //           widget.product.Barcode));
                                              //     }
                                              //   },
                                              // ),
                                              Text('Quantity: ' +
                                                  orderDetailModelListUpdated![
                                                          index]
                                                      .quantity
                                                      .toString()),
                                              // IconButton(
                                              //   icon: Icon(Icons.add),
                                              //   color: Color(0xFFC4996C),
                                              //   onPressed: () {
                                              //     setState(() {
                                              //       if (widget.product.Quantity != null)
                                              //         widget.product.Quantity = widget.product.Quantity! + 1;
                                              //     });
                                              //     OrderModel _orderModel = OrderModel(
                                              //         Barcode: widget.product.Barcode,
                                              //         Quantity: widget.product.Quantity,
                                              //         Price: 420,
                                              //         ItemComment: 'testComment',
                                              //         DealItems: []);
                                              //     String orderData = jsonEncode(_orderModel);
                                              //     print(orderData);
                                              //     widget.controller.addProduct(widget.product);
                                              //   },
                                              // ),
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
          ],
        ),
      ),
    );
  }
}

class Expandiblewidget extends StatefulWidget {
  final List ordersdetails;
  final String dealname;
  final double quantity;
  final String itemname;

  Expandiblewidget({
    Key? key,
    required this.ordersdetails,
    required this.itemname,
    required this.quantity,
    required this.dealname,
  }) : super(key: key);

  @override
  State<Expandiblewidget> createState() => _ExpandiblewidgetState();
}

class _ExpandiblewidgetState extends State<Expandiblewidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpandableNotifier(
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

                              // widget.product.ItemImage == null?
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          width: 60,
                                          child: Text(widget.dealname
                                              //widget.product.ItemName!
                                              )),
                                      // SizedBox(width: 30,),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            'Rs: 499',
                                            // + itemTotalPrice.toString(),
                                            style: TextStyle(fontSize: 14),
                                          )),
                                      InkWell(
                                        onTap: () {
                                          // print(widget.product.Barcode);
                                          // setState(() {
                                          //   // if (widget.product.Barcode!
                                          //   //     .contains('DEAL')) {
                                          //   //   widget.controller.removeProduct(
                                          //   //       widget.product);
                                          //   // }
                                          //   widget.controller.removeProduct(widget.product);
                                          // });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          // child: Icon(
                                          //   Icons.delete,
                                          //   size: 25,
                                          //   color: Color(0xFFC4996C),
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [],
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
                      itemCount: widget.ordersdetails.length,
                      // widget.product.DealItems!.length,
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
                                  Text(widget.itemname),
                                  // Text(
                                  //   widget.product.DealItems![index].ItemName!,
                                  //   style: TextStyle(fontSize: 12),
                                  // ),
                                  Spacer(),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    widget.quantity.toString(),
                                    // ${widget.product.DealItems![index].Quantity.toString()}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              )),
                        );
                      }),
                )
                //  Text('')
              ],
            ),
          ),
        ),
      )),
    );
  }
}
