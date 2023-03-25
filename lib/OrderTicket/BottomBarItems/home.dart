// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, equal_keys_in_map, prefer_if_null_operators, non_constant_identifier_names, use_build_context_synchronously, avoid_print, unused_import, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/Generic/appConst.dart';
import '../../DataLayer/Providers/FilterTaskDataProvider/filtertaskdata.dart';
import '../../DataLayer/Providers/UserProvider/userProvider.dart';
import '../../Generic/APIConstant/apiConstant.dart';
import '../../Screens/genericScreen.dart';
import '../TaskShedular.dart';
import '../filter.dart';
import '../myTicket.dart';
import '../searchBarwidget.dart';
import 'myOpenTickets.dart';
import 'package:collection/collection.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Home extends StatefulWidget {
  bool? isSupportMenu;
  final List? FilterData;
  Home({Key? key, this.isSupportMenu, this.FilterData}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedindex = 0;
  int ticketindex = 0;
  int priorityindex = 0;
  int jobtypeindex = 0;
  bool _isLoading = false;
  bool _flag = false;
  num totalcount = 0;

  final List<Map> myProducts =
      List.generate(4, (index) => {"id": index, "name": "Product $index"})
          .toList();
  List tasktype = [];
  List<dynamic> priority = [];
  List FilteredData = [];
  List Tasks = [];
  List<dynamic> ActivityStatusGroups = [];
  Map prioritydata = {};
  Map tasktypedata = {};
  Map data = {};
  int lengthpriority = 0;
  int lengthtask = 0;
  List newList = [];

  @override
  void initState() {
    _isLoading = true;
    GetTaskSummaryData();
    // GetTaskSummaryData('', '');
    print(widget.isSupportMenu);
    print('FilterList is ${widget.FilterData}');
    //prepareUrl();
    // groupdata();
    // video();
    super.initState();
  }

  String params = '';
  String ParametersForHomePage='';
  dynamic StartDate;
  dynamic EndDate;
  Map<String , String> Parameters = {};

  // String prepareUrl() {
  //   dynamic parameter;
  //   dynamic value;

  //   if (widget.FilterData != null) {
  //     for (var i = 0; i < widget.FilterData!.length; i++) {
  //       parameter = widget.FilterData![i]['Parameter'];
  //       value = widget.FilterData![i]['Value'];
  //       params += (i > 0 ? '&' : '') + parameter + '=' + value;
        
  //     }

  //     print('Parameter is  ${parameter}');

  //     print('value is ${value}');
  //     print(params);
  //   }
  //   return params;
  // }

  Future<String> perpareUrl(filterData) async {
    dynamic parameter;
    dynamic value;

    if (filterData != null) {
      for (var i = 0; i < filterData.length; i++) {
        parameter = filterData[i]['Parameter'];
        value = filterData[i]['Value'];
        StartDate = filterData[i]['StartDate'];
        EndDate = filterData[i]['EndDate'];
        ParametersForHomePage += (i > 0 ? '&' : '') + parameter + '=' + value;

        if(filterData[i]['Parameter'] == 'TaskTypeIds' || filterData[i]['Parameter'] == 'PriorityIds' || filterData[i]['Parameter'] == 'ActivityStatausIds'){
        
        }
        else{
           params += (i > 0 ? '&' : '') + parameter + '=' + value;


        }
       
        FilteredData = filterData;
      }

      print('Parameter is  ${parameter}');

      print('value is ${value}');
      print(params);
    }
    return params;
  }

   void addData() {

    if(FilteredData.isNotEmpty){
    for (var i = 0; i < FilteredData.length; i++) {
      newList.add(<String, dynamic>{FilteredData[i]['Parameter']: FilteredData[i]['Value']});
      
    }
    }
    

    print('NewListList ${newList}');
  }

  Future<void> GetTaskSummaryData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    String url;

    if (widget.isSupportMenu == true) {
      url =
          '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/GetTasksSummary?StartDate=2000-01-01&EndDate=2030-01-01&DateType=DataEntryDate&ClientInformationIds=${ClientId == null ? '0' : ClientId}';
      //${user['ClientInformation']}
      // ApiConstant.clientAPIs['tssys']!['baseURLLocal']
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
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
        var res = response.body;
        dynamic data = json.decode(res);

        setState(() {
          tasktype = data['Table'];
          lengthtask = data['Table'].length;
          priority = data['Table1'];
          lengthpriority = data['Table1'].length;
          Tasks = data['Table2'];
          // groupdata();
          prepareData();
          // group = data['Table2'];
          // group = data['Table2']
        });
        setState(() {
          _isLoading = false;
        });

        // print(response.body);
        // print('tasktype ${tasktype}');
        // print('priorityy ${priority}');

        // print('activity ${activit}');
      } else {
        print(response.statusCode);
        print('Err');
        showToast('No data',
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
      }
    } else {
      Map<String, dynamic> userMap = jsonDecode(user);

      url =
          '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetTasksSummary?StartDate=${StartDate == null ? '2000-01-01' : StartDate}&EndDate=${EndDate == null ? '2030-01-01' : EndDate}&DateType=DataEntryDate&${ParametersForHomePage.isEmpty ? 'EmployeeInformationIds=${userMap['EmployeeInformationId'] == null ? 0 : userMap['EmployeeInformationId']}' : ParametersForHomePage}';
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
      print(response.body);

      print('StartDate is ${StartDate}');
      print('EndDate is ${EndDate}');
      if (response.statusCode == 200) {
        var res = response.body;
        dynamic data = json.decode(res);

        setState(() {
          tasktype = data['Table'];
          lengthtask = data['Table'].length;
          priority = data['Table1'];
          lengthpriority = data['Table1'].length;
          Tasks = data['Table2'];
          // groupdata();
          prepareData();
          // group = data['Table2'];
          // group = data['Table2']
        });
        setState(() {
          _isLoading = false;
        });

        // print(response.body);
        // print('tasktype ${tasktype}');
        // print('priorityy ${priority}');

        // print('activity ${activit}');
      } else {
        showToast('Some Thing Went Wrong',
            context: context,
            duration: Duration(seconds: 3),
            axis: Axis.horizontal,
            backgroundColor: Color(0xFFb54f40),
            textStyle: TextStyle(color: Colors.white),
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            position: StyledToastPosition.center);
        print(response.statusCode);
        print('Err');
      }
    }
  }

  dynamic selectedTaskType;
  dynamic selectedPriority;
// selectedPriority={};
  void prepareData({String dataName = 'ActivityStatus'}) {
    //loader
    ActivityStatusGroups = [];
    for (var i = 0; i < Tasks.length; i++) {
      bool taskTypeTest =
          (selectedTaskType == null || selectedTaskType['TaskTypeId'] == null)
              ? true
              : Tasks[i]['TaskTypeId'] == selectedTaskType['TaskTypeId'];
      bool taskPriorityTest =
          (selectedPriority == null || selectedPriority['PriorityId'] == null)
              ? true
              : Tasks[i]['PriorityId'] == selectedPriority['PriorityId'];

      if (taskTypeTest && taskPriorityTest) {
        // if (ActivityStatusGroups.length>0) {
        var groupIdx = ActivityStatusGroups.indexWhere(
            (ele) => ele['ActivityStatusId'] == Tasks[i]['ActivityStatusId']);
        if (groupIdx != -1) {
          ActivityStatusGroups[groupIdx]['TaskCount'] += Tasks[i]['TaskCount'];
        } else //add a group
        {
          ActivityStatusGroups.add(data = {
            'ActivityStatusId': Tasks[i]['ActivityStatusId'],
            'ShortName': Tasks[i]['ShortName'],
            'TaskCount': Tasks[i]['TaskCount'],
            'Colour': Tasks[i]['ColorCode'],
            'PriorityId': Tasks[i]['PriorityId'],
            'TaskTypeId': Tasks[i]['TaskTypeId'],
            'ActivityStatusId': Tasks[i]['ActivityStatusId'],
            'TaskRegisterId': Tasks[i]['TaskRegisterId'],
            'Name': Tasks[i]['Name'],
          });
        }
        //  }
      }
    }
    //hiode loader
    setState(() {
      print('TaskCount ${ActivityStatusGroups}');
    });
  }

// void groupdata(){
//   setState(() {
//       for (var i = 0; i < Tasks.length; i++){
//      if (ActivityStatusGroups != null){

//         var groupIdx = ActivityStatusGroups.indexWhere((ele) =>  ele['ActivityStatusId']==Tasks[i]['ActivityStatusId']);
//          if(groupIdx!=-1) {
//       ActivityStatusGroups[groupIdx]['TaskCount']+=Tasks[i]['TaskCount'];
//      }
//      else{
//       ActivityStatusGroups.add(data = {
//           'ActivityStatusId': Tasks[i]['ActivityStatusId'],
//           'ShortName': Tasks[i]['ShortName'],
//           'TaskCount': Tasks[i]['TaskCount']
//         });

//      }

//   //    else {
//   //   print(" not present in the list");
//   // }

//      }

//   }
//   setState(() {
//      print('ActivityList ${ActivityStatusGroups}');
//   });

//   });

// }

  @override
  Widget build(BuildContext context) {
    addData();
    FilterTasksData filterProvider = Provider.of<FilterTasksData>(context);

    StartDate = filterProvider.selectedStartDate;
    EndDate = filterProvider.selectedEndDate;
    perpareUrl(filterProvider.getfilterData);

    var width = MediaQuery.of(context).size.width;

    for (var i = 0; i < priority.length; i++) {
      totalcount = totalcount + priority[i]['TaskCount'];
    }
    setState(() {
      print(totalcount);
    });

    if (_flag == false) {
      if (priority.length >= lengthpriority + 1 || priority.contains('All')) {
      } else {
        priority.insert(
            0,
            prioritydata = {
              'PriorityId': null,
              'ShortName': 'All',
              'Name': '',
              'ColorCode': '#C4D7ED',
              'TaskCount': totalcount,
            });
        selectedPriority = priority[0];
      }

      if (tasktype.length >= lengthtask + 1 || tasktype.contains('All')) {
      } else {
        tasktype.insert(
            0,
            tasktypedata = {
              'TaskTypeId': null,
              'ShortName': '',
              'Name': 'All',
              'ColorCode': '#ffa07a',
              'TaskCount': ''
            });
      }
    }

    // priority.add(priorityy = {
    //   'PriorityId': '',
    //   'ShortName': 'All',
    //   'Name': '',
    //   'ColorCode': '#C4D7ED',
    //   'TaskCount': '0'
    // });
    // tasktype.add(data = {'All' :'all'});
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            filterProvider.getfilterData.clear();
            Get.to(GenericScreen(
              route: '',
            ));
          },
        ),
        title: Text(
          'Support Ticket',
        ),
        backgroundColor: AppConst.appColorPrimary,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: InkWell(
          //       onTap: () {
          //         Navigator.of(context).push(
          //             MaterialPageRoute(builder: (context) => SearchPage()));
          //       },
          //       child: Icon(Icons.search)),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: Icon(Icons.notifications),
          // ),
        ],
      ),
      endDrawer: Drawer(
        child: Filters(
          Caller: myTicket(
            isSupportMenu: widget.isSupportMenu,
          ),
        ),
      ),
      body: Container(
        child: Column(children: [
          Container(
            height: 55,
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Container(
                    height: 40,
                    color: Color(0xFFECECEC),
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.arrowUp,
                          color: Colors.grey,
                          size: 22,
                        ),
                        Icon(
                          FeatherIcons.arrowDown,
                          color: Colors.grey,
                          size: 22,
                        )
                      ],
                    )),
                // Padding(
                //   padding: const EdgeInsets.only(left: 40),
                //   // child: Container(
                //   //     alignment: Alignment.center,
                //   //     height: 40,
                //   //     color: Color(0xFFECECEC),
                //   //     child: Padding(
                //   //       padding: const EdgeInsets.only(left: 20),
                //   //       child: Text('Task Type:',
                //   //           style: TextStyle(color: Colors.grey, fontSize: 16)),
                //   //     )),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Container(
                    height: 40,
                    width: 300,
                    color: Color(0xFFECECEC),
                    child: ListWheelScrollView.useDelegate(
                        onSelectedItemChanged: (value) => {
                              selectedTaskType = tasktype[value],
                              _flag = true,

                              prepareData()

                              // groupdata()
                            },
                        itemExtent: 30,
                        perspective: 0.005,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: tasktype.length,
                          builder: (context, index) {
                            return Container(
                                alignment: Alignment.center,
                                height: 20,
                                width: 260,
                                // color: Colors.amber,

                                //  color: Colors.white,
                                child: tasktype[index] == selectedTaskType
                                    ? Text(
                                        '${tasktype[index]['Name']}'
                                        '  ${tasktype[index]['ShortName']}'
                                        '  ${tasktype[index]['TaskCount']}',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        '${tasktype[index]['Name']}'
                                        '  ${tasktype[index]['ShortName']}'
                                        '  ${tasktype[index]['TaskCount']}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17,
                                        ),
                                      ));
                          },
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: width * 3,
            height: 50,
            // color: Colors.white,
            child: ListView.builder(
                itemCount: priority.length,
                scrollDirection: Axis.horizontal,
                // shrinkWrap: true,
                itemBuilder: ((context, index) {
                  hexStringToColor(String hexColor) {
                    hexColor = priority[index]['ColorCode']
                        .toUpperCase()
                        .replaceAll("#", "");
                    if (hexColor.length == 6) {
                      hexColor = "FF" + hexColor;
                    }
                    return Color(int.parse(hexColor, radix: 16));
                  }

                  return InkWell(
                    onTap: (() {
                      setState(() {
                        selectedPriority = priority[index];
                        _flag = true;

                        prepareData();
                      });
                    }),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: priority[index] == selectedPriority
                              ? AppConst.appColorPrimary
                              : hexStringToColor(priority[index]['ColorCode']),
                        ),
                        alignment: Alignment.center,
                        // height: 30,
                        width: 80,
                        child: Text(
                          '${priority[index]['ShortName']} '
                          '${priority[index]['TaskCount']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                })),
          ),

          SizedBox(
            height: 10,
          ),
          // FloatingActionButton(
          //   onPressed: () {
          //     // groupdata();
          //     prepareData();
          //   },
          //   child: Text('Testing'),
          // ),

          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,

                          // childAspectRatio: 3 / 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2),
                      itemCount: ActivityStatusGroups.length,
                      itemBuilder: (BuildContext ctx, index) {
                        hexStringToColor(String hexColor) {
                          if (ActivityStatusGroups[index]['Colour'] != null) {
                            hexColor = ActivityStatusGroups[index]['Colour']
                                .toUpperCase()
                                .replaceAll("#", "");
                            if (hexColor.length == 6) {
                              hexColor = "FF" + hexColor;
                            }
                            return Color(int.parse(hexColor, radix: 16));
                          } else {
                            hexColor = 'FFFFF5CC';
                          }
                        }

                        return InkWell(
                          onTap: () {
                        
                               Get.to(OpenTicket(
                              ActivityStatusId: ActivityStatusGroups[index]['ActivityStatusId']
                                  ,
                              TaskTypeId: 
                              
                              
                              selectedTaskType != null &&
                                      selectedTaskType['TaskTypeId'] != null
                                  ? selectedTaskType['TaskTypeId']
                                  : '',
                              PriorityId: 
                              
                              selectedPriority != null &&
                                      selectedPriority['PriorityId'] != null
                                  ? selectedPriority['PriorityId']
                                  : '',

                              ActvityStatus: ActivityStatusGroups[index]
                                  ['Name'],
                              isSupportMenu: widget.isSupportMenu,
                              Params: params,
                              ToDate: EndDate,
                              FromDate: StartDate,
                              parameterList: newList,
                            ));
                              
                               
                          },
                          child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  height: 320,
                                  width: 320,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          //  border: Border.all(
                                          //  color: Color(0xFFb54f40)
                                          // 	),
                                          color: hexStringToColor(
                                                      ActivityStatusGroups[
                                                          index]['Colour']) ==
                                                  null
                                              ? Color.fromARGB(
                                                  255, 71, 166, 245)
                                              : hexStringToColor(
                                                  ActivityStatusGroups[index]
                                                      ['Colour']),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          ActivityStatusGroups[index]
                                                  ['TaskCount']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        ActivityStatusGroups[index]
                                            ['ShortName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )

                              //   Container(
                              //     width: 400,
                              //     height: 400,
                              //     alignment: Alignment.center,
                              //     decoration: BoxDecoration(
                              //    border: Border.all(
                              //    color: Color(0xFFb54f40)
                              //   	),
                              //    shape: BoxShape.circle,
                              //  ),
                              //     child: Text(ActivityStatus[index]),
                              //   ),
                              ),
                        );
                      }),
                ),
          widget.isSupportMenu == false
              ? Padding(
                  padding: const EdgeInsets.only(left: 300, bottom: 20),
                  child: FloatingActionButton(
                    backgroundColor: AppConst.appColorPrimary,
                    onPressed: () {
                      Get.to(EmployeeTimeLine(
                        IsSupportMenu: widget.isSupportMenu,
                        TaskNumber: '',
                        TaskTypeSN: '',
                      ));
                    },
                    tooltip: 'Increment',
                    child: const Icon(Icons.task),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }

  ListView customList(List list, {int myindex = 0}) {
    return ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: (() {
              setState(() {
                myindex = index;
              });
            }),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: index == myindex
                      ? AppConst.appColorPrimary
                      : Colors.blueGrey,
                ),
                alignment: Alignment.center,
                height: 30,
                width: 60,
                child: Text(
                  list[index],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }));
  }
}
