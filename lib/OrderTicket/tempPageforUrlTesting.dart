// // ignore_for_file: avoid_print, unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/platform_interface.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../DataLayer/Providers/FilterTaskDataProvider/filtertaskdata.dart';
// import '../DataLayer/Providers/LatLongProvider/latLongProvider.dart';

// class UrlTesting extends StatefulWidget {
//   final Url;
//   const UrlTesting({super.key, this.Url});

//   @override
//   State<UrlTesting> createState() => _UrlTestingState();
// }

// class _UrlTestingState extends State<UrlTesting> {
//   dynamic latlong;
//   @override
//   Widget build(BuildContext context) {
//     LatLongProvider latLongProvider = Provider.of<LatLongProvider>(context);

//     return WebView(
//       initialUrl: widget.Url,
//       //'https://goo.gl/maps/6xyDT7EkS78EHvmu7',
//       javascriptMode: JavascriptMode.disabled,
//       onPageStarted: (url) {
//         final innerString = RegExp(r'/@(.*)/').firstMatch(url)?.group(1);

//         final lat = innerString!.split(',');
//         print('Lat${double.parse(lat[0])}');
//         print('long${lat[1]}');
//         latLongProvider.setFilter(lat[0], lat[1]);
//         Navigator.of(context).pop();

//         //Get.back();
//       },
//       // onPageFinished: (url) {
//       //   final str = url;

//       //   // setState(() {
//       //   //   _isLoading = false;
//       //   // });
//       // },
//     );
//   }
// }
