// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, avoid_print, prefer_if_null_operators, use_build_context_synchronously, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, missing_required_param, prefer_is_empty, unused_element

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/UserControls/LOV/ListOfValues.dart';

import '../Generic/APIConstant/apiConstant.dart';
import '../Generic/appConst.dart';

class LOV extends StatefulWidget {
  final SpType;
  final fields;
  final primaryField;
  final hintText;
  bool MultiSelection;
  LOV(
      {super.key,
      required this.SpType,
      required this.fields,
      required this.primaryField,
      this.hintText,
      required this.MultiSelection});

  @override
  LOVState createState() => LOVState();
}

class LOVState extends State<LOV> {
  // List<Book> books = [];
  List ClientData = [];
  List ClientsData = [];
  dynamic query = '';
  Timer? debouncer;
  bool _isLoading = false;
  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    // BooksApi();
    //  getEmployees(query);

    super.initState();

    // init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  void _sendDataBack(BuildContext context) {
    List l = controller.selectedIndexes;
    Navigator.pop(context, l);
  }

  // Future init() async {
  //   // final books = await BooksApi.getBooks(query);

  //   setState(() => this.books = books);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppConst.appColorPrimary,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
                BackButton(
                  color: Colors.white,
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                ),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Support Ticket',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ]),
        ),
        title: Text(''),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListOfValues(
              text: '',
              hintText: widget.hintText,
              icon: Icons.list,
              onChanged: getEmployees,
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              :
              // buildSearch(),
              Expanded(
                  child: ListView.builder(
                    itemCount: ClientsData.length,
                    itemBuilder: (context, index) {
                      // final book = books[index];

                      return InkWell(
                          onTap: () {
                            // if (widget.MultiSelection == true) {
                            // } else {
                            //   getData(ClientsData[index][widget.fields[0]],
                            //       ClientsData[index][widget.primaryField]);
                            //   Navigator.of(context).pop();
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: MultiSelectItem(
                              isSelecting: controller.isSelecting = true,
                              onSelected: () {
                                if (widget.MultiSelection == true) {
                                  setState(() {
                                    controller.toggle(ClientsData[index]['Id']);

                                    print(
                                        controller.selectedIndexes.toString());
                                  });
                                } else {
                                  getData(ClientsData[index][widget.fields[0]],
                                      ClientsData[index][widget.primaryField]);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      minHeight: 50,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 0.5,
                                                color: Colors.grey))),
                                    // height: 50,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var fieldIndex = 0;
                                              fieldIndex < widget.fields.length;
                                              fieldIndex++) ...[
                                            if (ClientsData[index][widget
                                                    .fields[fieldIndex]] !=
                                                null) ...[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      ClientsData[index][widget
                                                          .fields[fieldIndex]],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              fieldIndex == 0
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                          fontSize: 16),
                                                    ),
                                                    //Spacer(),
                                                  ],
                                                ),
                                              )
                                            ]
                                          ]
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Icon(Icons.check_circle,
                                            color: controller.isSelected(
                                                    ClientsData[index]['Id'])
                                                ? Colors.blue
                                                : Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                      // buildBook(book));
                    },
                  ),
                ),
          Container(
            width: 350,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppConst.appColorPrimary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    )),
                onPressed: () {
                  //vaildation();
                  _sendDataBack(context);
                },
                child: Text(
                    'Select ${controller.selectedIndexes.length == 0 ? '' : controller.selectedIndexes.length}')),
          ),
        ],
      ),
    );
  }

  // Widget buildSearch() => Padding(
  //   padding: const EdgeInsets.all(8.0),
  //   child: ListOfValues(
  //         text: query,
  //         hintText: 'Title or Author Name',
  //         onChanged: searchBook,

  //       ),
  // );
  // Widget buildBook(Book book) => ListTile(
  //       leading: Image.network(
  //         book.urlImage,
  //         fit: BoxFit.cover,
  //         width: 50,
  //         height: 50,
  //       ),
  //       title: Text(book.title),
  //       subtitle: Text(book.author),
  //     );

  Future<void> getData(name, id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('name', name);
    pref.setString('id', id.toString());
    print(name);
  }

  void getEmployees(String query) async => debounce(() async {
        setState(() {
          _isLoading = true;
        });
        List filterdata = [];
        final prefs = await SharedPreferences.getInstance();
        final user = prefs.getString('user') ?? '';
        final appKey = prefs.getString('appKey') ?? '';
        // String username = 'jahanzaib';
        // String password = 'j';
        // String basicAuth =
        //     'Basic ' + base64Encode(utf8.encode('$username:$password'));
        String url =
            '${prefs.getString('ApiUrl')}/TSBE/Reports/GetFilterData2/${widget.SpType}/0/0/${query.trim()}';
        Map<String, dynamic> userMap = jsonDecode(user);
        var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "UserId": "${userMap['UserId']}",
            "token": "${userMap['GUID']}",
            "Content-type": 'application/json'
          },
        );

        if (response.statusCode == 200) {
          print('Hello');
          var res = response.body;
          dynamic data = jsonDecode(res);

          setState(() {
            ClientsData = data['Table'];
            setState(() {
              _isLoading = false;
            });
            //  ClientsData = ClientData;
          });

          if (ClientsData.length == 0) {
            setState(() {
              _isLoading = false;
              print('No Data');
            });
          }

          print('Data is ${ClientsData}');
        } else {
          print(response.statusCode);
          showToast('No Data',
              context: context,
              duration: Duration(seconds: 3),
              axis: Axis.horizontal,
              backgroundColor: Color(0xFFb54f40),
              textStyle: TextStyle(color: Colors.white),
              alignment: Alignment.center,
              borderRadius: BorderRadius.zero,
              position: StyledToastPosition.center);
          setState(() {
            ClientsData.clear();
            _isLoading = false;
          });
        }
      });
}



// class BooksApi {
//   List data = [];
//   static Future<List<Book>> getBooks(String query) async {
//     final url = Uri.parse(
//         'https://gist.githubusercontent.com/JohannesMilke/d53fbbe9a1b7e7ca2645db13b995dc6f/raw/eace0e20f86cdde3352b2d92f699b6e9dedd8c70/books.json');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {

//       print('Hello');
//       final List books = json.decode(response.body);
//       print(response.body);
//       // dynamic data = json.decode(response.body);
//       // print('Data is ${data}');
      
//       // data.where((name){
//       //  final clientname = data['title'].toLowerCase();
       

//       // });
      

//       return books.map((json) => Book.fromJson(json)).where((book) {
//         final titleLower = book.title.toLowerCase();
//         final authorLower = book.author.toLowerCase();
//         final searchLower = query.toLowerCase();

//         return titleLower.contains(searchLower) ||
//             authorLower.contains(searchLower);
//       }).toList();
//     } else {
//       throw Exception();
//     }
//   }
// }

// class Book {
//   final int id;
//   final String title;
//   final String author;
//   final String urlImage;

//   const Book({
//     required this.id,
//     required this.author,
//     required this.title,
//     required this.urlImage,
//   });

//   factory Book.fromJson(Map<String, dynamic> json) => Book(
//         id: json['id'],
//         author: json['author'],
//         title: json['title'],
//         urlImage: json['urlImage'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'author': author,
//         'urlImage': urlImage,
//       };
// }



