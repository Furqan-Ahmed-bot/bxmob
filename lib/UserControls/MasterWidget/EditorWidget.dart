// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_import

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/ProductModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/Products.dart';

class EditorWidget extends StatefulWidget {
  final String? itemName;
  final String price;
  final String? image;
  final Products? productListBottomSheet;
  const EditorWidget(
      {Key? key,
      required this.itemName,
      required this.price,
      required this.image,
      this.productListBottomSheet})
      : super(key: key);

  @override
  State<EditorWidget> createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
  final cartController = Get.put(CartController());

  Uint8List? _bytesImage;
  TextEditingController _commentcontroller = new TextEditingController();

  @override
  bool value = false;
  bool value2 = false;
  bool value3 = false;
  Widget build(BuildContext context) {
    _bytesImage = Base64Decoder().convert(widget.image!);

    String str = widget.price;
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
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Row(
                            children: [
                              if (widget.image!.isNotEmpty) ...[
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: Image.memory(_bytesImage!,
                                      fit: BoxFit.fill),
                                ),
                              ],
                              if (widget.image!.isEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Center(
                                    child: Container(
                                      width: 65,
                                      height: 80,
                                      child: Image.asset(
                                          'assets/images/placeholder.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ],
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 20, 0, 0),
                                        child: Container(
                                          child: Text(
                                            widget
                                                .productListBottomSheet!.name!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                          width: 250,
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
                                              15, 0, 15, 0),
                                          child: Text(
                                            'Rs ${price[0]}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                iconSize: 30,
                                                onPressed: () {
                                                  setState(() {
                                                    if (widget
                                                            .productListBottomSheet!
                                                            .counter >
                                                        0) {
                                                      widget
                                                          .productListBottomSheet!
                                                          .counter--;
                                                      print(widget
                                                          .productListBottomSheet!
                                                          .counter);
                                                      if (widget
                                                              .productListBottomSheet!
                                                              .counter ==
                                                          0) {
                                                        // OrderModel _orderModel = OrderModel(Barcode: myList1[index].itemName,Quantity: myList1[index].counter,Price: 420,ItemComment: 'testComment',DealItems: []);
                                                        // String orderData = jsonEncode(_orderModel);
                                                        // print(orderData);
                                                        // cartController.removeProduct(_orderModel);
                                                        cartController.products
                                                            .removeWhere(((item,
                                                                    value) =>
                                                                item.Barcode ==
                                                                widget
                                                                    .productListBottomSheet!
                                                                    .barcode));
                                                        //cartController.removeProduct(myList1[index]);
                                                      }
                                                    }
                                                  });
                                                },
                                                color: Color(0xFFC4996C),
                                              ),
                                              Text(widget
                                                  .productListBottomSheet!
                                                  .counter
                                                  .toString()),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                iconSize: 30,
                                                color: Color(0xFFC4996C),
                                                onPressed: () {
                                                  setState(() {
                                                    widget
                                                        .productListBottomSheet!
                                                        .counter++;
                                                    //cartController.addProduct(myList1[index]);
                                                    if (widget
                                                            .productListBottomSheet!
                                                            .counter ==
                                                        0) {
                                                      print(
                                                          'No items selected');
                                                    } else {}
                                                  });
                                                },
                                              ),
                                            ],
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
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Text('Description'),
              ),
              Center(
                child: Container(
                  width: 350,
                  child: Divider(
                    height: 10,
                    thickness: 1,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 350,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Comment",
                        hintText: "Comment",
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
                    controller: _commentcontroller,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    if (widget.productListBottomSheet!.counter == 0) {
                      print('No items selected');
                    } else {
                      //starterObjectsList.add(OrderModel(Barcode: myList1[index].itemName,Quantity: myList1[index].counter,Price: 420,ItemComment: 'testcomment'));
                      //cartController.addProduct(myList1[index]);
                      if (widget.productListBottomSheet!.imageItems!.isEmpty) {
                        OrderModel _orderModel = OrderModel(
                            ItemName: widget.productListBottomSheet!.name,
                            ItemImage: '',
                            Barcode: widget.productListBottomSheet!.barcode,
                            Quantity: widget.productListBottomSheet!.counter
                                .toDouble(),
                            Price: widget.productListBottomSheet!.saleRate,
                            ItemComment: _commentcontroller.text,
                            DealItems: []);
                        String orderData = jsonEncode(_orderModel);
                        print(orderData);
                        cartController.addProductFromEditorWidget(_orderModel);
                        setComment(_commentcontroller.text);
                        clearText();
                        showToast('Item Added Successfully',
                            context: context,
                            axis: Axis.horizontal,
                            backgroundColor: Color(0xFFb54f40),
                            textStyle: TextStyle(color: Colors.white),
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.zero,
                            position: StyledToastPosition.center);
                        Get.back();
                      } else {
                        OrderModel _orderModel = OrderModel(
                            ItemName: widget.productListBottomSheet!.name,
                            ItemImage: widget.productListBottomSheet!
                                .imageItems![0].imageBlock!,
                            Barcode: widget.productListBottomSheet!.barcode,
                            Quantity: widget.productListBottomSheet!.counter
                                .toDouble(),
                            Price: widget.productListBottomSheet!.saleRate,
                            ItemComment: _commentcontroller.text,
                            DealItems: []);
                        String orderData = jsonEncode(_orderModel);
                        print(orderData);
                        cartController.addProductFromEditorWidget(_orderModel);
                        setComment(_commentcontroller.text);
                        clearText();
                        showToast('Item Added Successfully',
                            context: context,
                            axis: Axis.horizontal,
                            backgroundColor: Color(0xFFb54f40),
                            textStyle: TextStyle(color: Colors.white),
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.zero,
                            position: StyledToastPosition.center);
                        Get.back();
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Center(
                        child: Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 25,
                    width: 100,
                  ),
                ),
              ),
              // Center(
              //     child: ElevatedButton(
              //         onPressed: () {
              //           // if (formKey.currentState!.validate()){
              //
              //           // }
              //           setComment(_commentcontroller.text);
              //           clearText();
              //           // Fluttertoast.showToast(
              //           //     msg: "Comment Added Successfully",
              //           //     toastLength: Toast.LENGTH_SHORT,
              //           //     gravity: ToastGravity.BOTTOM,
              //           //     timeInSecForIosWeb: 1,
              //           //     backgroundColor: Colors.black,
              //           //     textColor: Colors.white,
              //           //     fontSize: 16.0);
              //         },
              //         child: Text('Add')))
            ],
          ),
        ),
      ),
    );
  }

  Row customAddsonn(String txt, Checkbox chk) {
    return Row(
      children: [
        Padding(padding: const EdgeInsets.only(left: 8, top: 0), child: chk),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            txt,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Spacer(),
        Padding(
            padding: const EdgeInsets.fromLTRB(110, 0, 15, 0),
            child: Text('+ 150'))
      ],
    );
  }

  Future<void> setComment(comment) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('commentData', comment);
  }

  void clearText() {
    _commentcontroller.clear();
  }
}
