// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:ts_app_development/DataLayer/Models/Orders/ProductModel.dart';
import 'package:ts_app_development/UserControls/CustomSnackBar/customSnackBar.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _itemCount = 0;

  List<ProductModel>? productModelList;
  List<ProductModel>? productModelListUpdated;

  @override
  void initState() {
    fetchProductData();
    super.initState();
  }

  Future<void> fetchProductData() async{
    String url = 'http://10.1.1.13:8081/TSBE/EStore/v3/Product?Fields=Barcode,Name,SaleRate,Detail,ImageItems&GroupByProductCategory=true';
    var response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Basic dGVjaG5vc3lzOlRlY2g3MTA=',
        'TS-AppKey':'foodsinn'
      },
    );
    if(response.statusCode == 200)
    {
      print(jsonDecode(response.body));
      var res = response.body;
      var jsonResponse = json.decode(res);
      productModelList = jsonDecode(response.body)
          .map((item) => ProductModel.fromJson(item))
          .toList()
          .cast<ProductModel>();

      print(productModelList!.length);

      setState(() {
        productModelListUpdated = productModelList;
      });
    }
    else
    {
      print(response.statusCode);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 234, 234),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ScrollableListTabView(
        tabHeight: 48,
        bodyAnimationDuration: const Duration(milliseconds: 150),
        tabAnimationCurve: Curves.easeOut,
        tabAnimationDuration: const Duration(milliseconds: 200),
        //style: TextStyle(color: Colors.white),
        tabs: [],
      ),
    );
  }
}