// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors, unnecessary_null_comparison, prefer_if_null_operators, prefer_interpolation_to_compose_strings, unused_local_variable, unused_element, use_build_context_synchronously, avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_node/timeline_node.dart';
import 'package:http/http.dart' as http;

import '../DataLayer/Providers/UserProvider/userProvider.dart';
import '../Generic/APIConstant/apiConstant.dart';
import '../Generic/appConst.dart';
import 'newActivity.dart';

class Activity extends StatefulWidget {
  final isSupportMenu;
  final TaskTypeSN;
  final TaskNumber;
  final taskregisterid;
  final TaskTypeId;
  final TaskRegisterDetailId;
  final EstimationTime;
  final TaskDueDate;
  final ClientInformationId;
  final ClientContactPersonID;
  final PriorityId;
  final JobTypeId;
  final CommunicateTypeId;
  final TaskTypeID2;
  final Title;
  final JobDescription;

  Activity(
      {Key? key,
      this.isSupportMenu,
      this.taskregisterid,
      this.TaskTypeSN,
      this.TaskNumber,
      this.TaskTypeId,
      this.TaskRegisterDetailId,
      this.EstimationTime,
      this.TaskDueDate,
      this.ClientContactPersonID,
      this.ClientInformationId,
      this.JobTypeId,
      this.PriorityId,
      this.CommunicateTypeId,
      this.TaskTypeID2,
      this.Title,
      this.JobDescription})
      : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  // List Activity = [{
  //   'Assignee' : 'Furqan',
  //   'ActvityStatusSN' : 'Delivered',
  //   'ActivityDate' : '',
  //   'SupportPersonName' : ''
  // },
  //  {
  //   'Assignee' : 'Furqan',
  //   'ActvityStatusSN' : 'Delivered',
  //   'ActivityDate' : '',
  //   'SupportPersonName' : '',

  // }
  // ];
  List Activity = [];
  bool _isLoading = false;
  int CurrentUserId = 0;

  Future<void> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';

    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    String url = widget.isSupportMenu == true
        ? '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/GetActivity?TaskRegisterIds=${widget.taskregisterid}'
        : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetActivity?TaskRegisterIds=${widget.taskregisterid}';
    Map<String, dynamic> userMap = jsonDecode(user);
    var response = await http.get(Uri.parse(url),
        headers: widget.isSupportMenu == true
            ? <String, String>{
                "Content-type": 'application/json',
                "TS-AuthSign": prefs.getString('TSAuthSign') == null
                    ? ''
                    : prefs.getString('TSAuthSign').toString(),
                "TS-ClientId": ClientId.toString(),
                "TS-AppKey": appKey
              }
            : <String, String>{
                "UserId": "${userMap['UserId']}",
                "token": "${userMap['GUID']}",
                "Content-type": 'application/json'
              });
    setState(() {
      _isLoading = true;
    });
    if (response.statusCode == 200) {
      var res = response.body;
      dynamic data = json.decode(res);
      setState(() {
        Activity = data['Table'];
        _isLoading = false;
      });

      print('Activity List is ${Activity}');
    } else {
      print(response.statusCode);
    }
  }

  void DeleteActivity(int TaskRegisterActivityId) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';

    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    String Url =
        '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/DeleteTaskActivity?TaskRegisterActivityId=${TaskRegisterActivityId}';
    // String username = 'E00106228';
    // String password = 'Student9802';
    // String basicAuth =
    //     'Basic ' + base64Encode(utf8.encode('$username:$password'));
    Map<String, dynamic> userMap = jsonDecode(user);
    var response = await http.delete(
      Uri.parse(Url),
      headers: <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    if (response.statusCode == 200) {
      var res = response.body;
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    getActivities();
    super.initState();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    CurrentUserId = userProvider.userData['UserId'];
    final activityid = userProvider.userData['ActivityStatusId'];
    print('User Id is ${CurrentUserId}');
    print('User Id is ${activityid}');
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: CustomHomeIconAppBar(
        isSupportMenu: widget.isSupportMenu,
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      'Activity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 15),
                  child: Text(
                    widget.TaskTypeSN,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 0),
                  child: Text(
                    '# ${widget.TaskNumber}',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: InkWell(
                      onTap: () {
                        Get.to(newActivity(
                          TaskRegisterDetailId: widget.TaskRegisterDetailId,
                          TaskNumber: widget.TaskNumber,
                          TaskTypeSN: widget.TaskTypeSN,
                          TaskDueDate: widget.TaskDueDate,
                          EstimationTime: widget.EstimationTime,
                          IsSupportMenu: widget.isSupportMenu,
                          TaskTypeId: widget.TaskTypeId,
                          ClientContactPersonID: widget.ClientContactPersonID,
                          ClientInformationId: widget.ClientInformationId,
                          CommunicateTypeId: widget.CommunicateTypeId,
                          PriorityId: widget.PriorityId,
                          JobTypeId: widget.JobTypeId,
                          TaskTypeID2: widget.TaskTypeID2,
                          TaskRegisterId: widget.taskregisterid,
                          Title: widget.Title,
                          JobDescription: widget.JobDescription,
                        ));
                      },
                      child: Icon(
                        Icons.work_history,
                        color: Colors.blue,
                      )),
                ),
              ],
            ),
          ),
          _isLoading
              ? CircularProgressIndicator(
                  color: Colors.blue,
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Activity.length,
                    itemBuilder: (context, index) {
                      hexStringToColor(String hexColor) {
                        hexColor = hexColor.toUpperCase().replaceAll("#", "");
                        if (hexColor.length == 6) {
                          hexColor = "FF" + hexColor;
                        }
                        return Color(int.parse(hexColor, radix: 16));
                      }

                      String? dateTimeFormat;
                      if (Activity[index]['ActivityDate'] != null) {
                        String formateddate = Activity[index]['ActivityDate'];
                        DateTime now = DateTime.parse(formateddate == null
                            ? '2022-01-26T10:26:40'
                            : formateddate);
                        dateTimeFormat =
                            DateFormat('dd-MMM-yyyy HH:mm:ss').format(now);
                      }
                      return TimelineNode(
                        style: TimelineNodeStyle(
                            lineType: TimelineNodeLineType.Full,
                            preferredWidth: 26),
                        indicator: Padding(
                          padding: const EdgeInsets.all(0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Card(
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Color(0xFFFFFFFF),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(dateTimeFormat!),
                                        Spacer(),
                                        if (index == 0) ...[
                                          if (Activity[index]['UserId'] ==
                                              CurrentUserId) ...[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: InkWell(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Double Tap to Delete"),
                                                      ),
                                                    );
                                                  },
                                                  onDoubleTap: () {
                                                    setState(() {
                                                      DeleteActivity(Activity[
                                                              index][
                                                          'TaskRegisterActivityId']);
                                                      Activity.removeAt(index);
                                                      showToast(
                                                          'Activity Deleted Successfully',
                                                          context: context,
                                                          duration: Duration(
                                                              seconds: 3),
                                                          axis: Axis.horizontal,
                                                          backgroundColor:
                                                              Color(0xFFb54f40),
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          alignment:
                                                              Alignment.center,
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                          position:
                                                              StyledToastPosition
                                                                  .bottom);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  )),
                                            )
                                          ]
                                        ],
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Container(
                                              alignment: Alignment.center,
                                              color: Activity[index][
                                                          'ActvityStatusColor'] ==
                                                      null
                                                  ? Colors.green
                                                  : hexStringToColor(Activity[
                                                          index]
                                                      ['ActvityStatusColor']),
                                              height: 25,
                                              width: 60,
                                              child: Text(
                                                Activity[index]
                                                    ['ActvityStatusSN'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              Activity[index]
                                                  ['AssigneeNickName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (Activity[index]
                                                    ['AssignorNickName'] !=
                                                null) ...[
                                              Icon(
                                                Icons.arrow_back,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                Activity[index]
                                                    ['AssignorNickName'],
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ]
                                          ],
                                        ),
                                        if (Activity[index]['JobDescription'] !=
                                                null &&
                                            Activity[index]['JobDescription']
                                                .trim()
                                                .isNotEmpty) ...[
                                          Text(
                                              Activity[index]['JobDescription'])
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
