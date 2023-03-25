// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, camel_case_types, unnecessary_new, unused_local_variable, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, avoid_print, unnecessary_this, prefer_if_null_operators, prefer_interpolation_to_compose_strings, non_constant_identifier_names, empty_catches, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_contains, unnecessary_null_comparison, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/Generic/Functions/functions.dart';
import 'package:ts_app_development/OrderTicket/BottomBarItems/home.dart';
import 'package:ts_app_development/OrderTicket/supportTicket.dart';
import '../DataLayer/Providers/UserProvider/userProvider.dart';
import '../Generic/APIConstant/apiConstant.dart';
import '../Generic/appConst.dart';
import 'TaskShedular.dart';
import 'camera.dart';
import 'myTicket.dart';
import 'searchList.dart';

class Demo {
  final TaskRegisterDetailId;
  final TaskRegisterId;
  final TaskNumber;
  final TaskTypeSN;
  final TaskDueDate;
  final EstimationTime;
  final IsSupportMenu;
  final TaskTypeId;
  final CommunicateTypeId;
  final ClientContactPersonID;
  final PriorityId;
  final JobTypeId;
  final ClientInformationId;
  final TaskTypeID2;
  final Title;
  final JobDescription;

  Demo({
    this.TaskRegisterDetailId,
    this.TaskRegisterId,
    this.TaskNumber,
    this.TaskTypeSN,
    this.TaskDueDate,
    this.EstimationTime,
    this.IsSupportMenu,
    this.TaskTypeId,
    this.ClientContactPersonID,
    this.CommunicateTypeId,
    this.JobTypeId,
    this.PriorityId,
    this.ClientInformationId,
    this.TaskTypeID2,
    this.Title,
    this.JobDescription,
  });
}

class newActivity extends StatefulWidget {
  final TaskRegisterDetailId;
  final TaskRegisterId;
  final TaskNumber;
  final TaskTypeSN;
  final TaskDueDate;
  final EstimationTime;
  final IsSupportMenu;
  final TaskTypeId;
  final CommunicateTypeId;
  final ClientContactPersonID;
  final PriorityId;
  final JobTypeId;
  final ClientInformationId;
  final TaskTypeID2;
  final Title;
  final JobDescription;

  newActivity(
      {super.key,
      this.TaskRegisterDetailId,
      this.TaskRegisterId,
      this.TaskNumber,
      this.TaskTypeSN,
      this.TaskDueDate,
      this.EstimationTime,
      this.IsSupportMenu,
      this.TaskTypeId,
      this.ClientContactPersonID,
      this.CommunicateTypeId,
      this.JobTypeId,
      this.PriorityId,
      this.ClientInformationId,
      this.TaskTypeID2,
      this.Title,
      this.JobDescription});

  @override
  State<newActivity> createState() => _newActivityState();
}

class _newActivityState extends State<newActivity> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _ActivityDateTimecontroller =
      new TextEditingController();
  TextEditingController _DueDateController = new TextEditingController();
  TextEditingController _JobDescriptionController = new TextEditingController();
  TextEditingController _DueDateController1 = new TextEditingController();

  //String _initialValue = '';
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';
  dynamic clientName;
  dynamic clientid;
  Map clientData = {};
  String? formattedTime;
  bool _axisCount = false;
  List activityStatus = [];
  List assigneeList = [];
  List<dynamic> files = [];
  dynamic seletedActivityStatus;
  dynamic seletedEmployee = 'Select...';
  dynamic currentActivity = 'Select...';
  dynamic ActivityId;
  dynamic selectAssignee;
  dynamic AssigneeId;
  int EstimateHours = 0;
  int EstimatMin = 0;
  int totalEstimationTime = 0;
  bool _isLoading = false;
  bool _isLoading2 = false;
  bool _IsVisibleEstimationTime = true;
  bool _IsVisibleEmployeeInformation = true;
  dynamic videoPath;
  dynamic picturePath;

  void getActivityData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';

    String url =
        '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/ActivityStatusForNewActivity?TaskRegisterDetailId=${widget.TaskRegisterDetailId}';
    // String username = 'E00106228';
    // String password = 'Student9802';
    // String basicAuth =
    //     'Basic ' + base64Encode(utf8.encode('$username:$password'));
    Map<String, dynamic> userMap = jsonDecode(user);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    setState(() {
      _isLoading2 = true;
    });
    if (response.statusCode == 200) {
      var res = response.body;
      print('Response ${res}');
      dynamic data = json.decode(res);
      print('data is ${data}');
      activityStatus = data['Table'];
      assigneeList = data['Table1'];

      print('Assignee List ${assigneeList}');

      setState(() {
        _isLoading2 = false;
      });
    } else {
      print(response.statusCode);
      print('Err');
      setState(() {
        _isLoading2 = false;
      });
    }
  }

  Future<void> saveActivityData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = prefs.getString('user') ?? '';
      final appKey = prefs.getString('appKey') ?? '';

      // String username = 'E00106228';
      // String password = 'Student9802';
      // String basicAuth =
      //     'Basic ' + base64Encode(utf8.encode('$username:$password'));
      Map<String, dynamic> userMap = jsonDecode(user);

      var data = jsonEncode(<String, dynamic>{
        "ActivityStatusId": ActivityId,
        "TaskRegisterDetailId": widget.TaskRegisterDetailId,
        "JobDescription": _JobDescriptionController.text,
        "EmployeeInformationId":
            _IsVisibleEmployeeInformation == false ? '' : AssigneeId,
        "EstimatedTime": totalEstimationTime,
        "ActivityDate": _ActivityDateTimecontroller.text,
        "TaskDueDate": _DueDateController.text,

        //"Files": filesList
      });
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(
          Uri.parse(
            '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/SaveTaskActivity',
          ),
          headers: <String, String>{
            "UserId": "${userMap['UserId']}",
            "token": "${userMap['GUID']}",
            "Content-type": 'application/json'
          },
          body: data);
      print('response.body ${response.body}');
      dynamic responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        // if (AssigneeId != userMap['EmployeeInformationId']) {
        //   sendFcmNotification(responseData['TaskRegisterActivityId']);
        // }

        showToast(responseData['message'],
            context: context,
            duration: Duration(seconds: 2),
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.bottom);

        setState(() {
          _isLoading = false;
        });
        Get.to(myTicket(
          isSupportMenu: widget.IsSupportMenu,
        ));
      } else if (response.statusCode == 422) {
        // dynamic data = json.decode(response.body);
        // print(jsonDecode(response.body));
        showToast(responseData['message'],
            context: context,
            duration: Duration(seconds: 4),
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.bottom);

        setState(() {
          _isLoading = false;
        });
      } else {
        print('SomeThing Went Wrong');
        showToast('SomeThing Went Wrong',
            context: context,
            duration: Duration(seconds: 2),
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.bottom);
        setState(() {
          _isLoading = false;
        });
        print('Err');
      }
    } catch (e) {
      return print(e);
    }
  }

  saveAttachmentsData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/SaveUpdateTicketRecord2'));
    Map<String, dynamic> userMap = jsonDecode(user);
    //for token
    request.headers.addAll({
      "UserId": "${userMap['UserId']}",
      "token": "${userMap['GUID']}",
      "Content-type": 'application/json'
    });

//simple data
    // setState(() {
    //   _isLoading = true;
    // });
    request.fields["data"] = jsonEncode(<String, dynamic>{
      "ContactPersonId": widget.ClientContactPersonID,
      "JobTypeId": widget.JobTypeId,
      "TaskTypeId": widget.TaskTypeId,
      "PriorityId": widget.PriorityId,
      "Title": widget.Title,
      "ClientInformationId": widget.ClientInformationId,
      "Description": widget.JobDescription,
      "CommunicateTypeId": widget.CommunicateTypeId,
      "TaskRegisterId": widget.TaskRegisterId
      //"Files": filesList
    });
//files data
    for (var i = 0; i < files.length; i++) {
      final fileName = files[i]['name'].split('.');
      request.files.add(await http.MultipartFile.fromPath(
          "file_" + i.toString(), files[i]['path']));
    }

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    final responseData = json.decode(responsed.body);
    // print('respond data' + responseData);
    if (response.statusCode == 200) {
      print(responseData['TaskRegisterId']);
      print("SUCCESS");

      //clearText();
      //_Attachment_Picker2State.deleteFilesFromCache()//2023-01-17, furqan, todo: right method for creating widgets
      //removing recorded/cahced files
      try {
        for (var i = 0; i < files.length; i++) {
          if (files[i]['path']
              .contains('com.technosysint.bxmobileapp/cache/')) {
            final file = File(files[i]['path']);
            file.delete();
            print('deleted: ' + files[i]['path']);
          } //to do confirm for ios
        }
      } catch (e) {
        print('error in deleeting cached files');
      }
      setState(() {
        files.clear();
      });
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (BuildContext context) => super.widget),
      // );
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> myTicket(idx: selectedindex,)));

      // showToast('Record Added Successfully TaskNo${responseData['TaskNumber']}',
      //     context: context,
      //     duration: Duration(seconds: 3),
      //     axis: Axis.horizontal,
      //     backgroundColor: Color(0xFFb54f40),
      //     textStyle: TextStyle(color: Colors.white),
      //     alignment: Alignment.center,
      //     borderRadius: BorderRadius.zero,
      //     position: StyledToastPosition.center);
      print('Attachment Added Successfully');
    } else {
      print("ERROR");
      print(response.statusCode);
      showToast('Something Went Wrong',
          context: context,
          duration: Duration(seconds: 3),
          axis: Axis.horizontal,
          backgroundColor: Color(0xFFb54f40),
          textStyle: TextStyle(color: Colors.white),
          alignment: Alignment.center,
          borderRadius: BorderRadius.zero,
          position: StyledToastPosition.center);
      setState(() {
        _isLoading = false;
      });

      // showToast('Record Not Added',
      //     context: context,
      //     duration: Duration(seconds: 2),
      //     axis: Axis.horizontal,
      //     backgroundColor: Color(0xFFb54f40),
      //     textStyle: TextStyle(color: Colors.white),
      //     alignment: Alignment.center,
      //     borderRadius: BorderRadius.zero,
      //     position: StyledToastPosition.bottom);
    }
  }

  // void sendFcmNotification(dynamic TaskRegisterActivityId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final user = prefs.getString('user') ?? '';
  //   final appKey = prefs.getString('appKey') ?? '';
  //   UserSessionProvider userProvider =
  //       Provider.of<UserSessionProvider>(context, listen: false);
  //   final ClientId = userProvider.userData['TSCId'];
  //   String url = widget.IsSupportMenu == true
  //       ? '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/SendFcmNotification?TaskRegisterActivityId=${TaskRegisterActivityId}'
  //       : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/SendFcmNotification?TaskRegisterActivityId=${TaskRegisterActivityId}';
  //   Map<String, dynamic> userMap = jsonDecode(user);
  //   var response = await http.get(Uri.parse(url),
  //       headers: widget.IsSupportMenu == true
  //           ? <String, String>{
  //               "Content-type": 'application/json',
  //               "TS-AuthSign": prefs.getString('TSAuthSign') == null
  //                   ? ''
  //                   : prefs.getString('TSAuthSign').toString(),
  //               "TS-ClientId": ClientId.toString(),
  //               "TS-AppKey": appKey
  //             }
  //           : <String, String>{
  //               "UserId": "${userMap['UserId']}",
  //               "token": "${userMap['GUID']}",
  //               "Content-type": 'application/json'
  //             });

  //   if (response.statusCode == 200) {
  //     var res = response.body;
  //     dynamic data = json.decode(res);
  //     showToast('Notification Sent Successfully',
  //         context: context,
  //         duration: Duration(seconds: 3),
  //         axis: Axis.horizontal,
  //         backgroundColor: Color(0xFFb54f40),
  //         textStyle: TextStyle(color: Colors.white),
  //         alignment: Alignment.center,
  //         borderRadius: BorderRadius.zero,
  //         position: StyledToastPosition.center);
  //     print(response.body);
  //   } else {
  //     showToast('Notification Sent Fail',
  //         context: context,
  //         duration: Duration(seconds: 3),
  //         axis: Axis.horizontal,
  //         backgroundColor: Color(0xFFb54f40),
  //         textStyle: TextStyle(color: Colors.white),
  //         alignment: Alignment.center,
  //         borderRadius: BorderRadius.zero,
  //         position: StyledToastPosition.center);
  //     print(response.statusCode);
  //   }
  // }

  void getAssigneeData() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    seletedEmployee = prefe.getString('name');
    AssigneeId = prefe.getString('id');

    clientData = {
      'AssigneeName': seletedEmployee,
      'AssigneeId': AssigneeId,
    };
    print('userName  ${seletedEmployee}');
    print(clientData);
    print(clientData['ClientName']);

    setState(() {
      // clientName;
      //  userMap={'username' : clientName};
    });
    prefe.remove('name');
  }

  void EstimationTimeConversion(dynamic inputTime) {
    //name => doubleToMinuteAndHour

    double EstInMin = widget.EstimationTime / 60;
    print('Est in Min ${EstInMin}');
    String str = EstInMin.toString();

    if (str.indexOf('.') > -1) {
      var arr = str.split('.');
      EstimateHours = int.parse(arr[0]);
      EstimatMin = (double.parse('0.' + arr[1]) * 60).round();
    } else {
      EstimateHours = (widget.EstimationTime / 60).round();
    }

    //return [hour,minute]
    // double min = 322;
    // double EstInMin = min / 60;
    // print('Est in Min ${EstInMin}');
  }

  Future<void> validation() async {
    if (seletedActivityStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Activity Status is Required"),
        ),
      );
    } else if (seletedActivityStatus['IsRequiredEstimationTime'] &&
        totalEstimationTime == 00) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Estimation Time is Required"),
        ),
      );
    } else if (seletedActivityStatus['IsRequiredDescription'] &&
        _JobDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job Description is required"),
        ),
      );
    } else {
      saveActivityData();
      saveAttachmentsData();
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Ticket()));
    }
  }

  void video() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    videoPath = prefe.getString('videopath');

    final videoname = videoPath.split('/');

    if (videoPath != null) {
      files.add(<String, dynamic>{"name": videoname[6], "path": videoPath});
    }
    setState(() {
      print('Tis is ${videoPath}');
      print('list  ${files}');
      print(picturePath);
    });
    prefe.remove('videopath');
  }

  void picture() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    picturePath = prefe.getString('picturepath');
    final picturename = picturePath.split('/');
    if (picturePath != null) {
      files.add(<String, dynamic>{"name": picturename[6], "path": picturePath});
      setState(() {});

      prefe.remove('picturepath');
    }
  }

  // Future<void> FieldsVisiblity() async {
  //   if (seletedActivityStatus['IsRequiredJobDescription'] == true) {
  //     _IsVisible = true;
  //   } else {
  //     setState(() {
  //       _IsVisible = false;
  //     });
  //   }
  // }

  Future<void> FieldsVisiblity2() async {
    _IsVisibleEstimationTime =
        seletedActivityStatus['IsRequiredEstimationTime'];
    _IsVisibleEmployeeInformation =
        seletedActivityStatus['IsEmployeeInformation'];
  }

  void pickfile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    //  Uint8List  bytes = await  files![0].readAsBytesSync();fggfeg
    if (result != null) {
      if (files != null) {
        for (var i = 0; i < result.files.length; i++) {
          files.add(<String, dynamic>{
            'name': result.files[i].name,
            'path': result.files[i].path
          });
        }
      } else {
        files = result.files;
      }

      // pickedfile = result.files.first;
      print('Length  ${files.length}');
      setState(() {
        //  addmapdata();
        print('List ${files}');
        print('Result file is ${result.files}');

        // print('name ${file}');
        // displayfilename = file.name.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getActivityData();
    _ActivityDateTimecontroller =
        TextEditingController(text: DateTime.now().toString());
    _DueDateController.text = widget.TaskDueDate;
    // _DueDateController1 =
    //     TextEditingController(text: DateTime.now().toString());
    _isLoading2 = true;
    if (widget.EstimationTime != null) {
      List hourAndMinute =
          Functions.doubleMinuteToHourMinute(widget.EstimationTime);
      EstimateHours = hourAndMinute[0];
      EstimatMin = hourAndMinute[1];
    }
    // EstimationTimeConversion(0);
    // _controller2 = TextEditingController(text: DateTime.now().toString());

    // var date = DateTime.now();
    // formattedTime = DateFormat.Hms().format(date);
    // _controller4 = TextEditingController(text: formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.TaskDueDate != null) {
    //   String? dateTimeFormat;
    //   String formateddate = widget.TaskDueDate;
    //   DateTime now = DateTime.parse(formateddate);
    //   dateTimeFormat = DateFormat('EE, d-MMM-yyyy hh:mm a').format(now);
    //   _DueDateController.text = dateTimeFormat;
    // }

    print('EstimationTime is ${widget.EstimationTime}');
    totalEstimationTime = (EstimateHours * 60) + EstimatMin;
    var date = DateTime.now();
    String formattedTime = DateFormat.Hms().format(date);
    print(formattedTime);
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: CustomHomeIconAppBar(isSupportMenu: widget.IsSupportMenu),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Form(
          key: _oFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Text(
                          'New Activity',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: InkWell(
                          onTap: () {
                            Get.to(EmployeeTimeLine(
                              IsSupportMenu: widget.IsSupportMenu,
                              TaskNumber: widget.TaskNumber,
                              TaskTypeSN: widget.TaskTypeSN,
                            ));
                          },
                          child: Icon(
                            Icons.task,
                            color: Colors.blue,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Activity Status:',
                style: TextStyle(color: Colors.grey[600]),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   // decoration: BoxDecoration(border: Border.all(width: 2)),
              //   height: 100,
              //   width: 350,
              //   child: Scrollbar(
              //     thumbVisibility: true,
              //     child: GridView.count(
              //       crossAxisCount: _axisCount == true ? 1 : 3,
              //       childAspectRatio: (1 / .4),
              //       crossAxisSpacing: 0,
              //       mainAxisSpacing: 0,
              //       shrinkWrap: true,
              //       children: List.generate(
              //         activityStatus.length,
              //         (index) {
              //           return InkWell(
              //             onTap: () {
              //               setState(() {
              //                 selectActivity = activityStatus[index];
              //                 if (activityStatus[index] == selectActivity) {
              //                   setState(() {
              //                     _axisCount == true;
              //                   });
              //                 }
              //               });
              //             },
              //             child: Card(
              //               elevation: 5,
              //               child: Container(
              //                 width: 100,
              //                 alignment: Alignment.center,
              //                 decoration: BoxDecoration(
              //                   color: activityStatus[index] == selectActivity
              //                       ? AppConst.appColorPrimary
              //                       : Colors.white,
              //                   borderRadius: BorderRadius.all(
              //                     Radius.circular(0.0),
              //                   ),
              //                   // boxShadow: [
              //                   //   BoxShadow(
              //                   //     color: Color(0xffDDDDDD),
              //                   //     blurRadius: 6.0,
              //                   //     spreadRadius: 2.0,
              //                   //     offset: Offset(0.0, 0.0),
              //                   //   )
              //                   // ],
              //                 ),
              //                 child: Text(
              //                   activityStatus[index],
              //                   style: TextStyle(
              //                       color:
              //                           activityStatus[index] == selectActivity
              //                               ? Colors.white
              //                               : Colors.black),
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),

              // SizedBox(
              //   height: 10,
              // ),
              QuickLov(
                currentActivity: currentActivity,
                ExpanedWidget: _isLoading2
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: assigneeList.length < 4
                            ? (170 / 3)
                            : assigneeList.length < 7
                                ? (170 / 2)
                                : 170,
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 6,
                          child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: (1 / .4),
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            shrinkWrap: true,
                            children: List.generate(
                              activityStatus.length,
                              (index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      ActivityId = activityStatus[index]
                                          ['ActivityStatusId'];
                                      seletedActivityStatus =
                                          activityStatus[index];
                                      currentActivity =
                                          activityStatus[index]['ShortName'];
                                      // FieldsVisiblity();
                                      FieldsVisiblity2();
                                    });
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: InkWell(
                                      child: Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: activityStatus[index] ==
                                                  seletedActivityStatus
                                              ? AppConst.appColorPrimary
                                              : Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0.0),
                                          ),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Color(0xffDDDDDD),
                                          //     blurRadius: 6.0,
                                          //     spreadRadius: 2.0,
                                          //     offset: Offset(0.0, 0.0),
                                          //   )
                                          // ],
                                        ),
                                        child: Text(
                                          activityStatus[index]['ShortName']
                                              .toString(),
                                          style: TextStyle(
                                              color: activityStatus[index] ==
                                                      seletedActivityStatus
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 20,
              ),

              _IsVisibleEmployeeInformation == false
                  ? Container()
                  : Text(
                      'Assignee:',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
              _IsVisibleEmployeeInformation == false
                  ? Container()
                  : Container(
                      // duration: Duration(milliseconds: 500),
                      // width: _IsVisibleEmployeeInformation ? 450 : 0,
                      // height: _IsVisibleEmployeeInformation ? 200 : 0,
                      child: ExpandableNotifier(
                        initialExpanded: true,
                        child: ScrollOnExpand(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border(
                                    left: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0),
                                    right: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0),
                                    bottom: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0),
                                    top: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0))),

                            //elevation: 10,
                            child: Column(
                              children: [
                                Container(
                                  // height: _IsVisibleEmployeeInformation ? 0 : 145,
                                  // duration: Duration(microseconds: 00),
                                  child: ExpandablePanel(
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToExpand: true,
                                      tapBodyToCollapse: true,
                                      hasIcon: false,
                                    ),
                                    header: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 45,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                        seletedEmployee == null
                                                            ? 'Select...'
                                                            : seletedEmployee)),
                                                Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      Future<void> future =
                                                          showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                                                                return LOV(
                                                                  SpType: 48,
                                                                  fields: [
                                                                    'EmployeeName',
                                                                    'Designation',
                                                                    'Department'
                                                                  ],
                                                                  primaryField:
                                                                      'Id',
                                                                  hintText:
                                                                      'Select Employee',
                                                                  MultiSelection:
                                                                      false,
                                                                );
                                                              });
                                                      future.then((void
                                                              value) =>
                                                          getAssigneeData());
                                                      setState(() {});
                                                    },
                                                    child: Icon(Icons.list)),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  child: ExpandableIcon(
                                                    theme:
                                                        const ExpandableThemeData(
                                                      expandIcon:
                                                          Icons.arrow_right,
                                                      collapseIcon:
                                                          Icons.arrow_drop_down,
                                                      iconColor:
                                                          Color(0xFFC4996C),
                                                      iconSize: 30.0,
                                                      // iconRotationAngle: math.pi / 2,
                                                      // iconPadding: EdgeInsets.only(right: 5),
                                                      hasIcon: false,
                                                      // iconPlacement:
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                    collapsed: Container(),
                                    expanded: _isLoading2
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : AnimatedContainer(
                                            height: assigneeList.length < 4
                                                ? (170 / 3)
                                                : assigneeList.length < 7
                                                    ? (170 / 2)
                                                    : 170,
                                            duration:
                                                Duration(microseconds: 00),
                                            child: Scrollbar(
                                              thumbVisibility: true,
                                              thickness: 6,
                                              child: GridView.count(
                                                crossAxisCount: 3,
                                                childAspectRatio: (1 / .4),
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0,
                                                shrinkWrap: true,
                                                children: List.generate(
                                                  assigneeList.length,
                                                  (index) {
                                                    // if (index == activityStatus.length - 1) {
                                                    //   return ListTile(
                                                    //     leading: Text('Last index reached'),
                                                    //   );
                                                    // }
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectAssignee =
                                                              assigneeList[
                                                                  index];
                                                          AssigneeId = clientid !=
                                                                  null
                                                              ? clientid
                                                              : assigneeList[
                                                                      index][
                                                                  'EmployeeInformationId'];
                                                          this.seletedEmployee =
                                                              assigneeList[
                                                                      index][
                                                                  'AssigneeNickName'];
                                                        });
                                                      },
                                                      child:
                                                          _IsVisibleEmployeeInformation ==
                                                                  false
                                                              ? Container()
                                                              : Card(
                                                                  elevation: 3,
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: assigneeList[index] ==
                                                                              selectAssignee
                                                                          ? AppConst
                                                                              .appColorPrimary
                                                                          : Colors
                                                                              .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            0.0),
                                                                      ),
                                                                      // boxShadow: [
                                                                      //   BoxShadow(
                                                                      //     color: Color(0xffDDDDDD),
                                                                      //     blurRadius: 6.0,
                                                                      //     spreadRadius: 2.0,
                                                                      //     offset: Offset(0.0, 0.0),
                                                                      //   )
                                                                      // ],
                                                                    ),
                                                                    child: Text(
                                                                      assigneeList[index]
                                                                              [
                                                                              'AssigneeNickName']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: assigneeList[index] == selectAssignee
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              // Container(
              //   decoration:
              //       BoxDecoration(border: Border.all(color: Colors.grey)),
              //   height: 50,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Padding(
              //           padding: const EdgeInsets.only(left: 10),
              //           child: clientName == null
              //               ? Text(
              //                   'Assignee',
              //                   style: TextStyle(
              //                       color: Colors.grey[600], fontSize: 15),
              //                 )
              //               : Text(
              //                   clientName,
              //                   style: TextStyle(color: Colors.black),
              //                 )),
              //       InkWell(
              //         onTap: () {
              //           Future<void> future = showModalBottomSheet(
              //               isScrollControlled: true,
              //               context: context,
              //               builder: (BuildContext context) {
              //                 //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
              //                 return FilterNetworkListPage();
              //               });
              //           future.then((void value) => getClientData());
              //         },
              //         child: Padding(
              //           padding: const EdgeInsets.only(right: 20),
              //           child: Icon(Icons.list),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),

              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'EE, d-MMM-yyyy hh:mm a',
                controller: _ActivityDateTimecontroller,
                //initialValue: _initialValue,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                // icon: Icon(Icons.event),
                dateLabelText: 'Activity Date Time',

                use24HourFormat: true,
                locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChanged1 = val),
                validator: (val) {
                  setState(() => _valueToValidate1 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
              ),
              SizedBox(
                height: 10,
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'EE, d-MMM-yyyy hh:mm a',
                controller: _DueDateController,
                //initialValue: _initialValue,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                // icon: Icon(Icons.event),
                dateLabelText: 'Due Date',
                use24HourFormat: false,
                locale: Locale('en', 'US'),
                onChanged: (val) => setState(() => _valueChanged2 = val),
                validator: (val) {
                  setState(() => _valueToValidate2 = val ?? '');
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
              ),

              SizedBox(height: 20),
              _IsVisibleEstimationTime == false
                  ? Container()
                  : Container(
                      // duration: Duration(milliseconds: 800),
                      // // height: _IsVisibleEstimationTime == false ? 0 : 65,
                      // width: _IsVisibleEstimationTime == false ? 0 : 275,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Est. Time:',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            // duration: Duration(milliseconds: 800),
                            // width: _IsVisibleEstimationTime == false ? 0 : 205,
                            // height: _IsVisibleEstimationTime == false ? 0 : 65,
                            decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                border: Border(
                                    left: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0),
                                    right: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0),
                                    bottom: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0),
                                    top: BorderSide(
                                        color: Color.fromRGBO(0, 0, 0, .2),
                                        width: 1.0))),
                            child: Row(children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Hour',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                      Icon(
                                        FeatherIcons.arrowUp,
                                        color: Colors.grey,
                                        size: 12,
                                      ),
                                      Icon(
                                        FeatherIcons.arrowDown,
                                        color: Colors.grey,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    child: NumberPicker(
                                      value: EstimateHours,
                                      itemCount: 2,
                                      itemHeight: 40,
                                      minValue: 0,
                                      maxValue: 59,
                                      onChanged: (value) =>
                                          setState(() => EstimateHours = value),
                                      haptics: false,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Minute',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        Icon(
                                          FeatherIcons.arrowUp,
                                          color: Colors.grey,
                                          size: 12,
                                        ),
                                        Icon(
                                          FeatherIcons.arrowDown,
                                          color: Colors.grey,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: NumberPicker(
                                        value: EstimatMin,
                                        itemCount: 2,
                                        itemHeight: 40,
                                        minValue: 0,
                                        maxValue: 59,
                                        onChanged: (value) =>
                                            setState(() => EstimatMin = value),
                                        haptics: false,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          )
                        ],
                      ),
                    ),

              SizedBox(height: 20),
              Text(
                'Job Description:',
                style: TextStyle(color: Colors.grey[600]),
              ),

              Container(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  child: TextFormField(
                    controller: _JobDescriptionController,
                    decoration: InputDecoration(
                      // hintText: "Job Description",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 4,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Attachment_Picker2(
                files: files,
                getPictureandVideopath: IconButton(
                    onPressed: () {
                      Future<void> future = showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return CameraPage();
                          });
                      future.then((void value) => video());
                      future.then((value) => picture());
                    },
                    icon: Icon(Icons.camera_alt)),
              ),
              // Container(
              //   // width: 350,
              //   decoration: BoxDecoration(
              //       //  color: Colors.grey[300],
              //       border: Border.all(color: Colors.grey, width: 2)),
              //   child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           children: [
              //             SizedBox(
              //               width: 5,
              //             ),
              //             Text(
              //               'Attachments :',
              //               style: TextStyle(fontSize: 18),
              //             ),
              //             SizedBox(
              //               width: 100,
              //             ),
              //             IconButton(
              //                 onPressed: () {
              //                   //   _Attachment_PickerState().pickfile();
              //                   // pickfile();
              //                   pickfile();
              //                 },
              //                 icon: Icon(
              //                   Icons.attachment,
              //                   size: 30,
              //                 )),
              //             // IconButton(
              //             //     onPressed: () {},
              //             //     icon: Icon(
              //             //       Icons.mic,
              //             //       size: 30,
              //             //     )),
              //             IconButton(
              //                 onPressed: () {
              //                   // video();
              //                   Future<void> future = showModalBottomSheet(
              //                       isScrollControlled: true,
              //                       context: context,
              //                       builder: (BuildContext context) {
              //                         //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
              //                         return CameraPage();
              //                       });
              //                   future.then((void value) => video());
              //                   future.then((value) => picture());

              //                   //  camera(context);
              //                 },
              //                 icon: Icon(
              //                   Icons.camera_alt,
              //                   size: 30,
              //                 )),
              //           ],
              //         ),
              //         Center(child: Attachment_Picker(files: files)),
              //       ]),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 380,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppConst.appColorPrimary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            )),
                        onPressed: () {
                          validation();
                        },
                        child: Text('Add')),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickLov extends StatelessWidget {
  const QuickLov(
      {Key? key, required this.currentActivity, required this.ExpanedWidget})
      : super(key: key);

  final currentActivity;
  final Widget? ExpanedWidget;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: true,
      child: ScrollOnExpand(
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(
                  left: BorderSide(
                      color: Color.fromRGBO(0, 0, 0, .2), width: 1.0),
                  right: BorderSide(
                      color: Color.fromRGBO(0, 0, 0, .2), width: 1.0),
                  bottom: BorderSide(
                      color: Color.fromRGBO(0, 0, 0, .2), width: 1.0),
                  top: BorderSide(
                      color: Color.fromRGBO(0, 0, 0, .2), width: 1.0))),

          //elevation: 10,
          child: Column(
            children: [
              ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: false,
                  ),
                  header: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 45,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(currentActivity)),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ExpandableIcon(
                                  theme: const ExpandableThemeData(
                                    expandIcon: Icons.arrow_right,
                                    collapseIcon: Icons.arrow_drop_down,
                                    iconColor: Color(0xFFC4996C),
                                    iconSize: 30.0,
                                    // iconRotationAngle: math.pi / 2,
                                    // iconPadding: EdgeInsets.only(right: 5),
                                    hasIcon: false,
                                    // iconPlacement:
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  collapsed: Container(),
                  expanded: Container(
                    child: ExpanedWidget,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHomeIconAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  CustomHomeIconAppBar({
    Key? key,
    required this.isSupportMenu,
  }) : super(key: key);

  bool isSupportMenu;

  @override
  Size get preferredSize => Size.fromHeight(55);
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Support Ticket',
      ),
      backgroundColor: AppConst.appColorPrimary,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            onPressed: () {
              Get.to(myTicket(isSupportMenu: isSupportMenu));
            },
          ),
        )
      ],
    );
  }
}
