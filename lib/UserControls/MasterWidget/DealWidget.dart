// // ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_brace_in_string_interps, iterable_contains_unrelated_type

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
// import 'package:ts_app_development/DataLayer/Models/Orders/DealGroupModel.dart';
// import 'package:ts_app_development/DataLayer/Models/Orders/DealModel.dart';
// import 'package:ts_app_development/DataLayer/Models/Orders/DealSave.dart';
// import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';

// class DealWidget extends StatefulWidget {
//   final String? itemName;
//   final String? barcode;
//   final String? price;

//   final List<Itemgroups>? dealList;
//   const DealWidget(
//       {Key? key,
//       required this.itemName,
//       required this.barcode,
//       required this.price,
//       required this.dealList,

//       })
//       : super(key: key);

//   @override
//   State<DealWidget> createState() => _DealWidgetState();
// }

// class _DealWidgetState extends State<DealWidget> {
//   String _groupValue = '';
//   double counter = 0.0;
//   double? quantity;
//   String? strQuantity;
//   List<DealSave> jsonObjectsList = [];
//   bool _flag = true;
//   double? countQuantity = 0.0;
//   double? itemGroupQuantity;

//   final TextEditingController _dealCommentController = TextEditingController();

//   final TextEditingController _dealItemCommentController =
//       TextEditingController();

//   List<TextEditingController> _controllers = [];

//   var _controllerList = [];

//   final cartController = Get.put(CartController());

//   void checkRadio(String value) {
//     setState(() {
//       _groupValue = value;
//     });
//   }

//   List multipleSelected = [];
//   List checkListItems = [
//     {
//       "id": 0,
//       "value": false,
//       "title": "Pepsi",
//     },
//     {
//       "id": 1,
//       "value": false,
//       "title": "7up",
//     },
//     {
//       "id": 2,
//       "value": false,
//       "title": "Mirinda",
//     },
//   ];

//   @override
//   bool value = false;
//   Widget build(BuildContext context) {
//     String str = widget.price.toString();
//     var price = str.split('.');

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         height: 800,
//         decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20.0),
//                 topRight: Radius.circular(20.0))),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 15),
//                 child: Center(
//                   child: Container(
//                     width: 100,
//                     height: 100,

//                     child: Image.asset('assets/images/placeholder.png',
//                         fit: BoxFit.fill),
//                     //         decoration: new BoxDecoration(
//                     //   color: Colors.transparent,
//                     //   borderRadius: BorderRadius.vertical(
//                     //       bottom: Radius.elliptical(
//                     //           MediaQuery.of(context).size.width, 70.0)),
//                     // ),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
//                     child: Text(
//                       widget.itemName!,
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
//                     child: Text(
//                       price[0],
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                   )
//                 ],
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.only(left: 20, top: 15),
//               //   child: Text('Description'),
//               // ),
//               Center(
//                 child: Container(
//                   width: 350,
//                   child: Divider(
//                     height: 10,
//                     thickness: 1,
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: widget.dealList!.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     String str = widget.dealList![index].quantity.toString();
//                     var arr = str.split('.');

//                     quantity = widget.dealList![index].quantity;

//                     print(quantity);

//                     strQuantity = quantity!.toInt().toString();

//                     print(strQuantity);

//                     // itemGroupQuantity =  widget.dealList![index].quantity! + widget.dealList![index].quantity!;
//                     // print('Item Group Quantity: ${itemGroupQuantity}');
//                     double iGQuantity = 0.0;
//                     for (int i = 0; i < widget.dealList!.length; i++) {
//                       iGQuantity = iGQuantity! + widget.dealList![i].quantity!;
//                       print('Item Group Quantity: ${iGQuantity}');
//                     }
//                     itemGroupQuantity = iGQuantity;
//                     print('Item Group Quantity New: ${itemGroupQuantity}');

//                     // var arr = strQuantity!.split('.');
//                     // print(arr[0]);
//                     // print(arr[1]);

//                     return Container(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           // Text('${widget.dealList![index].quantity}'),
//                           // Text('${widget.dealList![index].multiSelection}'),
//                           Container(
//                             margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Group: ' +
//                                       '${widget.dealList![index].itemGroupId}',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   'Qty. Limit',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   ': ',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   '${arr[0]}',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                           ),
//                           //Text('Group: '+'${widget.dealList![index].itemGroupId}'),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: widget.dealList![index].items!.length,
//                             itemBuilder: (BuildContext context, int index1) {
//                               // for (var i = 0; i < widget.dealList![index].items!.length ; i++) {
//                               //   _controllerList = i.toString() as List;

//                               // }
//                               _controllers.add(TextEditingController());
//                               // _controllers[index].text = widget.dealList![index1].items.toString();
//                               // _controllers[index1].text = widget.dealList![index].items![index1].itemComment;

//                               String str = widget
//                                   .dealList![index].items![index1].counter
//                                   .toString();
//                               var count = str.split('.');

//                               return Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(0),
//                                   color: Color(0xFFFFFFFF),
//                                 ),
//                                 child: Column(
//                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // Container(
//                                     //   margin: EdgeInsets.only(left: 10,right: 10),
//                                     //   child: Row(
//                                     //     children: [
//                                     //       Text('Group: '+'${widget.dealList![index].itemGroupId}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
//                                     //       Spacer(),
//                                     //       Text('0',style: TextStyle(fontWeight: FontWeight.bold),),
//                                     //       Text('/',style: TextStyle(fontWeight: FontWeight.bold),),
//                                     //       Text('${widget.dealList![index].quantity}',style: TextStyle(fontWeight: FontWeight.bold),)
//                                     //     ],
//                                     //   ),
//                                     // ),
//                                     Row(
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 20),
//                                               child: Container(
//                                                 child: Text(
//                                                   '${widget.dealList![index].items![index1].product}',
//                                                   style: TextStyle(
//                                                       fontFamily: 'Poppins',
//                                                       fontSize: 13),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Spacer(),
//                                         Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: <Widget>[
//                                             IconButton(
//                                               icon: Icon(Icons.remove),
//                                               iconSize: 30,
//                                               onPressed: () {
//                                                 setState(() {
//                                                   if (widget.dealList![index]
//                                                               .counter >
//                                                           0 &&
//                                                       widget
//                                                               .dealList![index]
//                                                               .items![index1]
//                                                               .counter >
//                                                           0) {
//                                                     widget.dealList![index]
//                                                         .counter--;
//                                                     widget
//                                                         .dealList![index]
//                                                         .items![index1]
//                                                         .counter--;
//                                                     jsonObjectsList.removeWhere(
//                                                         (item) =>
//                                                             item.barcode ==
//                                                             widget
//                                                                 .dealList![
//                                                                     index]
//                                                                 .items![index1]
//                                                                 .barcode);
//                                                     print(
//                                                         'List Size: ${jsonObjectsList.length}');
//                                                     //counter = widget.dealList![index].items![index1].counter;
//                                                     // if(widget.dealList![index].counter == 0){
//                                                     //   cartController.removeProductDeal(widget.dealList![index].items![index1]);
//                                                     // }
//                                                   }
//                                                 });
//                                               },
//                                               color: Color(0xFFC4996C),
//                                             ),
//                                             // if(widget.dealList![index].quantity! > 1)...[

//                                             //   Text(arr[0]),
//                                             // ],
//                                             // if(widget.dealList![index].quantity! == 1)...[

//                                             //   Text(count[0]),
//                                             // ],
//                                             Text(count[0]),

//                                             IconButton(
//                                               icon: Icon(Icons.add),
//                                               iconSize: 30,
//                                               color: Color(0xFFC4996C),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   if (widget.dealList![index]
//                                                           .counter
//                                                           .toString() ==
//                                                       widget.dealList![index]
//                                                           .quantity
//                                                           .toString()) {

//                                                     showToast(
//                                                         'Limit reached for the group...',
//                                                         context: context,
//                                                         axis: Axis.horizontal,
//                                                         backgroundColor:
//                                                             Color(0xFFb54f40),
//                                                         textStyle: TextStyle(
//                                                             color:
//                                                                 Colors.white),
//                                                         alignment:
//                                                             Alignment.center,
//                                                         borderRadius:
//                                                             BorderRadius.zero,
//                                                         position:
//                                                             StyledToastPosition
//                                                                 .center);
//                                                   }

//                                                   else{
//                                                      widget.dealList![index]
//                                                         .counter++;
//                                                     widget
//                                                         .dealList![index]
//                                                         .items![index1]
//                                                         .counter++;

//                                                     jsonObjectsList.add(DealSave(
//                                                         ItemGroupId: widget
//                                                             .dealList![index]
//                                                             .itemGroupId,
//                                                         barcode: widget
//                                                             .dealList![index]
//                                                             .items![index1]
//                                                             .barcode,
//                                                         ItemName: widget
//                                                             .dealList![index]
//                                                             .items![index1]
//                                                             .product,
//                                                         Quantity: widget
//                                                             .dealList![index]
//                                                             .quantity!,
//                                                         particularItemComment:
//                                                             _controllers[index1]
//                                                                 .text));
//                                                     print(
//                                                         'List Size: ${jsonObjectsList.length}');

//                                                     setState(() {
//                                                       countQuantity =
//                                                           countQuantity! +
//                                                               widget
//                                                                   .dealList![
//                                                                       index]
//                                                                   .items![
//                                                                       index1]
//                                                                   .counter;
//                                                       print(
//                                                           'Counter Quantity: ${countQuantity}');
//                                                     });

//                                                   }
//                                                   // if(strQuantity == widget.dealList![index].items![index1].counter.toString()){
//                                                   //   print('Limit Reached...');
//                                                   // }
//                                                   // else if(counter < 1){
//                                                   //   widget.dealList![index].items![index1].counter++;
//                                                   //   counter = widget.dealList![index].items![index1].counter;
//                                                   // }
//                                                   // else{
//                                                   //   widget.dealList![index].items![index1].counter++;
//                                                   //   counter = widget.dealList![index].items![index1].counter;
//                                                   // }
//                                                 });
//                                               },
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),

//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 20),
//                                       child: Container(
//                                         width: 200,
//                                         height: 40,
//                                         child: TextFormField(
//                                             decoration: InputDecoration(
//                                               // labelText: "Comments",
//                                               hintText: "Comments",

//                                               floatingLabelBehavior:
//                                                   FloatingLabelBehavior.always,
//                                               //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
//                                               //  child: Icon(Icons.email,),),
//                                               // contentPadding: EdgeInsets.symmetric(
//                                               //     horizontal: 30, vertical: 15),
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(1),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.black),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(1),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.black),
//                                                 gapPadding: 10,
//                                               ),
//                                             ),
//                                             //  onChanged: (value){
//                                             //                               print('Value texteditingCcontroller: ${value}');
//                                             //                               widget.dealList![index].items![index1].itemComment = value;
//                                             //                               print('Particular Item Comment: ${widget.dealList![index].items![index1].itemComment}');
//                                             //                               setState(() {
//                                             //                                 _controllers[index1].text = widget.dealList![index].items![index1].itemComment;

//                                             //                               });
//                                             //                             },
//                                             controller: _controllers[index]),
//                                         // child: TextFormField(
//                                         //   decoration: InputDecoration(
//                                         //       labelText: "Comment",
//                                         //       hintText: "Comment",
//                                         //       floatingLabelBehavior: FloatingLabelBehavior.always,
//                                         //       //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
//                                         //       //  child: Icon(Icons.email,),),
//                                         //       contentPadding:
//                                         //       EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                                         //       enabledBorder: OutlineInputBorder(
//                                         //         borderRadius: BorderRadius.circular(1),
//                                         //         borderSide: BorderSide(color: Colors.black),
//                                         //       ),
//                                         //       focusedBorder: OutlineInputBorder(
//                                         //         borderRadius: BorderRadius.circular(1),
//                                         //         borderSide: BorderSide(color: Colors.black),
//                                         //         gapPadding: 10,
//                                         //       )
//                                         //   ),
//                                         //   onChanged: (value){
//                                         //     print('Value texteditingCcontroller: ${value}');
//                                         //     widget.dealList![index].items![index1].itemComment = value;
//                                         //     print('Particular Item Comment: ${widget.dealList![index].items![index1].itemComment}');
//                                         //     setState(() {
//                                         //       _controllers[index1].text = widget.dealList![index].items![index1].itemComment;

//                                         //     });
//                                         //   },
//                                         //   controller: _controllers[index1],
//                                         // ),
//                                         // margin: EdgeInsets.only(left: 20),
//                                       ),
//                                     ),
//                                     Divider(),
//                                   ],
//                                 ),
//                               );
//                             },
//                           )
//                         ],
//                       ),
//                     );
//                   }),

//               SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: Container(
//                   width: 350,
//                   height: 50,
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                         labelText: "Comments",
//                         hintText: "Comments",
//                         floatingLabelBehavior: FloatingLabelBehavior.always,
//                         //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
//                         //  child: Icon(Icons.email,),),
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(1),
//                           borderSide: BorderSide(color: Colors.black),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(1),
//                           borderSide: BorderSide(color: Colors.black),
//                           gapPadding: 10,
//                         )),
//                     controller: _dealCommentController,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (jsonObjectsList.isNotEmpty) {
//                     //cartController.addProduct(jsonObjectsList);
//                     if (jsonObjectsList.length == itemGroupQuantity) {

//                       double saleRate = double.parse(widget.price!);
//                       OrderModel _orderModel = OrderModel(
//                           ItemName: widget.itemName,
//                           ItemImage: '',
//                           Barcode: widget.barcode,
//                           Quantity: 1,
//                           Price: saleRate,
//                           ItemComment: _dealCommentController.text,
//                           DealItems: jsonObjectsList);
//                       String orderData = jsonEncode(_orderModel);
//                       print(orderData);
//                       cartController.addProduct(_orderModel);

//                       showToast('Deal Added Successfully',
//                           context: context,
//                           axis: Axis.horizontal,
//                           backgroundColor: Color(0xFFb54f40),
//                           textStyle: TextStyle(color: Colors.white),
//                           alignment: Alignment.center,
//                           borderRadius: BorderRadius.zero,
//                           position: StyledToastPosition.bottom);
//                       Get.back();
//                     } else {
//                       showToast('Incomplete Items..',
//                           context: context,
//                           axis: Axis.horizontal,
//                           backgroundColor: Color(0xFFb54f40),
//                           textStyle: TextStyle(color: Colors.white),
//                           alignment: Alignment.center,
//                           borderRadius: BorderRadius.zero,
//                           position: StyledToastPosition.center);
//                     }
//                   } else {
//                     showToast('No item Selected',
//                         context: context,
//                         axis: Axis.horizontal,
//                         backgroundColor: Color(0xFFb54f40),
//                         textStyle: TextStyle(color: Colors.white),
//                         alignment: Alignment.center,
//                         borderRadius: BorderRadius.zero,
//                         position: StyledToastPosition.center);
//                   }
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(left: 15, right: 15),
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFb54f40),
//                   ),
//                   child: Center(
//                       child: Text(
//                     'Add',
//                     style: TextStyle(color: Colors.white),
//                   )),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Row customAddsonn(String txt) {
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 8, top: 0),
//           child: Checkbox(
//             value: this.value,
//             onChanged: (value) {
//               setState(() {
//                 this.value = value!;
//               });
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//           child: Text(
//             txt,
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_print, unused_field, prefer_final_fields, sized_box_for_whitespace

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:get/get.dart';
import '/DataLayer/GetX/cartController.dart';

import '/DataLayer/Models/Orders/DealModel.dart';
import '/DataLayer/Models/Orders/DealSave.dart';
import '/DataLayer/Models/Orders/OrderModel.dart';

class DealWidget extends StatefulWidget {
  final String? itemName;
  final String? barcode;
  final String? price;
  final String? itemImage;
  final List<Itemgroups>? dealList;
  const DealWidget(
      {Key? key,
      required this.itemName,
      required this.barcode,
      required this.price,
      required this.itemImage,
      required this.dealList})
      : super(key: key);

  @override
  State<DealWidget> createState() => _DealWidgetState();
}

class _DealWidgetState extends State<DealWidget> {
  String _groupValue = '';
  double counter = 0.0;
  double? quantity;
  String? strQuantity;
  List<DealSave> jsonObjectsList = [];
  bool _flag = true;
  double? countQuantity = 0.0;
  double? itemGroupQuantity;

  final TextEditingController _dealCommentController = TextEditingController();

  final TextEditingController _dealItemCommentController =
      TextEditingController();

  List<TextEditingController> _controllers = [];
  final TextEditingController _ctlr = TextEditingController();

  var _controllerList = [];

  final cartController = Get.put(CartController());
  Uint8List? _bytesImage;

  void checkRadio(String value) {
    setState(() {
      _groupValue = value;
    });
  }

  List multipleSelected = [];
  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "Pepsi",
    },
    {
      "id": 1,
      "value": false,
      "title": "7up",
    },
    {
      "id": 2,
      "value": false,
      "title": "Mirinda",
    },
  ];
  var count;
  @override
  bool value = false;
  Widget build(BuildContext context) {
    if (widget.itemImage == null) {
    } else {
      _bytesImage = Base64Decoder().convert(widget.itemImage!);
    }

    String str = widget.price.toString();
    var price = str.split('.');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: 800,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            children: [
                              // if(widget.itemImage!.isEmpty)...[
                              //   Container(
                              //         width: 80,
                              //         height: 80,
                              //         child: Image.asset('assets/images/placeholder.png',
                              //             fit: BoxFit.cover),
                              //       )

                              // ] else if(widget.itemImage == null) ...[
                              //   Container(
                              //         width: 80,
                              //         height: 80,
                              //         child: Image.asset('assets/images/placeholder.png',
                              //             fit: BoxFit.cover),
                              //       )

                              // ] else ...[
                              //    Container(
                              //     width: 80,
                              //     height: 80,
                              //     child: Image.memory(_bytesImage!, fit: BoxFit.fill),
                              //   ),

                              // ],
                              widget.itemImage == null
                                  ? Container(
                                      width: 80,
                                      height: 80,
                                      child: Image.asset(
                                          'assets/images/placeholder.png',
                                          fit: BoxFit.cover),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      child: Image.memory(_bytesImage!,
                                          fit: BoxFit.fill),
                                    ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 0),
                                        child: Container(
                                          child: Text(
                                            widget.itemName!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                          // width: 200,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 15, 0),
                                          child: Text(
                                            'Rs ${price[0]}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text(
                      widget.itemName!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                    child: Text(
                      price[0],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20, top: 15),
              //   child: Text('Description'),
              // ),
              Center(
                child: Container(
                  width: 350,
                  child: Divider(
                    height: 10,
                    thickness: 1,
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.dealList!.length, //iterating deal's groups
                  itemBuilder: (BuildContext context, int index) {
                    String str = widget.dealList![index].quantity.toString();
                    var arr = str.split('.');

                    quantity = widget.dealList![index].quantity;

                    print(quantity);

                    strQuantity = quantity!.toInt().toString();

                    print(strQuantity);

                    // itemGroupQuantity =  widget.dealList![index].quantity! + widget.dealList![index].quantity!;
                    // print('Item Group Quantity: ${itemGroupQuantity}');
                    double iGQuantity = 0.0;
                    for (int i = 0; i < widget.dealList!.length; i++) {
                      iGQuantity = iGQuantity! + widget.dealList![i].quantity!;
                      print('Item Group Quantity: ${iGQuantity}');
                    }
                    itemGroupQuantity = iGQuantity;
                    print('Item Group Quantity New: ${itemGroupQuantity}');

                    // var arr = strQuantity!.split('.');
                    // print(arr[0]);
                    // print(arr[1]);

                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text('${widget.dealList![index].quantity}'),
                          // Text('${widget.dealList![index].multiSelection}'),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Group: ' +
                                      '${widget.dealList![index].itemGroupId}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text(
                                  'Qty. Limit',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ': ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${arr[0]}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          //Text('Group: '+'${widget.dealList![index].itemGroupId}'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.dealList![index].items!
                                .length, //iterating deal's group's items
                            itemBuilder: (BuildContext context, int index1) {
                              //index=groupIndex, index1=itemIndex
                              _controllers.add(TextEditingController());
                              // _ctlr.add(TextEditingController());

                              String str = widget
                                  .dealList![index].items![index1].counter
                                  .toString();
                              count = str.split('.');

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Color(0xFFFFFFFF),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Container(
                                                child: Text(
                                                  '${widget.dealList![index].items![index1].product}',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              iconSize: 30,
                                              onPressed: () {
                                                setState(() {
                                                  if (widget.dealList![index]
                                                              .counter >
                                                          0 &&
                                                      widget
                                                              .dealList![index]
                                                              .items![index1]
                                                              .counter >
                                                          0) {
                                                    widget.dealList![index]
                                                        .counter--;
                                                    widget
                                                        .dealList![index]
                                                        .items![index1]
                                                        .counter--;
                                                    jsonObjectsList.removeWhere(
                                                        (item) =>
                                                            item.barcode ==
                                                            widget
                                                                .dealList![
                                                                    index]
                                                                .items![index1]
                                                                .barcode);
                                                    print(
                                                        'List Size: ${jsonObjectsList.length}');
                                                    print(
                                                        'Hello ${widget.dealList!.length}');
                                                    //counter = widget.dealList![index].items![index1].counter;
                                                    // if(widget.dealList![index].counter == 0){
                                                    //   cartController.removeProductDeal(widget.dealList![index].items![index1]);
                                                    // }
                                                  }
                                                });
                                              },
                                              color: Color(0xFFC4996C),
                                            ),
                                            Text(count[0]),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              iconSize: 30,
                                              color: Color(0xFFC4996C),
                                              onPressed: () {
                                                setState(() {
                                                  if (widget.dealList![index]
                                                          .counter
                                                          .toString() ==
                                                      widget.dealList![index]
                                                          .quantity
                                                          .toString()) {
                                                    print(
                                                        'Limit reached for the group...');
                                                    // Fluttertoast.showToast(
                                                    //     msg: "Limit reached for the group...",
                                                    //     toastLength: Toast.LENGTH_SHORT,
                                                    //     gravity: ToastGravity.BOTTOM,
                                                    //     timeInSecForIosWeb: 1,
                                                    //     backgroundColor: Colors.black,
                                                    //     textColor: Colors.white,
                                                    //     fontSize: 16.0
                                                    // );
                                                    showToast(
                                                        'Limit reached for the group...',
                                                        context: context,
                                                        axis: Axis.horizontal,
                                                        backgroundColor:
                                                            Color(0xFFb54f40),
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        alignment:
                                                            Alignment.center,
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                        position:
                                                            StyledToastPosition
                                                                .center);
                                                  } else {
                                                    widget.dealList![index]
                                                        .counter++;
                                                    widget
                                                        .dealList![index]
                                                        .items![index1]
                                                        .counter++;
                                                    int myindex =
                                                        jsonObjectsList
                                                            .indexWhere(
                                                      (element) =>
                                                          element.barcode ==
                                                          widget
                                                              .dealList![index]
                                                              .items![index1]
                                                              .barcode,
                                                    );
                                                    if (myindex == -1) {
                                                      jsonObjectsList.add(DealSave(
                                                          ItemGroupId: widget
                                                              .dealList![index]
                                                              .itemGroupId,
                                                          barcode: widget
                                                              .dealList![index]
                                                              .items![index1]
                                                              .barcode,
                                                          ItemName: widget
                                                              .dealList![index]
                                                              .items![index1]
                                                              .product,
                                                          Quantity: widget
                                                              .dealList![index]
                                                              .quantity,
                                                          ItemComment: widget
                                                              .dealList![index]
                                                              .items![index1]
                                                              .itemComment));
                                                      print(
                                                          'List Size: ${jsonObjectsList.length}');
                                                      print(
                                                          'Hello ${widget.dealList!.length}');
                                                      print(
                                                          'Controller ${_controllers.length}');
                                                    } else {
                                                      jsonObjectsList[myindex]
                                                              .Quantity =
                                                          widget
                                                              .dealList![index]
                                                              .quantity;
                                                    }

                                                    setState(() {
                                                      countQuantity =
                                                          countQuantity! +
                                                              widget
                                                                  .dealList![
                                                                      index]
                                                                  .items![
                                                                      index1]
                                                                  .counter!;
                                                      print(
                                                          'Counter Quantity: ${countQuantity}');
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Container(
                                      width: 200,
                                      height: 30,
                                      child: TextFormField(
                                        onChanged: (text) {
                                          if (widget
                                                  .dealList![index].quantity! >
                                              0) {
                                            int myindex =
                                                jsonObjectsList.indexWhere(
                                              (element) =>
                                                  element.barcode ==
                                                  widget.dealList![index]
                                                      .items![index1].barcode,
                                            );
                                            if (myindex == -1) {
                                              jsonObjectsList.add(DealSave(
                                                  ItemGroupId: widget
                                                      .dealList![index]
                                                      .itemGroupId,
                                                  barcode: widget
                                                      .dealList![index]
                                                      .items![index1]
                                                      .barcode,
                                                  ItemName: widget
                                                      .dealList![index]
                                                      .items![index1]
                                                      .product,
                                                  Quantity: widget
                                                      .dealList![index]
                                                      .quantity,
                                                  ItemComment: widget
                                                      .dealList![index]
                                                      .items![index1]
                                                      .itemComment = text));
                                            } else {
                                              jsonObjectsList[myindex]
                                                      .Quantity =
                                                  widget.dealList![index]
                                                      .quantity;
                                              jsonObjectsList[myindex]
                                                      .ItemComment =
                                                  widget
                                                      .dealList![index]
                                                      .items![index1]
                                                      .itemComment = text;
                                            }
                                          }

                                          // widget.dealList![index].items![index1]
                                          //     .itemComment = text;
                                        },
                                        decoration: InputDecoration(
                                          // labelText: "Comments",
                                          hintText: "Comments",
                                          contentPadding: EdgeInsets.only(
                                              top: 15, left: 10),

                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                          //  child: Icon(Icons.email,),),
                                          // contentPadding: EdgeInsets.symmetric(
                                          //     horizontal: 30, vertical: 15),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                            gapPadding: 10,
                                          ),
                                        ),
                                        //  onChanged: (value){
                                        //                               print('Value texteditingCcontroller: ${value}');
                                        //                               widget.dealList![index].items![index1].itemComment = value;
                                        //                               print('Particular Item Comment: ${widget.dealList![index].items![index1].itemComment}');
                                        //                               setState(() {
                                        //                                 _controllers[index1].text = widget.dealList![index].items![index1].itemComment;

                                        //                               });
                                        //                             },
                                        //controller: widget.dealList![index].items![index1].itemComment
                                      ),
                                      margin: EdgeInsets.only(left: 20),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }),

              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 350,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Comments",
                        hintText: "Comments",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        //  suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                        //  child: Icon(Icons.email,),),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                          borderSide: BorderSide(color: Colors.black),
                          gapPadding: 10,
                        )),
                    controller: _dealCommentController,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (jsonObjectsList.isNotEmpty) {
                    //cartController.addProduct(jsonObjectsList);
                    if (jsonObjectsList.length == widget.dealList!.length) {
                      double saleRate = double.parse(widget.price!);
                      OrderModel _orderModel = OrderModel(
                          ItemName: widget.itemName,
                          ItemImage: widget.itemImage,
                          Barcode: widget.barcode,
                          Quantity: 1,
                          Price: saleRate,
                          ItemComment: _dealCommentController.text,
                          DealItems: jsonObjectsList);
                      String orderData = jsonEncode(_orderModel);
                      print(orderData);
                      cartController.addProduct(_orderModel);

                      showToast('Deal Added Successfully',
                          context: context,
                          axis: Axis.horizontal,
                          backgroundColor: Color(0xFFb54f40),
                          textStyle: TextStyle(color: Colors.white),
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.zero,
                          position: StyledToastPosition.bottom);
                      // widget.dealList.clear();

                      Get.back();
                    } else {
                      showToast('Incomplete Items..',
                          context: context,
                          axis: Axis.horizontal,
                          backgroundColor: Color(0xFFb54f40),
                          textStyle: TextStyle(color: Colors.white),
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.zero,
                          position: StyledToastPosition.center);
                    }
                  } else {
                    showToast('No item Selected',
                        context: context,
                        axis: Axis.horizontal,
                        backgroundColor: Color(0xFFb54f40),
                        textStyle: TextStyle(color: Colors.white),
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.zero,
                        position: StyledToastPosition.center);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFb54f40),
                  ),
                  child: Center(
                      child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row customAddsonn(String txt) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 0),
          child: Checkbox(
            value: this.value,
            onChanged: (value) {
              setState(() {
                this.value = value!;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            txt,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
