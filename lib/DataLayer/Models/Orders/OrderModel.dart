import 'dart:convert';

import 'package:ts_app_development/DataLayer/Models/Orders/DealSave.dart';

class OrderModel {
  String? ItemName;
  String? Barcode;
  double? Quantity;
  double? Price;
  String? ItemComment;
  String? ItemImage;

  List<DealSave>? DealItems;
  int counter =0;

  OrderModel({this.Barcode, this.Quantity, this.Price, this.ItemComment, this.ItemName , this.ItemImage, this.DealItems});

  OrderModel.fromJson(Map<String, dynamic> json) {
    ItemName = json['ItemName'];
    Barcode = json['Barcode'];
    Quantity = json['Quantity'];
    Price = json['Price'];
    ItemComment = json['ItemComment'];
    ItemImage = json['ItemImage'];
    DealItems = json['DealItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemName'] = this.ItemName;
    data['Barcode'] = this.Barcode;
    data['Quantity'] = this.Quantity;
    data['Price'] = this.Price;
    data['ItemComment'] = this.ItemComment;
    data['ItemImage'] = this.ItemImage;
    data['DealItems'] = this.DealItems;
    return data;
  }
}