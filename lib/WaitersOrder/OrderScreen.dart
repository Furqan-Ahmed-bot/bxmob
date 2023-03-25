// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, sort_child_properties_last, avoid_unnecessary_containers, avoid_print, prefer_if_null_operators, unnecessary_null_comparison, unnecessary_brace_in_string_interps, unused_local_variable, library_private_types_in_public_api, prefer_const_constructors_in_immutables, unused_import

import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/GetX/cartController.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/DealModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/ProductModel.dart';
import 'package:ts_app_development/DataLayer/Providers/ThemeProvider/themeProvider.dart';
import 'package:ts_app_development/UserControls/PageRouteBuilder/pageRouteBuilder.dart';
import 'package:ts_app_development/UserControls/PopUpDialog/popupDialog.dart';
import 'package:ts_app_development/WaitersOrder/SelectTable.dart';
import 'package:ts_app_development/WaitersOrder/cart_screen.dart';

import '../UserControls/MasterWidget/DealWidget.dart';
import '../UserControls/MasterWidget/EditorWidget.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage(
      {Key? key,
      required this.title,
      required this.tableNo,
      required this.saleInvoiceNo,
      required this.noOfPerson})
      : super(key: key);

  final String title;
  final String tableNo;
  final String saleInvoiceNo;
  final String noOfPerson;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OrdersPage> {
  List<DealModel>? dealModelList;
  List<DealModel>? dealModelListUpdated;

  List<ProductModel> productModelList = [];
  List<ProductModel>? productModelListUpdated;

  List<Products>? productList,
      friedChickenList,
      burgersList,
      sandwichesList,
      chineseList,
      noodlesRiceList,
      chickenKarahiList,
      muttonKarahiList,
      handiList,
      bbqList,
      rollsList,
      mocktailsShakesList,
      chargesList,
      coldBeveragesList,
      rotiParathaList,
      addOnsList,
      platterList,
      dessertIceCreamList,
      staffFoodlList,
      hotbeveragesList,
      steaksList,
      pastaList;

  Uint8List? _bytesImage;

  Uint8List? _byteImagess;

  var particularIndex;
  int counter = 0;

  var starterObjectsList = [];
  List mainProductList = [];
  final cartController = Get.put(CartController());

  final CartController _cartController = Get.find();

  String? cmtdata;
  bool _isLoading = false;
  bool _isImageEmpty = false;

  @override
  void initState() {
    _isLoading = true;
    fetchDealData();
    fetchProductData();

    super.initState();
  }

  Future<void> fetchDealData() async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';

    String url = '${prefs.getString('LocalApiUrl')}/TSBE/EStore/Deal';
    // Try reading data from the counter key. If it doesn't exist, return 0.
    // String username = 'jahanzaib';
    // String password = 'j';
    // String basicAuth = username + ":" + password;
    // String base64Credentials = new String(Base64.getEncoder().encode(plainCredentials.getBytes()));
    Map<String, dynamic> userMap = jsonDecode(user);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Authorization': basicAuth,
        // 'TS-AppKey':'ts',
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    setState(() {
      _isLoading = true;
    });
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      dealModelList = jsonDecode(response.body)
          .map((item) => DealModel.fromJson(item))
          .toList()
          .cast<DealModel>();

      // print('This isss ${dealModelList!.length}');
      // print(dealModelList![0]);

      dealModelListUpdated = dealModelList;
      // _isLoading = false;

    } else {
      print(response.statusCode);
    }
  }

  //To think, m.jahanzaib,hassan haroon, 2022-08-26: optimize for network cost, main cause is ImageItems ie base64 string
//======================================================
//==========================================

  Future<void> fetchProductData() async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    final SharedPreferences prefe = await SharedPreferences.getInstance();

    String url =
        '${prefe.getString('LocalApiUrl')}/TSBE/EStore/v3/Product?Fields=Barcode,Name,SaleRate,Detail,ImageItems&GroupByProductCategory=true';

    // /TSBE/Sales/Product?Fields=Barcode,Name,SaleRate,Detail,ImageItems&GroupByProductCategory=true';
    // /TSBE/EStore/v3/Product?Fields=Barcode,Name,SaleRate,Detail,ImageItems&GroupByProductCategory=true
    Map<String, dynamic> userMap = jsonDecode(user);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Authorization': 'Basic dGVjaG5vc3lzOlRlY2g3MTA=',
        'TS-AppKey': appKey,
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    setState(() {
      _isLoading = true;
    });
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      productModelList = jsonDecode(response.body)
          .map((item) => ProductModel.fromJson(item))
          .toList()
          .cast<ProductModel>();
      mainProductList = jsonDecode(response.body);
      print('My Product List ${mainProductList}');
      if (productModelList.isNotEmpty) {
        setState(() {
          // dealModelListUpdated = dealModelList;
          _isLoading = false;
        });
      }

      print('Product List is ${productModelList}');
    } else {
      print(response.statusCode);
      setState(() {
        // dealModelListUpdated = dealModelList;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // if (dealModelList == null &&
    //     dealModelListUpdated == null &&
    //     productList == null) {
    //   return PopUpDialog(
    //     title: 'Awaiting Result',
    //     content: IntrinsicHeight(
    //       child: Column(
    //         children: [
    //           SizedBox(
    //             width: 60,
    //             height: 60,
    //             child: CircularProgressIndicator(
    //               color: context.read<ThemeProvider>().selectedPrimaryColor,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     onPressYes: () => {},
    //     isAction: false,
    //     isCloseBtn: false,
    //     isHeader: false,
    //   );
    // }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (_cartController.products.length > 0) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  // title: const Text("Alert Dialog Box"),
                  content:
                      const Text("Are you sure you want to leave this Order"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        // Navigator.of(ctx).pop();
                        _cartController.clearCart();
                        Navigator.pushReplacement(
                            context,
                            CustomPageRouteBuilder.createRoute(
                                '/HandheldOrder'));
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("No"),
                    ),
                  ],
                ),
              );
              print('Unable To go Back');
            } else {
              Navigator.pushReplacement(context,
                  CustomPageRouteBuilder.createRoute('/HandheldOrder'));
            }
          },
        ),
        title: Text('Table No: ' + widget.tableNo),
        actions: [
          Stack(
            children: [
              Badge(
                position: BadgePosition.topEnd(top: 3, end: 3),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeColor: Colors.white,
                toAnimate: true,
                badgeContent:
                    Obx(() => Text(_cartController.products.length.toString())),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => Cart(
                            tableNo: widget.tableNo,
                            saleInvoiceId: widget.saleInvoiceNo,
                            noOfPerson: widget.noOfPerson))));
                  },
                  icon: const Icon(
                    Icons.table_bar_outlined,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ScrollableListTabView(
              tabHeight: 48,
              bodyAnimationDuration: const Duration(milliseconds: 150),
              tabAnimationCurve: Curves.easeOut,
              tabAnimationDuration: const Duration(milliseconds: 200),
              tabs: [
                for (var prdGrpIdx = 0;
                    prdGrpIdx < productModelList.length;
                    prdGrpIdx++) ...[
                  ScrollableListTab(
                    tab: ListTab(
                        borderColor: Colors.transparent,
                        activeBackgroundColor: Colors.transparent,
                        inactiveBackgroundColor: Color(0xFFC4996C),
                        label: Text(
                          productModelList[prdGrpIdx].productCategory!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        //activeBackgroundColor:  Color(0xFFb54f40),
                        borderRadius: BorderRadius.all(Radius.zero),
                        showIconOnList: false),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productModelList[prdGrpIdx].products!.length,
                      itemBuilder: (BuildContext context, int prdIdx) {
                        var groupProducts =
                            productModelList[prdGrpIdx].products![prdIdx];

                        // if(productList![index].counter > 0){
                        //   particularIndex = cartController.products.keys.toList().indexWhere((user) => user.Barcode == productList![index]
                        //       .barcode);
                        //   print('Index of particular Item: ${particularIndex}');
                        //   cartController.products.keys.toList()[particularIndex].Quantity =  productList![index].counter.toDouble();
                        //   print('Qty: ${cartController.products.keys.toList()[particularIndex].Quantity}');
                        // }

                        String str = productModelList![prdGrpIdx]
                            .products![prdIdx]
                            .saleRate
                            .toString();
                        var arr = str.split('.');
                        //print(arr[0]); //will print 466
                        //print(arr[1]); //will print 62

                        if (groupProducts.imageItems!.isEmpty ||
                            groupProducts.imageItems == null) {
                          _isImageEmpty = true;
                        } else {
                          _isImageEmpty = false;

                          _bytesImage = Base64Decoder().convert(
                              productModelList![prdGrpIdx]
                                  .products![prdIdx]
                                  .imageItems![0]
                                  .imageBlock!);
                        }
                        return GestureDetector(
                          onTap: () {
                            Future<void> future = showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  if (productModelList[prdGrpIdx]
                                      .products![prdIdx]
                                      .imageItems!
                                      .isEmpty) {
                                    return EditorWidget(
                                        itemName: groupProducts.name,
                                        price:
                                            groupProducts.saleRate.toString(),
                                        image: '',
                                        productListBottomSheet: groupProducts);
                                  } else {
                                    return EditorWidget(
                                      itemName: groupProducts.name,
                                      price: groupProducts.saleRate.toString(),
                                      image: groupProducts
                                          .imageItems![0].imageBlock!,
                                      productListBottomSheet: groupProducts,
                                    );
                                  }
                                });
                            future.then((void value) => _closeModal(cmtdata));
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
                                      height: 100,
                                      child: Row(
                                        children: [
                                          if (groupProducts
                                                  .imageItems!.isNotEmpty ||
                                              groupProducts.imageItems! !=
                                                  null) ...[
                                            _isImageEmpty
                                                ? Image.asset(
                                                    'assets/images/placeholder.png',
                                                    height: 80,
                                                    width: 80,
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Image.memory(
                                                      _bytesImage!,
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ] else ...[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Image.asset(
                                                'assets/images/placeholder.png',
                                                height: 80,
                                                width: 80,
                                              ),
                                            ),
                                          ],
                                          // if (groupProducts
                                          //         .imageItems!.isEmpty ||
                                          //     groupProducts.imageItems ==
                                          //         null) ...[
                                          //   Padding(
                                          //     padding: const EdgeInsets.only(
                                          //         left: 10),
                                          //     child: Image.asset(
                                          //       'assets/images/placeholder.png',
                                          //       height: 80,
                                          //       width: 80,
                                          //     ),
                                          //   ),
                                          // ],
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30),
                                                    child: Container(
                                                      width: 230,
                                                      child: Text(
                                                        groupProducts.name ==
                                                                null
                                                            ? 'No Name'
                                                            : groupProducts.name
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 40, 0),
                                                    child: Container(
                                                      height: 25,
                                                      width: 65,
                                                      child: Text(
                                                        arr[0],
                                                        // + arr[0],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.1,
                                                  ),
                                                  // // Spacer(),

                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    iconSize: 30,
                                                    onPressed: () {
                                                      setState(() {
                                                        // if (productList![index]
                                                        //     .counter >
                                                        //     0) {
                                                        //   productList![index].counter--;
                                                        //   print(productList![index]
                                                        //       .counter);
                                                        //   if (productList![index]
                                                        //       .counter ==
                                                        //       0) {
                                                        //     cartController.products
                                                        //         .removeWhere(((item,
                                                        //         value) =>
                                                        //     item.Barcode ==
                                                        //         productList![index]
                                                        //             .barcode));
                                                        //     //cartController.removeProduct(myList1[index]);
                                                        //   }
                                                        // }
                                                        if (groupProducts
                                                                .counter >
                                                            0) {
                                                          groupProducts
                                                              .counter--;
                                                          OrderModel _orderModel = OrderModel(
                                                              Barcode:
                                                                  groupProducts
                                                                      .barcode,
                                                              Quantity:
                                                                  groupProducts
                                                                      .counter
                                                                      .toDouble(),
                                                              Price: 0,
                                                              ItemComment: '',
                                                              DealItems: []);
                                                          String orderData =
                                                              jsonEncode(
                                                                  _orderModel);
                                                          print(orderData);
                                                          cartController
                                                              .decreaseQuantityUpdate(
                                                                  _orderModel);
                                                        }
                                                      });
                                                    },
                                                    color: Color(0xFFC4996C),
                                                  ),
                                                  Text(
                                                    groupProducts.counter !=
                                                            null
                                                        ? groupProducts.counter
                                                            .toString()
                                                        : '0',
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    iconSize: 30,
                                                    color: Color(0xFFC4996C),
                                                    onPressed: () {
                                                      setState(() {
                                                        groupProducts.counter++;

                                                        //cartController.addProduct(myList1[index]);
                                                        if (groupProducts
                                                                .counter ==
                                                            0) {
                                                          print(
                                                              'No items selected');
                                                        } else {
                                                          //cartController.addProduct(myList1[index]);
                                                          //if(productList![index].counter == 1){
                                                          if (groupProducts
                                                              .imageItems!
                                                              .isEmpty) {
                                                            OrderModel _orderModel =
                                                                OrderModel(
                                                                    ItemName:
                                                                        groupProducts
                                                                            .name,
                                                                    ItemImage:
                                                                        '',
                                                                    Barcode:
                                                                        groupProducts
                                                                            .barcode,
                                                                    Quantity: groupProducts
                                                                        .counter
                                                                        .toDouble(),
                                                                    // groupProducts[prdIdx]['counter']!.toDouble(),
                                                                    Price: groupProducts
                                                                        .saleRate,
                                                                    ItemComment:
                                                                        cmtdata,
                                                                    DealItems: []);
                                                            String orderData =
                                                                jsonEncode(
                                                                    _orderModel);
                                                            print(orderData);
                                                            cartController
                                                                .addProduct(
                                                                    _orderModel);
                                                          } else {
                                                            OrderModel
                                                                _orderModel =
                                                                OrderModel(
                                                                    ItemName:
                                                                        groupProducts
                                                                            .name,
                                                                    ItemImage: groupProducts
                                                                        .imageItems![
                                                                            0]
                                                                        .imageBlock!,
                                                                    // groupProducts[prdIdx].ImageItems![0].imageBlock!,
                                                                    Barcode:
                                                                        groupProducts
                                                                            .barcode,
                                                                    Quantity: 1,
                                                                    // groupProducts[prdIdx]['counter']!.toDouble(),
                                                                    Price: groupProducts
                                                                        .saleRate,
                                                                    ItemComment:
                                                                        cmtdata,
                                                                    DealItems: []);
                                                            String orderData =
                                                                jsonEncode(
                                                                    _orderModel);
                                                            print(orderData);
                                                            cartController
                                                                .addProduct(
                                                                    _orderModel);
                                                          }

                                                          //}

                                                          // if(productList![index].counter > 1){
                                                          //   var indexNew = cartController.products.keys.toList().indexWhere((user) => user.Barcode == productList![index]
                                                          //       .barcode);
                                                          //   print('Index of particular Item: ${indexNew}');
                                                          //   setState(() {
                                                          //     cartContre00106oller.products.keys.toList()[indexNew].Quantity =  productList![index].counter.toDouble();
                                                          //     print('Qty: ${cartController.products.keys.toList()[indexNew].Quantity}');
                                                          //     //cartController.products.keys.toList().refrsh();
                                                          //     //cartController.products.keys.toList();
                                                          //   });
                                                          // }
                                                        }
                                                      });

                                                      print(groupProducts
                                                          .counter);
                                                    },
                                                    splashColor: Colors.blue,
                                                  ),
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (dealModelListUpdated?.length == null ||
                    dealModelListUpdated!.isEmpty) ...[
                  ScrollableListTab(
                      tab: ListTab(label: Text('')),
                      body: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 0,
                          itemBuilder: (contex, index) {
                            return Container();
                          }))
                ] else ...[
                  ScrollableListTab(
                    tab: ListTab(
                        borderColor: Colors.transparent,
                        activeBackgroundColor: Colors.transparent,
                        inactiveBackgroundColor: Color(0xFFC4996C),
                        label: Text(
                          'Deals',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        //activeBackgroundColor:  Color(0xFFb54f40),
                        borderRadius: BorderRadius.all(Radius.zero),
                        showIconOnList: false),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dealModelListUpdated!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (dealModelListUpdated![index].imageBlock == null) {
                        } else {
                          _bytesImage = Base64Decoder().convert(
                              dealModelListUpdated![index].imageBlock!);
                        }

                        String str =
                            dealModelListUpdated![index].saleRate.toString();

                        // }
                        var deals = str.split('.');

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return DealWidget(
                                    itemName: dealModelListUpdated![index].deal,
                                    barcode:
                                        dealModelListUpdated![index].barcode,
                                    price: dealModelListUpdated![index]
                                        .saleRate
                                        .toString(),
                                    itemImage:
                                        dealModelListUpdated![index].imageBlock,
                                    dealList:
                                        dealModelListUpdated![index].itemgroups,
                                  );
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
                                      height: 100,
                                      child: Row(
                                        children: [
                                          dealModelListUpdated![index]
                                                      .imageBlock ==
                                                  null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Image.asset(
                                                    'assets/images/placeholder.png',
                                                    height: 80,
                                                    width: 80,
                                                  ))
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Image.memory(
                                                    _bytesImage!,
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),

                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Container(
                                                  child: Text(
                                                    '${dealModelListUpdated![index].deal}',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 40, 0),
                                                child: Container(
                                                  height: 25,
                                                  width: 80,
                                                  child: Text(
                                                    'Rs ' + deals[0],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              // GestureDetector(
                                              //   onTap: (){
                                              //     // if(myList5[index].counter == 0){
                                              //     //   print('No items selected');
                                              //     // }
                                              //     // else{
                                              //     //   cartController.addProduct(myList5[index]);
                                              //     // }
                                              //   },
                                              //   child: Container(
                                              //     decoration: BoxDecoration(
                                              //         color: Colors.black,
                                              //         borderRadius: BorderRadius.circular(0.0)
                                              //     ),
                                              //     child: Center(
                                              //         child:
                                              //         Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 12),)),
                                              //     margin: EdgeInsets.only(left: 10,right: 10),
                                              //     height: 25,
                                              //     width: 100,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          Spacer(),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: <Widget>[
                                          //     IconButton(
                                          //       icon: Icon(Icons.remove),
                                          //       iconSize: 30,
                                          //       onPressed: () {
                                          //         setState(() {
                                          //           if (dealModelListUpdated![index].counter > 0) {
                                          //             dealModelListUpdated![index].counter--;
                                          //             if(dealModelListUpdated![index].counter == 0){
                                          //               //cartController.removeProduct(myList5[index]);
                                          //             }
                                          //           }
                                          //         });
                                          //       },
                                          //       color: Color(0xFFC4996C),
                                          //     ),
                                          //     Text(dealModelListUpdated![index].counter.toString()),
                                          //     IconButton(
                                          //       icon: Icon(Icons.add),
                                          //       iconSize: 30,
                                          //       color: Color(0xFFC4996C),
                                          //       onPressed: () {
                                          //         setState(() {
                                          //           dealModelListUpdated![index].counter++;
                                          //         });
                                          //       },
                                          //     ),
                                          //   ],
                                          // )
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ]
              ],
            ),
    );
  }

  void _closeModal(String? valueone) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    cmtdata = pref.getString('commentdata');
    setState(() {
      print('Tis is ${cmtdata}');
    });
  }
}
