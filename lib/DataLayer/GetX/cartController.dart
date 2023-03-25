import 'dart:convert';


import 'package:ts_app_development/DataLayer/Models/Orders/DealModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModel.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/OrderModelTest.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/Products.dart';
import 'package:get/get.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/StarterData.dart';

class CartController extends GetxController{
  var _products = {}.obs;

  //RxList<OrderModel> myList = <OrderModel>[].obs;

  var cartItems = <StarterData>[].obs;

  var numOfItems = 1.obs;

  var totalQuantity = 0.obs;

  // void addProductTest(OrderModelTest product) {
  //   if (_products.containsKey(product)) {
  //     _products[product] += 1;
  //   }
  //   else {
  //     _products[product] = product.Quantity;
  //   }
  // }

  void addProductFromEditorWidget(OrderModel orderProducts){
    Map<dynamic,dynamic> resP = Map<dynamic, dynamic>.from(_products.value);
    print(resP.keys.toList().contains(orderProducts.Barcode));
    if(_products.containsKey(orderProducts)){
      _products[orderProducts] +=1;
    }

    if(orderProducts.Quantity! > 1){
      var indexNew = _products.keys.toList().indexWhere((user) => user.Barcode == orderProducts.Barcode);
      print('Index of particular Item: ${indexNew}');
      _products.keys.toList()[indexNew].ItemComment =  orderProducts.ItemComment;
      print('Qty Increase: ${_products.keys.toList()[indexNew].ItemComment}');
      update();
    
    }

    else{
      _products[orderProducts] = orderProducts.Quantity;
      print('Particular Quantity: ${orderProducts.Quantity}');
      print('Items: ${_products[orderProducts.Quantity]}');
      //double itemQuantity = _products.keys.toList();
    }
  }

  void addProductFromEditorCartWidget(OrderModel orderProducts,String itemComment){
    // Map<dynamic,dynamic> resP = Map<dynamic, dynamic>.from(_products.value);
    // print(resP.keys.toList().contains(orderProducts.Barcode));
    // if(_products.containsKey(orderProducts)){
    //   _products[orderProducts] +=1;
    // }

    if(orderProducts.ItemComment!.isNotEmpty){
      var indexNew = _products.keys.toList().indexWhere((user) => user.Barcode == orderProducts.Barcode);
      print('Index of particular Item: ${indexNew}');
      _products.keys.toList()[indexNew].ItemComment =  itemComment;
      print('Qty Increase: ${_products.keys.toList()[indexNew].ItemComment}');
      update();

    }

    // else{
    //   _products[orderProducts] = orderProducts.Quantity;
    //   print('Particular Quantity: ${orderProducts.Quantity}');
    //   print('Items: ${_products[orderProducts.Quantity]}');
    //   //double itemQuantity = _products.keys.toList();
    // }
  }

  void addProduct(OrderModel product){
    Map<dynamic,dynamic> resP = Map<dynamic, dynamic>.from(_products.value);
    print(resP.keys.toList().contains(product.Barcode));
    if(_products.containsKey(product)){
      _products[product] +=1; 
    }

    if(product.Quantity! > 1){
      var indexNew = _products.keys.toList().indexWhere((user) => user.Barcode == product.Barcode);
      print('Index of particular Item: ${indexNew}');
      _products.keys.toList()[indexNew].Quantity =  product.Quantity;
      print('Qty Increase: ${_products.keys.toList()[indexNew].Quantity}');
      update();

    }

    else{
      _products[product] = product.Quantity;
      print('Particular Quantity: ${product.Quantity}');
      print('Items: ${_products[product.Quantity]}');
      //double itemQuantity = _products.keys.toList();
    }

    // Get.snackbar("Product Added" ,  "You Have Added the ${product.itemName} to the cart",
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: Duration(seconds: 1),
    // );
  }

  void deleteproduct(OrderModel product){
    
     if(_products[product] >= 1){
      //  _products.removeWhere((key, value) => key == product);
      _products[product] -=1;
     
    }
    else{
      _products.removeWhere((key, value) => key == product);
    }

  }
  //  void deleteproduct(OrderModel product){
     
  //   if(_products[product.Quantity] >= 1){
     
  //     _products[product] -=1; 
  //   }
  //   else {
  //     _products.removeWhere((key, value) => key == product);
  //   }
  
  // }

  void decreaseQuantityUpdate(OrderModel product){
    if(product.Quantity! >= 1){
      var indexNew = _products.keys.toList().indexWhere((user) => user.Barcode == product.Barcode);
      print('Index of particular Item: ${indexNew}');
      _products.keys.toList()[indexNew].Quantity =  product.Quantity;
      print('Qty Decrease: ${_products.keys.toList()[indexNew].Quantity}');
      update();
    }
    if (product.Quantity == 0) {
      _products
          .removeWhere(((item,value) =>
      item.Barcode == product.Barcode));
      //cartController.removeProduct(myList1[index]);
    }
  }

  void removeProduct(OrderModel product){
    if(_products.containsKey(product) && _products[product] == 1){
      _products.removeWhere((key, value) => key == product);
    }
    else{
      print('Item Decrease: ${_products[product]}');
      print('Map Key: ${_products.containsKey(product)}');
      _products[product] -= 1;
    }
 
  }
      void addProductInc(OrderModel product){
    Map<dynamic,dynamic> resP = Map<dynamic, dynamic>.from(_products.value);
    print(resP.keys.toList().contains(product.Barcode));
    if(_products.containsKey(product)){
      _products[product] +=1;
    }

    if(product.Quantity! > 5){
      var indexNew = _products.keys.toList().indexWhere((user) => user.Barcode == product.Barcode);
      print('Index of particular Item: ${indexNew}');
      _products.keys.toList()[indexNew].Quantity =  product.Quantity;
      print('Qty Increase: ${_products.keys.toList()[indexNew].Quantity}');
      update();
      print('Hello There');

    }

    else{
      _products[product] = product.Quantity;
      print('Particular Quantity: ${product.Quantity}');
      print('Items: ${_products[product.Quantity]}');
      //double itemQuantity = _products.keys.toList();
    }

    
  }

  void decreaseCounterValue(OrderModel product){
    if(_products.containsKey(product) && _products[product] == 1){
      _products.removeWhere((key, value) => key == product);
    }
    else{
      print('Item Decrease: ${_products[product]}');
      print('Map Key: ${_products.containsKey(product)}');
      _products[product] -= 1;
    }
    //_products[product] -= 1;
  }

  void addProductDeal(Items product){
    if(_products.containsKey(product)){
      _products[product] +=1;
    }
    else{
      _products[product] = product.counter;
    }

  
  }

  void removeProductDeal(Items product){
    if(_products.containsKey(product) && _products[product] > 0){
      _products.removeWhere((key, value) => key == product);
    }
    else{
      _products[product] -= 1;
    }

  }

  void clearCart(){
    _products.clear();
  }

  void addItemInCart(StarterData starterData){
    cartItems.add(starterData);
    totalQuantity.value = totalQuantity.value + numOfItems.value;
    numOfItems.value = 1;
  }

  void initializeQuantity(){
    numOfItems.value = 1;
  }
    void subproduct(OrderModel product){
    Map<dynamic,dynamic> resP = Map<dynamic, dynamic>.from(_products.value);
    print(resP.keys.toList().contains(product.Barcode));
    if(_products.containsKey(product)){
      _products[product] -=1; 
    }

  

    // Get.snackbar("Product Added" ,  "You Have Added the ${product.itemName} to the cart",
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: Duration(seconds: 1),
    // );
  }

  get products => _products;
  get productSubtotal => _products.entries.map((product) => product.key.Price * product.value).toList();
  double get total => _products.length > 0.0? _products.entries.map((product) => product.key.Price * product.key.Quantity).toList().reduce((value, element) => value + element): 0;
  // get getTotal => {
  //   if(_products.entries.map((product) => product.key.Price * product.key.Quantity).toList().isEmpty){
  //    print('Empty'),
  //   }
  //   else{
  //      _products.entries.map((product) => product.key.Price * product.key.Quantity).toList().reduce((value, element) => value + element).toString()
  //   }
  // };

  

  
    

   
  


}