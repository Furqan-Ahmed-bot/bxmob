// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, prefer_const_constructors, unused_local_variable, prefer_interpolation_to_compose_strings, unused_element, prefer_const_constructors_in_immutables, non_constant_identifier_names, unused_import, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Generic/APIConstant/apiConstant.dart';

class DashboardMenusForWeb extends StatefulWidget {
  final route;
  final appKey;
  final user;
  final userMap;
  final appurl;

  DashboardMenusForWeb(
      {Key? key, this.route, this.appKey, this.user, this.userMap, this.appurl})
      : super(key: key);

  @override
  State<DashboardMenusForWeb> createState() => _DashboardMenusForWebState();
}

class _DashboardMenusForWebState extends State<DashboardMenusForWeb> {
  String? route;
  String? appKey;
  Map<String, dynamic>? userMap;
  var loadingPercentage = 0;
  bool _isLoading = true;
  Future<void> _onListCookies() async {}
  @override
  void initState() {
    super.initState();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    //   void _openWeb() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final user = prefs.getString('user') ?? '';
    //   appKey = prefs.getString('appKey') ?? '';
    //   userMap = jsonDecode(user);
    // }

    //  NotificationsProvider dataProvider = Provider.of<NotificationsProvider>(context);
    //  print('Notifications ${dataProvider.notificationsData}');

    return Scaffold(
      // appBar: AppBar(
      //   actions: [],
      //   // backgroundColor: Colors.white,
      // ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: WebView(
                initialUrl: widget.appurl + '/technosys' + widget.route,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (url) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                initialCookies: [
                  WebViewCookie(
                    name: 'TSUID',
                    value: '${widget.userMap['UserId']}',
                    domain: widget.appurl,
                  ),
                  WebViewCookie(
                    name: 'TSAPP',
                    value: 'tssys',
                    domain: widget.appurl,
                  ),
                  WebViewCookie(
                    name: 'TSGUI',
                    value: '${widget.userMap['GUID']}',
                    domain: widget.appurl,
                  ),
                ]),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack()
        ],
      ),
    );
  }
}
