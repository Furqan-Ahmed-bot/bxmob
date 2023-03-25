// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// class LOV extends StatefulWidget {
//   const LOV({Key? key}) : super(key: key);

//   @override
//   State<LOV> createState() => _LOVState();
// }

// class _LOVState extends State<LOV> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         SizedBox(
//           height: 30,
//         ),
//         Center(
//           child: Container(
//             width: 350,
//             child: TextFormField(
//               decoration: InputDecoration(
//                   hintText: "Search Here...",
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   suffixIcon: Padding(
//                     padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
//                     child: Icon(
//                       Icons.search,
//                     ),
//                   ),
//                   contentPadding: EdgeInsets.only(left: 10),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(0),
//                       borderSide: BorderSide(color: Colors.black),
//                       gapPadding: 10),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(0),
//                     borderSide: BorderSide(color: Colors.black),
//                     gapPadding: 10,
//                   )),
//             ),
//           ),
//         ),
//       ],
//     ));
//   }
// }

// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfValues extends StatefulWidget {
  final String text;
  ValueChanged<String>? onChanged;
  final String hintText;
  IconData? icon;
  IconButton? btn;

  ListOfValues({
    Key? key,
    required this.text,
    this.onChanged,
    this.icon,
    required this.hintText,
    this.btn,
  }) : super(key: key);

  @override
  _ListOfValuesState createState() => _ListOfValuesState();
}

class _ListOfValuesState extends State<ListOfValues> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 50,
      // margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.transparent,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          // ignore: prefer_const_constructors
          //  suffixIcon:widget.btn,

          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.arrow_drop_down, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged!('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
