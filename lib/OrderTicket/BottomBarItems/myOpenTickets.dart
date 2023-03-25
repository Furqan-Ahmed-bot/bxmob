// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_if_null_operators, void_checks, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, avoid_print, unused_local_variable, must_be_immutable, unused_import, curly_braces_in_flow_control_structures, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/Generic/appConst.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/OrderTicket/Activity.dart';
import 'package:ts_app_development/OrderTicket/supportTicket.dart';
import '../../DataLayer/Providers/FilterTaskDataProvider/filtertaskdata.dart';
import '../../DataLayer/Providers/UserProvider/userProvider.dart';
import '../../Generic/APIConstant/apiConstant.dart';
import '../../Screens/genericScreen.dart';
import '../../UserControls/LOV/ListOfValues.dart';
import '../filter.dart';
import '../myTicket.dart';
import '../newActivity.dart';
import 'home.dart';
import 'ticketDetails.dart';
import 'ticketDetails.dart';

class OpenTicket extends StatefulWidget {
  final ActivityStatusId;
  final TaskTypeId;
  final PriorityId;
  final ActvityStatus;
  bool? isSupportMenu;
  final EmployeeInformationIds;
  final FromDate;
  final ToDate;
  final DateType;
  bool? isSupportBarPage;
  final Params;
  List? parameterList;

  OpenTicket(
      {Key? key,
      this.ActivityStatusId = '',
      this.TaskTypeId = '',
      this.PriorityId = '',
      this.ActvityStatus,
      this.isSupportMenu,
      this.EmployeeInformationIds,
      this.FromDate,
      this.ToDate,
      this.DateType,
      this.isSupportBarPage,
      this.Params,
      this.parameterList,
      })
      : super(key: key);

  @override
  State<OpenTicket> createState() => _OpenTicketState();
}

class _OpenTicketState extends State<OpenTicket> {
  bool _isLoading = false;
  List priority = ['Low', 'Normal', 'High', 'Critical'];
  List color = [Colors.green, Colors.blue, Colors.red, Colors.black];

  List TaskList = [];
  List TaskType = [];
  List SupportPersonData = [];
  int selected = 0;
  Timer? debouncer;
  String? notification;
  List notificationList = [];
  Map TaskRegisterIds = {};
  String taskTypeIds = '';
  String priorityIds = '';

  void getClientData() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    notification = prefe.getString('notifcations');
    notificationList = json.decode(notification!);
    print('userName  ${notification}');
    print('NotificationList ${notificationList}');

    // prefe.remove('name');
  }

  void getTaskRegisterIds() {
    for (var i = 0; i < notificationList.length; i++) {
      if (notificationList.contains('TaskRegisterId'))
        TaskRegisterIds.addAll(notificationList[i]['TaskRegisterId']);
    }
    print(TaskRegisterIds);
  }

  @override
  void initState() {
    _isLoading = true;
    TicketDetail(context);
    getClientData();
    print(widget.isSupportMenu);
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 700),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  String params = '';
  dynamic Start;
  dynamic End;

  Future<String> perpareUrl(filterData) async {
    dynamic parameter;
    dynamic value;

    if (filterData != null) {
      for (var i = 0; i < filterData.length; i++) {
        parameter = filterData[i]['Parameter'];
        value = filterData[i]['Value'];
        Start = filterData[i]['StartDate'];
        End = filterData[i]['EndDate'];
        params += (i > 0 ? '&' : '') + parameter + '=' + value;
      }

      print('Parameter is  ${parameter}');

      print('value is ${value}');
      print(params);
    }
    return params;
  }
   void getDataFromParameterList(){
    if(widget.parameterList !=null){
     
      for (var i = 0; i < widget.parameterList!.length; i++) {
        if( widget.parameterList![i]['TaskTypeIds'] != null){
          taskTypeIds =  widget.parameterList![i]['TaskTypeIds'];

        }
        else{
          print('Not Found');
        }

      
       // taskTypeIds = widget.parameterList![i]['TaskTypeIds'] != null? widget.parameterList![i]['TaskTypeIds'] : '';

      }
        
        
      
      print('TaskTypeIds  ${taskTypeIds}');  
      print('PriorityType ${priorityIds}');
    }
  }

  Future<void> TicketDetail(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    String url;
    if (widget.isSupportMenu == true) {
      url =
          '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/GetTasks2?StartDate=2000-01-01&EndDate=2030-01-01&DateType=DataEntryDate&ClientInformationIds=${ClientId}&TaskTypeIds=${widget.TaskTypeId}&PriorityIds=${widget.PriorityId}&ActivityStatausIds=${widget.ActivityStatusId}';

      // // Try reading data from the counter key. If it doesn't exist, return 0.
      // String username = 'jahanzaib';
      // String password = 'j';
      // String basicAuth =
      //     'Basic ' + base64Encode(utf8.encode('$username:$password'));

      // Map<String, dynamic> userMap = jsonDecode(user);
      print(
          'authsign ${prefs.getString('TSAuthSign') != null ? '' : prefs.getString('TSAuthSign').toString()}');

      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          // 'TS-AppKey': 'ts',
          // "UserId" : "${userMap['UserId']}",
          // "token": "${userMap['GUID']}",
          "Content-type": 'application/json',
          "TS-AuthSign": prefs.getString('TSAuthSign') == null
              ? ''
              : prefs.getString('TSAuthSign').toString(),
          "TS-ClientId": ClientId.toString(),
          "TS-AppKey": appKey
        },
      );

      setState(() {
        _isLoading = true;
      });
      if (response.statusCode == 200) {
        print('IDDDDDD ${TaskRegisterIds}');
        print('Url is ${url}');
        var res = response.body;
        dynamic data = json.decode(res);
        TaskType = data['Table'];
        TaskList = TaskType;
        SupportPersonData = data['Table1'];

        setState(() {
          _isLoading = false;
        });
        print('Response ${Task}');
        print('supportperson ${SupportPersonData}');
      } else {  
        print(response.statusCode);
        print('Err');
      }
    } else {
      Map<String, dynamic> userMap = jsonDecode(user);
      url = widget.Params.isEmpty
          ? '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetTasks2?StartDate=${widget.FromDate == null ? '2000-01-01' : widget.FromDate}&EndDate=${widget.ToDate == null ? '2031-01-01' : widget.ToDate}&DateType=${widget.DateType == null ? 'DataEntryDate' : widget.DateType}&EmployeeInformationIds=${widget.EmployeeInformationIds == null ? userMap['EmployeeInformationId'] : widget.EmployeeInformationIds}&TaskTypeIds=${widget.TaskTypeId}&PriorityIds=${widget.PriorityId}&ActivityStatausIds=${widget.ActivityStatusId}'
          : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetTasks2?StartDate=${Start == null ? '2000-01-01' : Start}&EndDate=${End == null ? '2031-01-01' : End}&DateType=${widget.DateType == null ? 'DataEntryDate' : widget.DateType}&${widget.Params !=null? widget.Params: 'EmployeeInformationIds=${userMap['EmployeeInformationId']}'}&TaskTypeIds=${taskTypeIds.isEmpty?  widget.TaskTypeId: taskTypeIds}&PriorityIds=${widget.PriorityId}&ActivityStatausIds=${widget.ActivityStatusId}';

      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          // 'Authorization': basicAuth,
          // 'TS-AppKey':'ts',
          "UserId": "${userMap['UserId']}",
          "token": "${userMap['GUID']}",
          "Content-type": 'application/json'
        },
      );
      if (response.statusCode == 200) {
        var res = response.body;
        dynamic data = json.decode(res);
        TaskType = data['Table'];
        TaskList = TaskType;
        SupportPersonData = data['Table1'];

        setState(() {
          _isLoading = false;
        });
        print('Response ${data}');
        print('supportperson ${SupportPersonData}');
      } else {
        print(response.statusCode);
        print('Err');
      }
    }
  }

 

  void supportPersonImage({int? SupportEmployeeInformationId}) {
    for (var i = 0; i < SupportPersonData.length; i++) {
      if (SupportPersonData[i]['SupportEmployeeInformationId'] ==
          SupportEmployeeInformationId) {
        return SupportPersonData[i]['SupportPersonImageBlock'];
      }
    }
  }

  void search(String query) async => debounce(() async {
        List filterData = [];
        if (query.isEmpty) {
          setState(() {
            TaskList = TaskType;
          });
        } else {
          setState(() {
            TaskList = TaskType.where((item) => (item['TaskNumber']
                        .toLowerCase() +
                    item['TaskType'].toLowerCase() +
                    item['ActvityStatusSN'].toLowerCase() +
                    item['TaskTypeSN'].toLowerCase() +
                    item['SupportPersonName'].toLowerCase() +
                    item['TaskType'].toLowerCase() +
                    item['ActvityStatusSN'].toLowerCase() +
                    (item['TaskTypeSN'] + item['TaskNumber']).toLowerCase() +
                    item['ActvityStatus'].toLowerCase() +
                    item['SupportPersonNickName'].toLowerCase() +
                    item['PrioritySN'].toLowerCase() +
                    item['Priority'].toLowerCase() +
                    item['Title'].toLowerCase() +
                    item['ClientName'].toLowerCase() +
                    DateFormat('dd-MMM-yyyy')
                        .format(DateTime.parse(item['ActivityDate']))
                        .toLowerCase() +
                    item['AssigneeNickName'].toLowerCase())
                .contains(query.toLowerCase())).toList();
          });
        }
      });

  // Future searchBook(String query) async => debounce(() async {
  //       List filterData = [];
  //       if (query.isEmpty) {
  //         setState(() {
  //           filterData = TaskType;
  //         });
  //       } else {
  //         filterData = Task.where((user) =>
  //             user['TaskTypeSN'].toLowerCase().contains(query.toLowerCase()) ||
  //             user['TaskType'].toLowerCase().contains(query.toLowerCase()) ||
  //             user['ActvityStatusSN']
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()) ||
  //             user['ActvityStatus']
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()) ||
  //             user['SupportPersonName']
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()) ||
  //             user['TaskNumber'].toLowerCase().contains(query.toLowerCase()) ||
  //             user['PrioritySN'].toLowerCase().contains(query.toLowerCase()) ||
  //             user['ActivityDate']
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()) ||
  //             user['Priority']
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase())).toList();
  //       }

  //       setState(() {
  //         Task = filterData;
  //       });
  //     });

  @override
  Widget build(BuildContext context) {
    getDataFromParameterList();
    FilterTasksData filterProvider = Provider.of<FilterTasksData>(context);
    perpareUrl(filterProvider.getfilterData);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFECECEC),
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (widget.isSupportBarPage == true) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => myTicket(
                          isSupportMenu: widget.isSupportMenu,
                        )));
              }
              // Navigator.pop(context);
              // print('Hello');
            },
          ),
          //     leading: BackButton(
          //   onPressed: (){
          //     Get.to(myTicket());
          //   },
          // ),
          title: Text(
            'Support Ticket',
          ),
          backgroundColor: AppConst.appColorPrimary,
        ),
        // endDrawer: Drawer(
        //   child: Filters(
        //     Caller: OpenTicket(
        //       isSupportMenu: widget.isSupportMenu,
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Container(
              height: 50,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.ActvityStatus == null || widget.ActvityStatus == ''
                      ? Text(
                          'Tickets',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      : Text(widget.ActvityStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                  // Text('Date Created')
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
              child: ListOfValues(
                onChanged: ((value) {
                  search(value.trim());
                }),
                hintText: 'Search',
                text: '',
                icon: Icons.search,
              ),
            ),

            // SizedBox(
            //   height: 10,
            // ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: TaskList.length,
                        itemBuilder: ((context, index) {
                          hexStringToColor(String hexColor) {
                            if (hexColor != null) {
                              hexColor =
                                  hexColor.toUpperCase().replaceAll("#", "");
                              if (hexColor.length == 6) {
                                hexColor = "FF" + hexColor;
                              }
                              return Color(int.parse(hexColor, radix: 16));
                            } else {
                              return Colors.blue;
                            }
                          }

                          String? dateTimeFormat;
                          if (TaskList[index]['ActivityDate'] != null) {
                            String formateddate =
                                TaskList[index]['ActivityDate'];
                            DateTime now = DateTime.parse(formateddate == null
                                ? '2022-01-26T10:26:40'
                                : formateddate);
                            dateTimeFormat =
                                DateFormat('dd-MMM-yyyy').format(now);
                          }

                          return InkWell(
                            onTap: () {
                              //will make object and pass all data through the object
                              Get.to(TicketDetails(
                                  isSupportMenu: widget.isSupportMenu,
                                  TaskData: Task(
                                    TaskRegisterId: TaskList[index]
                                        ['TaskRegisterId'],
                                    TaskRegisterDetailId: TaskList[index]
                                        ['TaskRegisterDetailId'],
                                    TaskNumber: TaskList[index]['TaskNumber'],
                                    TaskTypeSN: TaskList[index]['TaskTypeSN'],
                                    Title: TaskList[index]['Title'],
                                    JobDescription: TaskList[index]
                                        ['JobDescription'],
                                    TransactionDate: TaskList[index]
                                        ['TransactionDate'],
                                    EstimatedTime: TaskList[index]
                                        ['EstimatedTime'],
                                    TaskDueDate: TaskList[index]['TaskDueDate'],
                                    ActivityDate: TaskList[index]
                                        ['ActivityDate'],
                                    CommunicateTypeId: TaskList[index]
                                        ['CommunicateTypeId'],
                                    ClientContact:
                                        TaskList[index]['ClientContact'] == null
                                            ? ''
                                            : TaskList[index]['ClientContact'],
                                    ClientInformationId: TaskList[index]
                                        ['ClientInformationId'],
                                    ClientName: TaskList[index]['ClientName'],
                                    ClientContactPersonId: TaskList[index]
                                        ['ClientContactPersonId'],
                                    TaskTypeId: TaskList[index]['TasktypeId'],
                                    TransactionNumberPrefix: TaskList[index]
                                        ['TransactionNumberPrefix'],
                                    TaskType: TaskList[index]['TaskType'],
                                    Priority: TaskList[index]['Priority'],
                                    PriorityId: TaskList[index]['PriorityId'],
                                    PrioritySN: TaskList[index]['PrioritySN'],
                                    PriorityColor: TaskList[index]
                                        ['PriorityColor'],
                                    ActivityStatus: TaskList[index]
                                        ['ActivityStatus'],
                                    ActivityStatusColor: TaskList[index]
                                        ['ActivityStatusColor'],
                                    AttachmentCount: TaskList[index]
                                        ['AttachmentCount'],
                                    SupportPersonName: TaskList[index]
                                        ['SupportPersonName'],
                                    JobTypeId: TaskList[index]['JobTypeId'],

                                    //                                   ),
                                    // priority: Task[index]['PrioritySN'],
                                    // priorityclr: Task[index]['PriorityColor'],
                                    // date: dateTimeFormat == null
                                    //     ? ''
                                    //     : dateTimeFormat,
                                    // tasktype: Task[index]['TaskTypeSN'],
                                    // tasktypeno: Task[index]['TaskNumber'],
                                    // activitystatus: Task[index]['ActvityStatusSN'],
                                    // activitystatuscolour: Task[index]
                                    //     ['ActvityStatusColor'],
                                    // supportpersonname: Task[index]
                                    //     ['SupportPersonNickName'],
                                    // tile: Task[index]['Title'],
                                    // jobdescription: Task[index]['JobDescription'],
                                    // fulldate: Task[index]['ActivityDate'],
                                    // clientname: Task[index]['ClientName'],
                                    // clientcontact:
                                    //     Task[index]['ClientContact'] == null
                                    //         ? ''
                                    //         : Task[index]['ClientContact'],
                                    // taskregisterdetailid: Task[index]
                                    //     ['TaskRegisterDetailId'],
                                    // attachmentcount: Task[index]['AttachmentCount'],
                                    // isSupportMenu: widget.isSupportMenu,
                                    // taskregisterid: Task[index]['TaskRegisterId'],
                                    // tasktypeid: widget.TaskTypeId,
                                    // taskDueDate: Task[index]['TaskDueDate'],
                                    // estimationTime: Task[index]['EstimatedTime'],
                                    // CommunicateTypeId: Task[index]
                                    //     ['CommunicateTypeId'],
                                    // ClientInformationId: Task[index]
                                    //     ['ClientInformationId'],
                                    // ClientContactPersonID: Task[index]
                                    //     ['ClientContactPersonID'],
                                    // PriorityId: Task[index]['PriorityId'],
                                    // JobTypeId: Task[index]['JobTypeId'],
                                    // TaskTypeID2: Task[index]['TasktypeId'],
                                    // Title: Task[index]['Title'],
                                  )));
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Card(
                                  elevation: 10,
                                  child: Container(
                                    // height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: Color(0xFFFFFFFF),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 1),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              widget.isSupportMenu == false
                                                  ? Container(
                                                      width: 200,
                                                      child: Text(
                                                        TaskList[index]
                                                            ['ClientName'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  : Text(''),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: TaskList[index][
                                                            'AssigneeNickName'] ==
                                                        null
                                                    ? Text('')
                                                    : Text(TaskList[index]
                                                        ['AssigneeNickName']),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Row(
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 20 , left: 20),
                                              //   child: Text('Ticket Number :' , style: TextStyle(fontSize: 16),),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, left: 15),
                                                child: Container(
                                                  // width: 80,
                                                  child: dateTimeFormat == null
                                                      ? Text('')
                                                      : Text(
                                                          dateTimeFormat,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            // overflow:TextOverflow.ellipsis
                                                          ),
                                                        ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, left: 15),
                                                child: Text(
                                                  TaskList[index]['TaskTypeSN'],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              // Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, left: 0),
                                                child: Text(
                                                  '${TaskList[index]['TaskNumber']}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              Spacer(),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, left: 20),
                                                child: Container(
                                                  // width: 60,
                                                  child: Text(
                                                    TaskList[index]
                                                        ['PrioritySN'],
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, left: 10),
                                                child: Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    color: hexStringToColor(
                                                        TaskList[index]
                                                            ['PriorityColor']),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0, right: 15),
                                                child: Container(
                                                  color: hexStringToColor(
                                                      TaskList[index][
                                                          'ActivityStatusColor']),
                                                  height: 25,
                                                  width: 70,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    TaskList[index]
                                                        ['ActivityStatusSN'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            // Padding(
                                            //     padding: const EdgeInsets.only(
                                            //         left: 10),
                                            //     child: CircleAvatar(
                                            //       backgroundImage: NetworkImage(
                                            //           'https://media.istockphoto.com/vectors/male-profile-icon-white-on-the-blue-background-vector-id470100848?k=20&m=470100848&s=612x612&w=0&h=ZfWwz2F2E8ZyaYEhFjRdVExvLpcuZHUhrPG3jOEbUAk='),
                                            //       radius: 15,
                                            //     )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0, left: 15),
                                              child: Container(
                                                  width: 300,
                                                  child: Text(
                                                    TaskList[index]['Title'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Container(
                                                height: 20,
                                                width: 300,
                                                child: TaskList[index][
                                                            'JobDescription'] ==
                                                        null
                                                    ? Text('No Description..')
                                                    : Text(
                                                        TaskList[index]
                                                            ['JobDescription'],
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Container(
                                                width: 200,
                                                child: Text(
                                                  TaskList[index]
                                                      ['SupportPersonNickName'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            // SizedBox(width: 150,),
                                            InkWell(
                                                onTap: () {
                                                  Get.to(newActivity(
                                                    TaskRegisterDetailId: TaskList[
                                                            index][
                                                        'TaskRegisterDetailId'],
                                                    TaskRegisterId:
                                                        TaskList[index]
                                                            ['TaskRegisterId'],
                                                    TaskNumber: TaskList[index]
                                                        ['TaskNumber'],
                                                    TaskTypeSN: TaskList[index]
                                                        ['TaskTypeSN'],
                                                    TaskDueDate: TaskList[index]
                                                        ['TaskDueDate'],
                                                    EstimationTime:
                                                        TaskList[index]
                                                            ['EstimatedTime'],
                                                    IsSupportMenu:
                                                        widget.isSupportMenu,
                                                    TaskTypeId: TaskList[index]
                                                        ['TasktypeId'],
                                                    ClientInformationId: TaskList[
                                                            index]
                                                        ['ClientInformationId'],
                                                    ClientContactPersonID:
                                                        TaskList[index][
                                                            'ClientContactPersonID'],
                                                    CommunicateTypeId: TaskList[
                                                            index]
                                                        ['CommunicateTypeId'],
                                                    PriorityId: TaskList[index]
                                                        ['PriorityId'],
                                                    JobTypeId: TaskList[index]
                                                        ['JobTypeId'],
                                                    TaskTypeID2: TaskList[index]
                                                        ['TasktypeId'],
                                                    Title: TaskList[index]
                                                        ['Title'],
                                                    JobDescription: TaskList[
                                                                    index][
                                                                'JobDescription'] !=
                                                            null
                                                        ? TaskList[index]
                                                            ['JobDescription']
                                                        : '',
                                                  ));
                                                },
                                                child: Icon(
                                                  Icons.work_history,
                                                  color:
                                                      AppConst.appColorPrimary,
                                                )),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Get.to(Activity(
                                                    isSupportMenu:
                                                        widget.isSupportMenu,
                                                    TaskRegisterDetailId: TaskList[
                                                            index][
                                                        'TaskRegisterDetailId'],
                                                    taskregisterid:
                                                        TaskList[index]
                                                            ['TaskRegisterId'],
                                                    TaskTypeSN: TaskList[index]
                                                        ['TaskTypeSN'],
                                                    TaskNumber: TaskList[index]
                                                        ['TaskNumber'],
                                                    ClientContactPersonID:
                                                        TaskList[index][
                                                            'ClientContactPersonID'],
                                                    ClientInformationId: TaskList[
                                                            index]
                                                        ['ClientInformationId'],
                                                    CommunicateTypeId: TaskList[
                                                            index]
                                                        ['CommunicateTypeId'],
                                                    PriorityId: TaskList[index]
                                                        ['PriorityId'],
                                                    JobTypeId: TaskList[index]
                                                        ['JobTypeId'],
                                                    TaskTypeID2: TaskList[index]
                                                        ['TasktypeId'],
                                                    Title: TaskList[index]
                                                        ['Title'],
                                                    JobDescription:
                                                        TaskList[index]
                                                            ['JobDescription'],
                                                  ));
                                                },
                                                child: TaskList[index][
                                                            'ActivityStatusId'] ==
                                                        1
                                                    ? Text('')
                                                    : Icon(
                                                        Icons.history,
                                                        color: AppConst
                                                            .appColorPrimary,
                                                      )),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(Icons.attachment_rounded),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            TaskList[index]
                                                        ['AttachmentCount'] ==
                                                    null
                                                ? Text('0')
                                                : Text(TaskList[index]
                                                        ['AttachmentCount']
                                                    .toString()),
                                            SizedBox(
                                              width: 15,
                                            ),

                                            Stack(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 28,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 11, top: 7),
                                                  child: TaskList[index]
                                                              ['Rating'] ==
                                                          null
                                                      ? Text(
                                                          '0',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        )
                                                      : Text(
                                                          TaskList[index]
                                                              ['Rating'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                )
                                              ],
                                            )
                                            // Container(
                                            //   height: 30,
                                            //   width: 100,
                                            //   alignment: Alignment.center,
                                            //   decoration: BoxDecoration(
                                            //     border: Border.all(color: Colors.grey),
                                            //   ),
                                            //   child: Text('Low'),
                                            // ),
                                            // Container(
                                            //   height: 30,
                                            //   width: 100,
                                            //   alignment: Alignment.center,
                                            //   decoration: BoxDecoration(
                                            //     border: Border.all(color: Colors.grey),
                                            //   ),
                                            //   child: Text('Attachments'),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        })),
                  ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: AppConst.appColorPrimary,
        //   onPressed: () {
        //     Get.to(Ticket());
        //   },
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
