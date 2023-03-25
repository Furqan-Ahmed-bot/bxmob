// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, sized_box_for_whitespace, camel_case_types, list_remove_unrelated_type, unnecessary_new, unused_import, prefer_final_fields, unnecessary_this, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unused_element, non_constant_identifier_names, must_be_immutable, unused_field, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/Models/Ticket/ticketModal.dart';
import 'package:ts_app_development/Generic/appConst.dart';
import 'package:ts_app_development/OrderTicket/camera.dart';
import 'package:ts_app_development/OrderTicket/myTicket.dart';
import 'package:ts_app_development/OrderTicket/voiceRecorder.dart';
import 'package:ts_app_development/Screens/genericScreen.dart';
import 'package:ts_app_development/UserControls/FilePicker/filePicker.dart';
import 'package:ts_app_development/UserControls/LOV/ListOfValues.dart';
import 'package:http/http.dart' as http;
import '../DataLayer/Models/Orders/DealModel.dart';
import '../DataLayer/Providers/DataProvider/dataProvider.dart';
import '../DataLayer/Providers/UserProvider/userProvider.dart';
import '../Generic/APIConstant/apiConstant.dart';
import '../UserControls/AppDrawer/appDrawer.dart';
// import 'package:open_file/open_file.dart';
import 'searchList.dart';

class Ticket extends StatefulWidget {
  bool? isSupportMenu;
  Ticket({Key? key, this.isSupportMenu}) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  int selectedindex = 1;
  List<dynamic> files = [];
  List<dynamic> videodataa = [];
  dynamic priority;
  dynamic contactperson;
  dynamic tasktype;
  dynamic jobtype;
  dynamic filename;
  dynamic filesize;
  dynamic fileextension;
  dynamic filepath;
  Uint8List? bytes;
  bool _isLoading = false;
  bool _isPriorityLoader = false;
  Map clientData = {};
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterSoundPlayer? _audioPlayer;
  final recorder = FlutterSoundRecorder();
  dynamic recordedAudio;
  bool flag=false;
  // List communicationType = [
  //   {
  //   'CommunicateTypeId' : 1,
  //   'Name' : 'Phone',
  //   'ShortName' : 'PH'
  //   },
  //   {
  //   'CommunicateTypeId' : 2,
  //   'Name' : 'Walk In',
  //   'ShortName' : 'WI'
  //   },
  //   {
  //   'CommunicateTypeId' : 3,
  //   'Name' : 'Whatsapp',
  //   'ShortName' : 'WTS'
  //   },
  //   {
  //   'CommunicateTypeId' : 1,
  //   'Name' : 'Phone',
  //   'ShortName' : 'PH'
  //   },

  // ];

  TextEditingController _descriptioncontroller = new TextEditingController();
  TextEditingController _titlecontroller = new TextEditingController();

  Map<String, dynamic> data = {
    "ContactPersonId": null,
    "JobTypeId": null,
    "TaskTypeId": null,
    "PriorityId": null,
    "Title": null,
    "Description": null,
    "ClientInformationId": '283',
  };

  clearText() {
    _descriptioncontroller.clear();
    _titlecontroller.clear();
  }

   List<Map<String, dynamic>> filteredjobTypeList = [];
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  //dynamic lists to get all list data
  List<dynamic> prioritylist = <dynamic>[];
  List<dynamic> tasklist = <dynamic>[];
  List<dynamic> joblist = <dynamic>[];
  List<dynamic> contactpersonlist = <dynamic>[];
  List<dynamic> filesList = <dynamic>[];
  List CommunticationTypeList = [];

  //string type list to store showing fields data
  List<String> priorityName = <String>[];
  List<String> taskfielddata = <String>[];
  List<String> jobfielddata = <String>[];
  List<String> contactfielddata = <String>[];
  // Map userMap = {};

  Map<String, dynamic>? file;

  String? displayfilename;
  dynamic videopath;
  dynamic clientName;
  dynamic clientid;
  dynamic picturepath;
  PlatformFile? pickedfile;
  Text? txt;
  dynamic selectedPriority;
  dynamic selectCommunication;
  dynamic priorityId;
  dynamic communicateTypeId;

  String? deviceToken;
  // void pickfile() async {
  //   FilePickerResult? result =
  //       await FilePicker.platform.pickFiles(allowMultiple: true);

  //   //  Uint8List  bytes = await  files![0].readAsBytesSync();fggfeg
  //   if (result != null) {
  //     if (files != null) {
  //       for (var i = 0; i < result.files.length; i++) {
  //         files.add(<String, dynamic>{
  //           'name': result.files[i].name,
  //           'path': result.files[i].path
  //         });
  //       }
  //     } else {
  //       files = result.files;
  //     }

  //     // pickedfile = result.files.first;
  //     print('Length  ${files.length}');
  //     setState(() {
  //       //  addmapdata();
  //       print('List ${files}');
  //       print('Result file is ${result.files}');

  //       // print('name ${file}');
  //       // displayfilename = file.name.toString();
  //     });
  //   }
  // }

  void adddata() async {
    setState(() {
      for (var i = 0; i < prioritylist.length; i++) {
        if (prioritylist.length != null) {
          priorityName.add(prioritylist[i]['Name']);
        }
        //  prioritydataholdId.add(prioritylist![i]['PriorityId']);

        print(priorityName);
      }

      for (var i = 0; i < joblist.length; i++) {
        jobfielddata.add(joblist[i]['TaskTypeName']);
      }

      for (var i = 0; i < tasklist.length; i++) {
        taskfielddata.add(tasklist[i]['TaskTypeName']);
      }
      for (var i = 0; i < contactpersonlist.length; i++) {
        contactfielddata.add(contactpersonlist[i]['PersonName']);
      }
    });
  }

  Future<void> vaildation() async {
    if (widget.isSupportMenu == false && clientid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ClientId Type Empty"),
        ),
      );
    } else if (priorityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Priority Type Empty"),
        ),
      );
    } else if (tasktype == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ticket Type Empty"),
        ),
      );
    } else if (jobtype == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Job Type is Is Empty"),
        ),
      );
    } else if (_titlecontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Title is Empty"),
        ),
      );
    } else {
      // sendSupportData();
      save();
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Ticket()));
    }
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print("Token is" + token!);

      setState(() {
        deviceToken = token;
        print('Device Token is ${deviceToken}');
      });
    });
  }

  @override
  void initState() {
    fetchSupportData();
    // video();
    super.initState();
    print(widget.isSupportMenu);
    Firebase.initializeApp();
    firebaseCloudMessaging_Listeners();
    _isPriorityLoader = true;
  }

  Future<void> fetchSupportData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    String url = widget.isSupportMenu == true
        ? '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/GetContactPerson?clientInfoId=${ClientId}'
        : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetContactPerson?clientInfoId=${ClientId}';

    //Try reading data from the counter key. If it doesn't exist, return 0.
    // String username = 'jahanzaib';
    // String password = 'j';
    // String basicAuth =
    //     'Basic ' + base64Encode(utf8.encode('$username:$password'));

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
                "Content-type": 'application/json',
                // "Authorization": basicAuth,
                // "TS-AppKey": 'ts'
              });
    setState(() {
      _isPriorityLoader = true;
    });
    if (response.statusCode == 200) {
      var res = response.body;
      dynamic data = json.decode(res);
      prioritylist = data['PriorityList'];
      joblist = data['JobTypeList'];
      tasklist = data['TaskTypeList'];
      contactpersonlist = data['ContactPersonList'];
      CommunticationTypeList = data['CommunicateTypeList'];

      print(' Priority ${prioritylist}');
      setState(() {
        _isPriorityLoader = false;
      });
      // print('Spacing');
      // print(' Job ${joblist}');
      // print('Spacing');
      // print(' Task ${tasklist}');
      // print('Spacing');
      print(' Contact ${CommunticationTypeList}');

      print(response.body);
      // prioritydatalist = prioritylist.map((e) => e.toString()).toList();

      // prioritylist = jsonDecode(response.body)
      //     .map((item) => ClientInformationModel.fromJson(item))
      //     .toList()
      //     .cast<ClientInformationModel>();
      //  print( 'This is ${jsonDecode(response.body)}');
      //  print('That ${response.body}');

      //  print('Priority High ${prioritydatalist}');
      adddata();

      // prioritylist = jsonDecode(response.body);

      // jsonResponse[0]['ClientInformationId'];
      //  print('This is');
      //  print(jsonResponse[0]['ClientInformationId']);

    } else {
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
        _isPriorityLoader = false;
      });
    }
  }

  void sendFcmNotification(dynamic TaskRegisterId) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    String url = widget.isSupportMenu == true
        ? '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/SendFcmNotification?TaskRegisterId=${TaskRegisterId}'
        : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/SendFcmNotification?TaskRegisterId=${TaskRegisterId}';
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

    if (response.statusCode == 200) {
      var res = response.body;
      dynamic data = json.decode(res);
      print(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future initRecorder() async {
    // final status = await Permission.microphone.request();
    // if (status != PermissionStatus.granted) {
    //   throw 'Permission not granted';
    // }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('Recorded file path: $filePath');
    setState(() {
      recordedAudio = filePath;
      print('Recorded Files ${recordedAudio}.wav');
    });
  }

  // Future<void> sendSupportData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final user = prefs.getString('user') ?? '';
  //   final appKey = prefs.getString('appKey') ?? '';

  // String username = 'jahanzaib';
  // String password = 'j';
  // String basicAuth =
  //     'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   Map<String, dynamic> userMap = jsonDecode(user);

  //   var data = jsonEncode(<String, dynamic>{
  //     "ContactPersonId": contactperson,
  //     "JobTypeId": jobtype,
  //     "TaskTypeId": tasktype,
  //     "PriorityId": priority,
  //     "Title": _titlecontroller.text,
  //     "Description": _descriptioncontroller.text,
  //     "ClientId": '283',
  //     //"Files": filesList
  //   });

  //   final response = await http.post(
  //       Uri.parse(
  //         '${ApiConstant.clientAPIs['ts']!['baseURLLocal']}/TSBE/TaskRegister/SaveUpdateTicketRecord',
  //       ),
  //       headers: <String, String>{
  //         'Authorization': basicAuth,
  //         'TS-AppKey': 'ts',
  //         'content-type': 'application/json'
  //         // "UserId": "${userMap['UserId']}",
  //         // "token": "${userMap['GUID']}",
  //         // "Content-type": 'application/json'
  //       },
  //       body: data);
  //   if (response.statusCode == 200) {
  //     print(jsonDecode(response.body));
  //     clearText();
  //     //  Get.to(Ticket());

  //   }

  //   //  TicketData={"ClientInformationId":filename,"ContactPersonId" : contactperson , };
  // }

  save() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    var request = http.MultipartRequest(
        'POST',
        widget.isSupportMenu == true
            ? Uri.parse(
                '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/SaveUpdateTicketRecord2')
            : Uri.parse(
                '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/SaveUpdateTicketRecord2'));
    Map<String, dynamic> userMap = jsonDecode(user);
    //for token
    widget.isSupportMenu == true
        ? request.headers.addAll({
            "Content-type": 'application/json',
            "TS-AuthSign": prefs.getString('TSAuthSign') == null
                ? ''
                : prefs.getString('TSAuthSign').toString(),
            "TS-ClientId": ClientId.toString(),
            "TS-AppKey": appKey
          })
        : request.headers.addAll({
            "UserId": "${userMap['UserId']}",
            "token": "${userMap['GUID']}",
            "Content-type": 'application/json'
          });

//simple data
    setState(() {
      _isLoading = true;
    });
    request.fields["data"] = jsonEncode(<String, dynamic>{
      "ContactPersonId": contactperson,
      "JobTypeId": jobtype,
      "TaskTypeId": tasktype,
      "PriorityId": priorityId,
      "Title": _titlecontroller.text,
      "ClientInformationId": widget.isSupportMenu == true ? ClientId : clientid,
      "Description": _descriptioncontroller.text,
      "CommunicateTypeId":
          widget.isSupportMenu == true ? null : communicateTypeId,
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
    print(response);

    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print(responseData['TaskRegisterId']);
      print("SUCCESS");
      //sendFcmNotification(responseData['TaskRegisterId']);
      clearText();
//clear files
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget),
      );
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> myTicket(idx: selectedindex,)));

      showToast('Record Added Successfully TaskNo${responseData['TaskNumber']}',
          context: context,
          duration: Duration(seconds: 6),
          axis: Axis.horizontal,
          backgroundColor: Color(0xFFb54f40),
          textStyle: TextStyle(color: Colors.white),
          alignment: Alignment.center,
          borderRadius: BorderRadius.zero,
          position: StyledToastPosition.center);
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

  // Future<void> subscribeUser () async {

  //   final prefs = await SharedPreferences.getInstance();
  //   final user = prefs.getString('user') ?? '';
  //   final appKey = prefs.getString('appKey') ?? '';
  //   UserSessionProvider userProvider =
  //   Provider.of<UserSessionProvider>(context, listen: false);
  //   final ClientId = userProvider.userData['TSCId'];
  //        Map<String, dynamic> userMap = jsonDecode(user);
  //       String url = 'http://10.1.1.13:8081/TSBE/TaskRegister/InsertDeviceIdForSubscription?UserId=${userMap['UserId']}&DeviceId=${deviceToken}';
  //       var response = await http.get(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         "Content-type": 'application/json',
  //         "TS-AppKey": appKey,
  //         "appid": '6289'
  //       },
  //     );

  //     print(url);

  // }
  void video() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    videopath = prefe.getString('videopath');

    final videoname = videopath.split('/');

    if (videopath != null) {
      files.add(<String, dynamic>{"name": videoname[6], "path": videopath});
    }
    setState(() {
      print('Tis is ${videopath}');
      print('list  ${files}');
      print(picturepath);
    });
    prefe.remove('videopath');
  }

  void picture() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    picturepath = prefe.getString('picturepath');
    final picturename = picturepath.split('/');
    if (picturepath != null) {
      files.add(<String, dynamic>{"name": picturename[6], "path": picturepath});
      setState(() {});

      prefe.remove('picturepath');
    }
  }

  void getClientData() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    clientName = prefe.getString('name');
    clientid = prefe.getString('id');

    clientData = {
      'ClientName': clientName,
      'ClientId': clientid,
    };
    print('userName  ${clientName}');
    print(clientData);
    print(clientData['ClientName']);

    setState(() {
      clientName;
      //  userMap={'username' : clientName};
    });
    prefe.remove('name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConst.appColorPrimary,
        title: Text('Support Ticket'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => myTicket(
                      isSupportMenu: widget.isSupportMenu,
                    )));
            // print('Hello');
          },
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              flag=true;
            });
          }, icon: Icon(Icons.abc_outlined))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            // ElevatedButton(onPressed: (){
            //   subscribeUser();
            // }, child: Text('Press')),
            SizedBox(
              height: 20,
            ),
            widget.isSupportMenu == true
                ? Container(
                    height: 0,
                  )
                :
                // ListOfValues(text: '', hintText: 'Client' , icon: Icons.list,),

                // ElevatedButton(onPressed: (){
                //    Future<void> future = showModalBottomSheet(
                //                       isScrollControlled: true,
                //                       context: context,
                //                       builder: (BuildContext context) {
                //                         //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                //                         return FilterNetworkListPage();
                //                       });
                //                       future.then((void value) => getData());

                // }, child: Text('Search List')),
                // Container(
                //     width: 350,
                //     child: ListOfValues(
                //       hintText:
                //           clientName == null ? 'ClientName' : clientName,

                //       text: '',
                //       icon: Icons.abc,
                //       btn: IconButton(
                //         onPressed: () {
                //           Future<void> future = showModalBottomSheet(
                //               isScrollControlled: true,
                //               context: context,
                //               builder: (BuildContext context) {
                //                 //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                //                 return FilterNetworkListPage();
                //               });
                //           future.then((void value) => getClientData());
                //         },
                //         icon: Icon(Icons.list),
                //       ),
                //     ),
                //   ),

                Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    // width: 350,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: clientName == null
                                ? Text(
                                    'Client Name',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 14),
                                  )
                                : Text(
                                    clientName,
                                    style: TextStyle(color: Colors.black),
                                  )),
                        InkWell(
                          onTap: () {
                            Future<void> future = showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                                  return LOV(
                                    SpType: 65,
                                    fields: ['ClientName', 'IndustryName'],
                                    primaryField: 'ClientInformationId',
                                    hintText: 'Search Clients',
                                    MultiSelection: false,
                                  );
                                });
                            future.then((void value) => getClientData());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.list),
                          ),
                        )
                      ],
                    ),
                  ),

            SizedBox(
              height: 20,
            ),
            // SearchWidget( text: 'Hello', hintText: 'Customer',),
            //    Padding(
            //      padding: const EdgeInsets.only(bottom: 20),
            //      child: Container(
            //   width: 350,
            //   child: TextDropdownFormField(
            //       options: priorityName,
            //       onChanged: ((dynamic item) {
            //         for (var i = 0; i < prioritylist.length; i++) {
            //           if (item == prioritylist[i]['Name']) {
            //             setState(() {
            //               priority = prioritylist[i]['PriorityId'];
            //               print(priority);
            //             });
            //             break;
            //           }
            //         }
            //       }),
            //       decoration: InputDecoration(
            //           contentPadding: EdgeInsets.only(left: 10),
            //           border:
            //               OutlineInputBorder(borderRadius: BorderRadius.zero),
            //           suffixIcon: Icon(Icons.arrow_drop_down),
            //           labelText: "Priority (required)"),
            //       dropdownHeight: 180,
            //   ),
            // ),
            //    ),

            _isPriorityLoader
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'Priority:',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: prioritylist.length,
                              itemBuilder: ((context, index) {
                                hexStringToColor(String hexColor) {
                                  hexColor = prioritylist[index]['ColrCode']
                                      .toUpperCase()
                                      .replaceAll("#", "");
                                  if (hexColor.length == 6) {
                                    hexColor = "FF" + hexColor;
                                  }
                                  return Color(int.parse(hexColor, radix: 16));
                                }

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedPriority = prioritylist[index];
                                      priorityId =
                                          prioritylist[index]['PriorityId'];

                                      print('Id ${priorityId}');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 108,
                                      alignment: Alignment.center,
                                      color: prioritylist[index] ==
                                              selectedPriority
                                          ? AppConst.appColorPrimary
                                          : hexStringToColor(
                                              prioritylist[index]['ColrCode']),
                                      child: Text(
                                        prioritylist[index]['ShortName'],
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
                  ),

            widget.isSupportMenu == true
                ? Container(
                    height: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1)),
                      // width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Communication Type :',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: CommunticationTypeList.length,
                                  itemBuilder: ((context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectCommunication =
                                              CommunticationTypeList[index];
                                          communicateTypeId =
                                              CommunticationTypeList[index]
                                                  ['CommunicateTypeId'];

                                          print('Id ${communicateTypeId}');
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 108,
                                          alignment: Alignment.center,
                                          color:
                                              CommunticationTypeList[index] ==
                                                      selectCommunication
                                                  ? AppConst.appColorPrimary
                                                  : Colors.blue,
                                          child: Text(
                                            CommunticationTypeList[index]
                                                ['ShortName'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            // Container(
            //   width: 350,
            //   child: TextDropdownFormField(
            //     options: priorityName,
            //     onChanged: ((dynamic item) {
            //       for (var i = 0; i < prioritylist.length; i++) {
            //         if (item == prioritylist[i]['Name']) {
            //           setState(() {
            //             priority = prioritylist[i]['PriorityId'];
            //             print(priority);
            //           });
            //           break;
            //         }
            //       }
            //     }),
            //     decoration: InputDecoration(
            //         contentPadding: EdgeInsets.only(left: 10),
            //         border:
            //             OutlineInputBorder(borderRadius: BorderRadius.zero),
            //         suffixIcon: Icon(Icons.arrow_drop_down),
            //         labelText: "Priority (required)"),
            //     dropdownHeight: 180,
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              // width: 350,
              child: TextDropdownFormField(
                // controller: course,
                options: contactfielddata,
                onChanged: (dynamic item) {

                  for (var i = 0; i < contactpersonlist.length; i++) {
                    if (item == contactpersonlist[i]['PersonName']) {
                      setState(() {
                        contactperson = contactpersonlist[i]['ContactPersonId'];
                        print(priority);
                      });
                      break;
                    }
                  }
                  print('HEllo');
                },
                decoration: InputDecoration(
                  counter: Padding(
                    padding: EdgeInsets.all(0),
                  ),
                  contentPadding: EdgeInsets.only(left: 10),
                  // focusedBorder: InputBorder.none,
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Contact Person",
                  labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                dropdownHeight: 180,
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //demo
            DropdownFormField<Map<String, dynamic>>(
              onEmptyActionPressed: () async {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Access"),
              onSaved: (dynamic str) {},
              onChanged: (dynamic str) {
                 setState(() {
              flag=false;
            });
              },
              validator: (dynamic str) {},
              displayItemFn: (dynamic item) => Text(
                (item ?? {})['name']!=null && flag ==false ?(item ?? {})['name']: '',
                style: TextStyle(fontSize: 16),
              ),              findFn: (dynamic str) async => _roles,

              selectedFn: (dynamic item1, dynamic item2) {
                if (item1 != null && item2 != null) {
                  return item1['name'] == item2['name'];
                }
                return false;
              },
              filterFn: (dynamic item, str) =>
                  item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
              dropdownItemFn: (dynamic item, int position, bool focused,
                      bool selected, Function() onTap) =>
                  ListTile(
                title: Text(item['name']),
                subtitle: Text(
                  item['desc'] ?? '',
                ),
                tileColor:
                    focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
                onTap: onTap,
              ),
            ),





            Container(
              //  width: 350,
              child: TextDropdownFormField(
                options: taskfielddata,
                onChanged: ((dynamic item) {
                   setState(() {
              flag=true;
            });
                  filteredjobTypeList.clear();
                  for (var i = 0; i < tasklist.length; i++) {
                    if (item == tasklist[i]['TaskTypeName']) {
                      setState(() {
                        tasktype = tasklist[i]['TaskTypeId'];
                        //  print(priority);
                      });
                      break;
                    }
                  }
                  // List emptyList = [];
                  dynamic TaskTypeIds;
                  for (var i = 0; i < joblist.length; i++) {
                    TaskTypeIds = joblist[i]['TaskTypeIds'].length > 0
                        ? joblist[i]['TaskTypeIds'].split(',')
                        : joblist[i]['TaskTypeIds'];
                    print('Idss ${TaskTypeIds}');

                    // TaskTypeIds.retainWhere((items) {
                    //   return items.contains(tasktype.toString());
                    // });
                    //  if (TaskTypeIds.isNotEmpty) {
                    //   filteredjobTypeList.add(joblist[i]['TaskTypeName']);
                    // }

                    if (TaskTypeIds.contains(tasktype.toString()) ||
                        TaskTypeIds == "" ||
                        TaskTypeIds == null) {
                      filteredjobTypeList.add(joblist[i]['TaskTypeName']);
                    }
                  }
                                        print('Founddd ${ filteredjobTypeList} ' );

                }),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    labelText: "Ticket Type (required)",
                    labelStyle:
                        TextStyle(fontSize: 14, color: Colors.grey[600])),
                dropdownHeight: 180,
              ),
            ),
            SizedBox(
              height: filteredjobTypeList.isEmpty ? 0 : 20,
            ),
            filteredjobTypeList.isEmpty
                ? Container()
                : Container(
                    // width: 350,
                    child: TextDropdownFormField(
                      options: [''],
                      onChanged: ((dynamic item) {
                        for (var i = 0; i < joblist.length; i++) {
                          if (item == joblist[i]['TaskTypeName']) {
                            setState(() {
                              jobtype = joblist[i]['TaskTypeId'];
                              print('Priorotyy ${jobtype}');
                            });
                            break;
                          }
                        }
                      }),
                      decoration: InputDecoration(
                        //            focusedBorder:OutlineInputBorder(
                        //   borderSide: const BorderSide(color: Colors.white,),

                        // ),

                        contentPadding: EdgeInsets.only(left: 10),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.zero),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Job Type (required)",
                        labelStyle:
                            TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      dropdownHeight: 150,
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Container(
              // width: 350,
              child: TextFormField(
                controller: _titlecontroller,
                decoration: InputDecoration(
                  hintText: "Title (required)",
                  hintStyle: TextStyle(fontSize: 14),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  contentPadding: EdgeInsets.only(left: 10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              // width: 350,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: TextFormField(
                  controller: _descriptioncontroller,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Visibility(
            //   visible: false,
            //   child: ElevatedButton(
            //       onPressed: () {
            //         showModalBottomSheet(
            //             context: context,
            //             backgroundColor: Colors.transparent,
            //             builder: (BuildContext context) {
            //               return LOV();
            //             });
            //       },
            //       child: Text('Testing')),
            // ),
            // FloatingActionButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //             content: Column(
            //           children: [
            //             Text(_descriptioncontroller.text),
            //             Text(tasktype.toString()),
            //             Text(priority.toString()),
            //             Text(jobtype.toString()),
            //             Text(contactperson.toString()),
            //             Text(_titlecontroller.text),
            //             Text(filesize.toString()),
            //             Text(filename.toString()),
            //           ],
            //         ));
            //       },
            //     );
            //     video();
            //     // createFilesList();
            //   },
            //   tooltip: 'Show me the value!',
            //   child: const Icon(Icons.abc, color: Colors.black),
            // ),
            // videopath!=null? Text(videopath): Text('Path not found'),
            // SizedBox(
            //   height: 20,
            // ),
            // ElevatedButton(onPressed: (){}, child: Text('Hello')),
            Attachment_Picker2(
              files: files,
              getPictureandVideopath: IconButton(
                  onPressed: (() {
                    Future<void> future = showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                          return CameraPage();
                        });
                    future.then((void value) => video());
                    future.then((value) => picture());
                  }),
                  icon: Icon(
                    Icons.camera_alt,
                    size: 30,
                  )),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              // width: 350,
              width: double.infinity,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          )),
                      onPressed: () {
                        vaildation();
                      },
                      child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomeElevatedButton extends StatelessWidget {
//   const CustomeElevatedButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(
//                 AppConst.appColorPrimary),
//             shape:
//                 MaterialStateProperty.all<RoundedRectangleBorder>(
//               RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0)),
//             )),
//         onPressed: () {
//           //vaildation();
//         },
//         child: Text('Save'));
//   }
// }

class Attachment_Picker2 extends StatefulWidget {
  Attachment_Picker2(
      {Key? key,
      required this.files,
      // required this.ink,
      required this.getPictureandVideopath})
      : super(key: key);

  List<dynamic>? files;

  // InkWell ink;
  IconButton getPictureandVideopath;

  @override
  State<Attachment_Picker2> createState() => _Attachment_Picker2State();
}

class _Attachment_Picker2State extends State<Attachment_Picker2> {
  dynamic audioPath;
  void audiopath() async {
    final SharedPreferences prefe = await SharedPreferences.getInstance();
    audioPath = prefe.getString('audiopath');

    final audioName = audioPath.split('/');

    if (audioPath != null) {
      widget.files!
          .add(<String, dynamic>{"name": audioName[6], "path": audioPath});
    }
    setState(() {
      print('Tis is ${audioPath}');
    });
    prefe.remove('audiopath');
  }

  void deleteFilesFromCache() {
    for (var i = 0; i < widget.files!.length; i++) {
      if (widget.files![i]['path']
          .contains('com.technosysint.bxmobileapp/cache/')) {
        final file = File(widget.files![i]['path']);
        file.delete();
        print('deleted: ' + widget.files![i]['path']);
      } //to do confirm for ios
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 350,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Attachments :',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(
                  width: 90,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        PickFiles().pickfile(widget.files).then((value) {
                          setState(() {
                            if (value != null) {
                              widget.files = value;
                            }
                          });
                        });
                      });
                    },
                    icon: Icon(
                      Icons.attachment,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Future<void> future = showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                            return Voice();
                          });
                      future.then((void value) => audiopath());
                      // future.then((value) => picture());
                    },
                    icon: Icon(
                      Icons.mic,
                      size: 30,
                    )),
                widget.getPictureandVideopath,
                // IconButton(
                //     onPressed: () {
                //       // video();
                //       Future<void> future = showModalBottomSheet(
                //           isScrollControlled: true,
                //           context: context,
                //           builder: (BuildContext context) {
                //             //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                //             return CameraPage();
                //           });
                //       future.then((void value) => video());
                //       future.then((value) => picture());

                //       //  camera(context);
                //     },
                //     icon: Icon(
                //       Icons.camera_alt,
                //       size: 30,
                //     )),
              ],
            ),
            Center(
              child:
                  //  Attachment_Picker(files: files)
                  Container(
                height: 120,
                width: 450,
                child: widget.files!.isEmpty
                    ? Center(
                        child: Text(
                        'No Attachment',
                        style: TextStyle(color: Colors.grey[600]),
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.files!.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Container(
                                  width: 400,
                                  height: 30,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            //  opefile(widget.files![index]['path']);
                                            OpenFile.open(
                                                widget.files![index]['path']);
                                          },
                                          child: Text(
                                              widget.files![index]['name'])),

                                      SizedBox(
                                        width: 20,
                                      ),
                                      Spacer(),

                                      //  showTextField?
                                      // InkWell(
                                      //     onTap: () {
                                      //       setState(() {
                                      //         widget.files.removeAt(index);
                                      //         setState(() {});
                                      //       });
                                      //     },
                                      //     child: Icon(
                                      //       Icons.warning_outlined,
                                      //       color: Colors.red,
                                      //     )),
                                      //   :
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              // showTextField = true;
                                              widget.files!.removeAt(index);
                                            });

                                            print('Remove ${index}');
                                          },
                                          child: Icon(Icons.delete_outline))
                                    ],
                                  )),
                            ),
                          );
                        }),
              ),
            ),
          ]),
    );
  }
}

class Attachment_Picker extends StatefulWidget {
  Attachment_Picker({
    Key? key,
    required this.files,
  });

  List<dynamic>? files;

  @override
  State<Attachment_Picker> createState() => _Attachment_PickerState();
}

class _Attachment_PickerState extends State<Attachment_Picker> {
  bool showTextField = false;
  bool _visible = true;
  void pickfile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      widget.files = result.files;
      // file = result.files;

      // pickedfile = result.files.first;
      print('Length  ${widget.files!.length}');
      setState(() {
        print('List ${widget.files}');
      });
    }
  }

  void opefile(dynamic file) {
    OpenFile.open(file.path);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 120,
        width: 450,
        child: widget.files!.isEmpty
            ? Center(
                child: Text(
                'No Attachment',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.files!.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Container(
                          width: 400,
                          height: 30,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () {
                                    //  opefile(widget.files![index]['path']);
                                    OpenFile.open(widget.files![index]['path']);
                                  },
                                  child: Text(widget.files![index]['name'])),

                              SizedBox(
                                width: 20,
                              ),
                              Spacer(),
                              //  showTextField?
                              // InkWell(
                              //      onTap: (){
                              //       setState(() {
                              //          widget.files!.removeAt(index);
                              //          setState(() {

                              //          });
                              //       });
                              //      },
                              //      child: Icon(Icons.warning_outlined , color: Colors.red,))
                              //   :
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      showTextField = true;
                                      widget.files!.removeAt(index);
                                    });

                                    print('Remove ${index}');
                                  },
                                  child: Icon(Icons.delete_outline))
                            ],
                          )),
                    ),
                  );
                }),
      ),
    );
  }
}
final List<Map<String, dynamic>> _roles = [
    {"name": "Super Admin", "desc": "Having full access rights", "role": 1},
    {
      "name": "Admin",
      "desc": "Having full access rights of a Organization",
      "role": 2
    },
    {
      "name": "Manager",
      "desc": "Having Magenent access rights of a Organization",
      "role": 3
    },
    {
      "name": "Technician",
      "desc": "Having Technician Support access rights",
      "role": 4
    },
    {
      "name": "Customer Support",
      "desc": "Having Customer Support access rights",
      "role": 5
    },
    {"name": "User", "desc": "Having End User access rights", "role": 6},
  ];
