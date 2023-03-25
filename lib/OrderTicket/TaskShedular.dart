// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/Generic/Functions/functions.dart';
import 'package:ts_app_development/OrderTicket/BottomBarItems/myOpenTickets.dart';
import 'package:ts_app_development/OrderTicket/newActivity.dart';

import '../Generic/appConst.dart';

class EmployeeTimeLine extends StatefulWidget {
  final IsSupportMenu;
  final TaskNumber;
  final TaskTypeSN;
  const EmployeeTimeLine(
      {super.key, this.IsSupportMenu, this.TaskNumber, this.TaskTypeSN});

  @override
  State<EmployeeTimeLine> createState() => _EmployeeTimeLineState();
}

class _EmployeeTimeLineState extends State<EmployeeTimeLine> {
  List TaskScheduler = [];
  bool _isLoading = false;
  void getEmployeeTimeline() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    Map<String, dynamic> userMap = jsonDecode(user);
    String url =
        '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/TaskScheduler?FromDate=2000-01-01&ToDate=2030-01-01&EmployeeInformationIds=${userMap['EmployeeInformationId']}';

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    setState(() {
      _isLoading = true;
    });
    if (response.statusCode == 200) {
      var res = response.body;
      dynamic data = json.decode(res);
      TaskScheduler = data;
      print('data is ${data}');

      setState(() {
        _isLoading = false;
      });
    } else {
      print(response.statusCode);
      print('Err');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployeeTimeline();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: CustomHomeIconAppBar(
        isSupportMenu: widget.IsSupportMenu,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    'Task Scheduler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: TaskScheduler.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        List hourAndMinute = Functions.doubleMinuteToHourMinute(
                            TaskScheduler[index]['EstimatedTime']);
                        int EstimateHours = hourAndMinute[0];
                        int EstimatMin = hourAndMinute[1];
                        return Padding(
                            padding: const EdgeInsets.all(0),
                            child:
                                // Container(
                                //     child: QuickLov(
                                //   ExpanedWidget: Container(),
                                //   currentActivity:
                                //       '${TaskScheduler[index]['Dated']}  ${TaskScheduler[index]['TaskCount']}  ${TaskScheduler[index]['EstimatedTime']}',
                                // )),
                                Card(
                              elevation: 10,
                              child: InkWell(
                                onTap: () {
                                  Get.to(OpenTicket(
                                      isSupportBarPage: true,
                                      isSupportMenu: widget.IsSupportMenu,
                                      ToDate: TaskScheduler[index]['ToDate'],
                                      FromDate: TaskScheduler[index]
                                          ['FromDate'],
                                      EmployeeInformationIds:
                                          TaskScheduler[index]
                                              ['EmployeeInformationId'],
                                      DateType: 'TaskDueDate'));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.date_range),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(TaskScheduler[index]
                                                    ['Dated']),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              children: [
                                                Icon(FeatherIcons.clock),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                      '${EstimateHours} hours ${EstimatMin} min'),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: Text(
                                                TaskScheduler[index]
                                                        ['TaskCount']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      }),
                )
        ],
      ),
    );
  }
}
