// ignore_for_file: prefer_const_constructors, sort_child_properties_last

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

import '../../WaitersOrder/cart_screen.dart';

class EditorFromCartWidget extends StatefulWidget {
  final String? itemName;
  final String price;
  final String? image;
  final OrderModel? productListBottomSheet;
  final String tableNo,invoiceNo,noOfGuests;
  const EditorFromCartWidget(
      {Key? key,
        required this.itemName,
        required this.price,
        required this.image,
        required this.tableNo,
        required this.invoiceNo,
        required this.noOfGuests,
        this.productListBottomSheet})
      : super(key: key);

  @override
  State<EditorFromCartWidget> createState() => _EditorWidgetFromCartState();
}

class _EditorWidgetFromCartState extends State<EditorFromCartWidget> {

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
                          padding: const EdgeInsets.only(left: 10 , top: 10),
                          child: Row(
                            children: [
                              if (widget.image!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    child: Image.memory(_bytesImage!, fit: BoxFit.fill),
                                  ),
                                ),
                              ],
                              if (widget.image!.isEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Center(
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      child: Image.asset('assets/images/placeholder.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ],
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                        child: Container(
                                          child: Text(
                                            widget.productListBottomSheet!.ItemName!,
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
                                          padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                          child: Text(
                                            'Rs ${price[0]}',
                                            style: TextStyle(
                                                fontSize: 15),
                                          ),
                                        ),

                                        SizedBox(width: 55,),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 20),
                                        //   child: Row(
                                        //     children: [
                                        //       IconButton(
                                        //         icon: Icon(Icons.remove),
                                        //         iconSize: 30,
                                        //         onPressed: () {
                                        //           setState(() {
                                        //             if (widget.productListBottomSheet!.counter > 0) {
                                        //               widget.productListBottomSheet!.counter--;
                                        //               print(widget.productListBottomSheet!.counter);
                                        //               if(widget.productListBottomSheet!.counter == 0){
                                        //                 // OrderModel _orderModel = OrderModel(Barcode: myList1[index].itemName,Quantity: myList1[index].counter,Price: 420,ItemComment: 'testComment',DealItems: []);
                                        //                 // String orderData = jsonEncode(_orderModel);
                                        //                 // print(orderData);
                                        //                 // cartController.removeProduct(_orderModel);
                                        //                 cartController.products.removeWhere(((item,value)=>item.Barcode == widget.productListBottomSheet!.Barcode));
                                        //                 //cartController.removeProduct(myList1[index]);
                                        //               }
                                        //             }
                                        //           });
                                        //         },
                                        //         color: Color(0xFFC4996C),
                                        //       ),
                                        //       Text(widget.productListBottomSheet!.counter.toString()),
                                        //       IconButton(
                                        //         icon: Icon(Icons.add),
                                        //         iconSize: 30,
                                        //         color: Color(0xFFC4996C),
                                        //         onPressed: () {
                                        //           setState(() {
                                        //             widget.productListBottomSheet!.counter++;
                                        //             //cartController.addProduct(myList1[index]);
                                        //             if(widget.productListBottomSheet!.counter == 0){
                                        //               print('No items selected');
                                        //             }
                                        //             else{
                                        //               //cartController.addProduct(myList1[index]);
                                        //               // OrderModel _orderModel = OrderModel(
                                        //               //     Barcode:
                                        //               //     widget.productListBottomSheet!.barcode,
                                        //               //     Quantity: widget.productListBottomSheet!.counter
                                        //               //         .toDouble(),
                                        //               //     Price: widget.productListBottomSheet!
                                        //               //         .saleRate,
                                        //               //     ItemComment: _commentcontroller.text,
                                        //               //     DealItems: []);
                                        //               // String orderData =
                                        //               // jsonEncode(_orderModel);
                                        //               // print(orderData);
                                        //               // cartController
                                        //               //     .addProduct(_orderModel);
                                        //             }
                                        //           });
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              //       child: Text(
              //         'Modifiers',
              //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
              //       child: Container(
              //           width: 70,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.grey[400],
              //           ),
              //           child: Center(
              //               child: Text(
              //                 'Optional',
              //                 style: TextStyle(
              //                     fontSize: 13,
              //                     fontWeight: FontWeight.bold,
              //                     color: Color.fromARGB(255, 71, 70, 70)),
              //               ))),
              //     )
              //   ],
              // ),
              // customAddsonn('Extra Topping',Checkbox(
              //   value: this.value,
              //   onChanged: (value) {
              //     setState(() {
              //       this.value = value!;
              //     });
              //   },
              // ),),
              // customAddsonn('Extra Chicken',Checkbox(
              //   value: this.value2,
              //   onChanged: (value) {
              //     setState(() {
              //       this.value2 = value!;
              //     });
              //   },
              // ),),
              // customAddsonn('Extra Cheese',Checkbox(
              //   value: this.value3,
              //   onChanged: (value) {
              //     setState(() {
              //       this.value3 = value!;
              //     });
              //   },
              // ),),

              // Padding(
              //   padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              //   child: Text(
              //     'Comments',
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
              //   child: Text(
              //     '(Please let us know if we need to avoid anything)',
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              //   ),
              // ),

              // TextFormField(
              //   decoration: InputDecoration(
              //     hintText: ('eg no mayo'),

              //   ),
              // ),
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
                  onPressed: (){
                    // if(widget.productListBottomSheet!.counter == 0){
                    //   print('No items selected');
                    // }
                    // else{
                      //starterObjectsList.add(OrderModel(Barcode: myList1[index].itemName,Quantity: myList1[index].counter,Price: 420,ItemComment: 'testcomment'));
                      //cartController.addProduct(myList1[index]);
                      if(widget.productListBottomSheet!.ItemImage!.isEmpty){
                        OrderModel _orderModel = OrderModel(ItemName: widget.productListBottomSheet!.ItemName,
                            ItemImage: '',
                            Barcode: widget.productListBottomSheet!.Barcode,Quantity: widget.productListBottomSheet!.counter.toDouble(),Price: widget.productListBottomSheet!.Price,ItemComment: _commentcontroller.text,DealItems: []);
                        String orderData = jsonEncode(_orderModel);
                        print(orderData);
                        cartController.addProductFromEditorCartWidget(_orderModel, _commentcontroller.text);
                        setState(() {
                          var indexNew = cartController.products.keys.toList().indexWhere((user) => user.Barcode == widget.productListBottomSheet!.Barcode);
                          print('Index of particular Item: ${indexNew}');
                          cartController.products.keys.toList()[indexNew].ItemComment =  _commentcontroller.text;
                          print('Qty Increase: ${cartController.products.keys.toList()[indexNew].ItemComment}');
                        });
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
                       Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Cart(tableNo: widget.tableNo,saleInvoiceId: widget.invoiceNo,noOfPerson: widget.noOfGuests))));
                      }
                      else{
                        OrderModel _orderModel = OrderModel(ItemName: widget.productListBottomSheet!.ItemName,
                            ItemImage: widget.productListBottomSheet!.ItemImage!,
                            Barcode: widget.productListBottomSheet!.Barcode,Quantity: widget.productListBottomSheet!.counter.toDouble(),Price: widget.productListBottomSheet!.Price,ItemComment: _commentcontroller.text,DealItems: []);
                        String orderData = jsonEncode(_orderModel);
                        print(orderData);
                        cartController.addProductFromEditorCartWidget(_orderModel , _commentcontroller.text);
                        setState(() {
                          var indexNew = cartController.products.keys.toList().indexWhere((user) => user.Barcode == widget.productListBottomSheet!.Barcode);
                          print('Index of particular Item: ${indexNew}');
                          cartController.products.keys.toList()[indexNew].ItemComment =  _commentcontroller.text;
                          print('Qty Increase: ${cartController.products.keys.toList()[indexNew].ItemComment}');
                        });
                        setComment(_commentcontroller.text);
                        clearText();
                        showToast('Comment Updated Successfully',
                            context: context,
                            axis: Axis.horizontal,
                            backgroundColor: Color(0xFFb54f40),
                            textStyle: TextStyle(color: Colors.white),
                            alignment: Alignment.bottomLeft,
                            borderRadius: BorderRadius.zero,
                            position: StyledToastPosition.bottom);
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Cart(tableNo: widget.tableNo,saleInvoiceId: widget.invoiceNo,noOfPerson: widget.noOfGuests))));
                      }
                    // }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black, borderRadius: BorderRadius.circular(0.0)
                    ),
                    child: Center(
                        child:
                        Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                    margin: EdgeInsets.only(left: 10,right: 10),
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