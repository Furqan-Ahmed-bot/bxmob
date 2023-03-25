// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, use_build_context_synchronously, unused_local_variable, non_constant_identifier_names, unused_import, unnecessary_brace_in_string_interps, avoid_print, duplicate_import, prefer_if_null_operators

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:open_file/open_file.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/Generic/Functions/functions.dart';
import 'package:ts_app_development/OrderTicket/TaskShedular.dart';
import 'package:ts_app_development/OrderTicket/newActivity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../DataLayer/Providers/UserProvider/userProvider.dart';
import '../../Generic/APIConstant/apiConstant.dart';
import '../../Generic/appConst.dart';
import 'dart:io' as Io;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Activity.dart';
import '../myTicket.dart';
import 'ticketDetails.dart';

class Task {
  final String Priority;
  final String PrioritySN;
  final String? PriorityColor;
  final String? ActivityDate; //date
  final String TaskType;
  final String TaskNumber;
  final String TaskTypeSN; //tasktypeno
  final String? ActivityStatus;
  final ActivityStatusColor;
  final String SupportPersonName;
  final String Title;
  final String? JobDescription;
  final String? TransactionDate;
  final String TransactionNumberPrefix;
  final String ClientName;
  final String? ClientContact;
  final int TaskRegisterDetailId;
  final int? AttachmentCount;
  final int TaskRegisterId;
  final int TaskTypeId;
  final TaskDueDate;
  final int? EstimatedTime;
  final int ClientInformationId;
  final int? ClientContactPersonId;
  final int PriorityId;
  final int CommunicateTypeId;
  final int JobTypeId;

  Task({
    required this.Priority,
    required this.PrioritySN,
    this.PriorityColor,
    this.ActivityDate,
    required this.TaskType,
    required this.TaskNumber,
    required this.TaskTypeSN,
    this.ActivityStatus,
    this.ActivityStatusColor,
    required this.SupportPersonName,
    required this.Title,
    this.JobDescription,
    required this.TransactionDate,
    required this.ClientName,
    this.ClientContact,
    required this.TaskRegisterDetailId,
    required this.TransactionNumberPrefix,
    this.AttachmentCount,
    required this.TaskRegisterId,
    required this.TaskTypeId,
    this.TaskDueDate,
    this.EstimatedTime,
    required this.ClientInformationId,
    required this.CommunicateTypeId,
    this.ClientContactPersonId,
    required this.PriorityId,
    required this.JobTypeId,
  });
}

class TicketDetails extends StatefulWidget {
  bool? isTaskRegister;
  final isSupportMenu;
  final FcmNotification;
  final TaskRegisterId;
  Task?
      TaskData; //actually it is the ype of Task; will debug later as task is not accesbile in initState

  TicketDetails(
      {Key? key,
      this.isTaskRegister,
      this.isSupportMenu,
      this.TaskData,
      this.FcmNotification,
      this.TaskRegisterId})
      : super(key: key);

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  @override
  void initState() {
    // if(attachments[0]['File'] != null){
    //   localmage = attachments[0]['File'];
    // }
    if (widget.TaskData == null)
    //no Task Data available and api will be called
    {
      GetTaskData(context, widget.TaskRegisterId);
      //bind TaskData/Task model
    } else {
      ticketAttachments();
    }

    baseUrl();
    _isLoading = true;
    _notificationsCircularProgress = true;

    super.initState();
  }

  bool _isLoading = false;
  bool _notificationsCircularProgress = false;
  List attachments = [];
  String localmage = '';
  Uint8List? bytes;

  var baseUrl2;

  Future<String> _createFileFromString(String myfile, String extension) async {
    final encodedStr = myfile;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getTemporaryDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + extension);
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
    return file.path;
  }

  Future<void> openAudioVideo(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } else {
      print('Can not use url');
    }
  }

  void launchfromurl(String attachment) {
    if (attachments.contains('AA==')) {
      print('String Found');
    } else {
      print('String not found');
    }
  }

  Future<void> GetTaskData(BuildContext context, String taskRegisterIds) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    Map<String, dynamic> userMap = jsonDecode(user);
    String url = widget.isSupportMenu == true
        ? '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/GetTasks2?StartDate=2000-01-01&EndDate=2030-01-01&DateType=DataEntryDate&ClientInformationIds=${ClientId}&TaskRegisterId=${taskRegisterIds}'
        : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetTasks2?StartDate=2000-01-01&EndDate=2030-01-01&DateType=DataEntryDate&EmployeeInformationIds=${userMap['EmployeeInformationId']}&TaskRegisterId=${taskRegisterIds}';

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
      _notificationsCircularProgress = true;
    });

    if (response.statusCode == 200) {
      var res = response.body;
      ticketAttachments();
      dynamic resData = json.decode(res)['Table'][0];

      setState(() {
        _notificationsCircularProgress = false;
      });
      print('Response ${Task}');
      widget.TaskData = Task(
          Priority: resData['Priority'],
          PriorityColor: resData["PriorityColor"],
          ActivityDate: resData['ActivityDate'],
          TaskNumber: resData['TaskNumber'],
          ActivityStatus: resData['ActivityStatus'],
          TaskType: resData['TaskType'],
          ActivityStatusColor: resData['ActivityStatusColor'],
          SupportPersonName: resData['SupportPersonName'],
          Title: resData['Title'],
          JobDescription: resData['JobDescription'],
          TransactionDate: resData['TransactionDate'],
          ClientName: resData['ClientName'],
          ClientContact: resData['ClientContact'],
          TaskRegisterDetailId: resData['TaskRegisterDetailId'],
          AttachmentCount: resData['AttachmentCount'],
          TaskRegisterId: resData['TaskRegisterId'],
          TaskTypeId: resData['TaskTypeId'],
          TaskDueDate: resData['TaskDueDate'],
          EstimatedTime: resData['EstimatedTime'],
          ClientInformationId: resData['ClientInformationId'],
          CommunicateTypeId: resData['CommunicateTypeId'],
          JobTypeId: resData['JobTypeId'],
          PriorityId: resData['PriorityId'],
          PrioritySN: resData['PrioritySN'],
          ClientContactPersonId: resData['ClientContactPersonId'],
          TransactionNumberPrefix: resData['TransactionNumberPrefix'],
          TaskTypeSN: resData['TaskTypeSN']);
      print(response.statusCode);
      print(response.body);
    }
    ;
  }

  Future<void> ticketAttachments() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context, listen: false);
    final ClientId = userProvider.userData['TSCId'];
    Map<String, dynamic> userMap = jsonDecode(user);
    String url = widget.isSupportMenu == true
        ? '${prefs.getString('AppKeyForTechnosys')}/TSBE/TaskRegister/GetAttachment?StartDate=2000-01-01&EndDate=2030-01-01&DateType=DataEntryDate&ClientInformationIds=${ClientId}&TaskRegisterDetailId=${widget.TaskData!.TaskRegisterDetailId}'
        : '${prefs.getString('ApiUrl')}/TSBE/TaskRegister/GetAttachment?StartDate=2000-01-01&EndDate=2030-01-01&DateType=DataEntryDate&EmployeeInformationIds=${userMap['EmployeeInformationId']}&TaskRegisterDetailId=${widget.TaskData!.TaskRegisterDetailId}';

    // // Try reading data from the counter key. If it doesn't exist, return 0.
    // String username = 'jahanzaib';
    // String password = 'j';
    // String basicAuth =
    //     'Basic ' + base64Encode(utf8.encode('$username:$password'));

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
      print(response.body);
      var res = response.body;
      dynamic data = json.decode(res);
      attachments = data;

      setState(() {
        _isLoading = false;
      });
    } else {
      print(response.statusCode);
      print('Attachments ${attachments}');
      print('Err');
      print(url);
    }
  }

  void baseUrl() async {
    final prefs = await SharedPreferences.getInstance();

    var baseurl = widget.isSupportMenu == true
        ? prefs.getString('AppKeyForTechnosys')
        : prefs.getString('ApiUrl');
    setState(() {
      baseUrl2 = baseurl;
    });
  }

  @override
  Widget build(BuildContext context) {
    hexStringToColor(String hexColor) {
      if (hexColor != null) {
        hexColor = hexColor.toUpperCase().replaceAll("#", "");
        if (hexColor.length == 6) {
          hexColor = "FF" + hexColor;
        }
        return Color(int.parse(hexColor, radix: 16));
      } else {
        return Colors.blue;
      }
    }

    String? transcationDateFormat;
    if (widget.TaskData!.TransactionDate != null) {
      String? formateddate = widget.TaskData!.TransactionDate;

      DateTime now = DateTime.parse(formateddate!);
      transcationDateFormat = DateFormat('EEE, dd-MMM-yyyy h:mm a').format(now);
    }
    String? activityDateFormat;
    if (widget.TaskData!.TransactionDate != null) {
      String? formateddate = widget.TaskData!.ActivityDate;

      DateTime now = DateTime.parse(formateddate!);
      activityDateFormat = DateFormat('dd-MMM-yyyy').format(now);
    }

    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: CustomHomeIconAppBar(
        isSupportMenu: widget.isSupportMenu,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                // alignment: Alignment.center,
                // height: 45,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20 , left: 20),
                      //   child: Text('Ticket Number :' , style: TextStyle(fontSize: 16),),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          Functions.NullAlternateValue(activityDateFormat),
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 5),
                        child: Text(
                          Functions.NullAlternateValue(
                            widget.TaskData!.TransactionNumberPrefix != null
                                ? widget.TaskData!.TransactionNumberPrefix
                                : '' + widget.TaskData!.TaskNumber,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          child:
                              // widget.isTaskRegister != null
                              //     ? Text(TaskType[0]['PrioritySN'])
                              //     :
                              Text(
                            widget.TaskData!.TaskNumber,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 15),
                        child: Container(
                          child:
                              // widget.isTaskRegister != null
                              //     ? Text(TaskType[0]['PrioritySN'])
                              //     :
                              Text(
                            widget.TaskData!.PrioritySN,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: hexStringToColor(
                                widget.TaskData!.PriorityColor == null
                                    ? ''
                                    : widget.TaskData!.PriorityColor!),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 5),
                        child: Container(
                          color: hexStringToColor(
                              widget.TaskData!.ActivityStatusColor),
                          height: 25,
                          width: 74,
                          alignment: Alignment.center,
                          child: Text(
                            Functions.NullAlternateValue(
                                widget.TaskData!.ActivityStatus),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://media.istockphoto.com/vectors/male-profile-icon-white-on-the-blue-background-vector-id470100848?k=20&m=470100848&s=612x612&w=0&h=ZfWwz2F2E8ZyaYEhFjRdVExvLpcuZHUhrPG3jOEbUAk='),
                      radius: 15,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: Container(
                    width: 200,
                    child: Text(
                      widget.TaskData!.SupportPersonName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Spacer(),

                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                      onTap: () {
                        Get.to(newActivity(
                          TaskRegisterDetailId:
                              widget.TaskData!.TaskRegisterDetailId,
                          TaskNumber: widget.TaskData!.TaskNumber,
                          TaskTypeSN: widget.TaskData!.TaskTypeSN,
                          TaskDueDate: widget.TaskData!.TaskDueDate,
                          EstimationTime: widget.TaskData!.EstimatedTime,
                          IsSupportMenu: widget.isSupportMenu,
                          TaskTypeId: widget.TaskData!.TaskTypeId,
                          CommunicateTypeId: widget.TaskData!.CommunicateTypeId,
                          ClientContactPersonID:
                              widget.TaskData!.ClientContactPersonId,
                          PriorityId: widget.TaskData!.PriorityId,
                          JobTypeId: widget.TaskData!.JobTypeId,
                          ClientInformationId:
                              widget.TaskData!.ClientInformationId,
                          // TaskTypeID2: widget.TaskTypeID2,
                          TaskRegisterId: widget.TaskData!.TaskRegisterId,
                          Title: widget.TaskData!.Title,
                          JobDescription: widget.TaskData!.JobDescription,
                        ));
                      },
                      child: Icon(
                        Icons.work_history,
                        color: Colors.blue,
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                      onTap: () {
                        Get.to(Activity(
                            isSupportMenu: widget.isSupportMenu,
                            taskregisterid: widget.TaskData!.TaskRegisterId,
                            TaskNumber: widget.TaskData!.TaskNumber,
                            TaskTypeSN: widget.TaskData!.TaskTypeSN,
                            TaskRegisterDetailId:
                                widget.TaskData!.TaskRegisterDetailId,
                            TaskDueDate: widget.TaskData!.TaskDueDate,
                            TaskTypeId: widget.TaskData!.TaskTypeId,
                            EstimationTime: widget.TaskData!.EstimatedTime,
                            ClientContactPersonID:
                                widget.TaskData!.ClientContactPersonId,
                            ClientInformationId:
                                widget.TaskData!.ClientInformationId,
                            CommunicateTypeId:
                                widget.TaskData!.CommunicateTypeId,
                            JobTypeId: widget.TaskData!.JobTypeId,
                            PriorityId: widget.TaskData!.PriorityId,
                            Title: widget.TaskData!.Title,
                            JobDescription: widget.TaskData!.JobDescription));
                      },
                      child: Icon(
                        Icons.history,
                        color: Colors.blue,
                      )),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 15),
                //   child: InkWell(
                //       onTap: () {
                //         Get.to(EmployeeTimeLine(
                //           IsSupportMenu: widget.isSupportMenu,
                //           TaskNumber: widget.tasktypeno,
                //           TaskTypeSN: widget.tasktype,
                //         ));
                //       },
                //       child: Icon(
                //         Icons.task,
                //         color: Colors.blue,
                //       )),
                // )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                // height: 500,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Padding(
                        //     padding: const EdgeInsets.only(left: 20, top: 5),
                        //     child: CircleAvatar(
                        //       backgroundImage: NetworkImage(
                        //           'https://media.istockphoto.com/vectors/male-profile-icon-white-on-the-blue-background-vector-id470100848?k=20&m=470100848&s=612x612&w=0&h=ZfWwz2F2E8ZyaYEhFjRdVExvLpcuZHUhrPG3jOEbUAk='),
                        //       radius: 15,
                        //     )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Container(
                              width: 300,
                              child: Text(Functions.NullAlternateValue(
                                  widget.TaskData!.Title))),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, top: 5),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         widget.clientcontact.isEmpty
                    //             ? widget.clientname
                    //             : widget.clientcontact,
                    //         style: TextStyle(
                    //             color: AppConst.appColorPrimary, fontSize: 16),
                    //       ),
                    //       // SizedBox(
                    //       //   width: 5,
                    //       // ),
                    //       // Text(
                    //       //   'to support@technosysint.com',
                    //       //   style: TextStyle(fontSize: 11),
                    //       // )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Row(
                        children: [
                          transcationDateFormat == null
                              ? Text('')
                              : widget.isTaskRegister != null
                                  ? Text(transcationDateFormat)
                                  : Text(transcationDateFormat,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 300,
                        child: Divider(
                          thickness: 2,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 300,
                        child: Text(
                          Functions.NullAlternateValue(
                              widget.TaskData!.JobDescription),
                          style: TextStyle(color: Colors.grey),
                        )),

                    SizedBox(
                      height: 20,
                    ),

                    // will  do changes in future
                    // widget.attachmentcount == null
                    widget.TaskData!.AttachmentCount == null ||
                            widget.TaskData!.AttachmentCount == 0
                        ? Text('')
                        : Container(
                            width: 340,
                            // height: 100,
                            decoration: BoxDecoration(

                                //  color: Colors.grey[300],
                                border:
                                    Border.all(color: Colors.grey, width: 2)),
                            // border: Border.all(color: Colors.grey, width: 2)

                            child:
                                //     attachments.isEmpty
                                // ? Container(
                                //   width: 10,
                                //   child: Text('No Attachments')
                                // )
                                // :
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.attachment,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Attachments',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        )
                                      : ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: attachments.length,
                                          itemBuilder: ((context, index) {
                                            String? dateTimeFormat;
                                            if (attachments[index]
                                                    ['DataEntryDate'] !=
                                                null) {
                                              String formateddate =
                                                  attachments[index]
                                                      ['DataEntryDate'];
                                              DateTime now =
                                                  DateTime.parse(formateddate);
                                              dateTimeFormat = DateFormat(
                                                      'dd-MMM-yyyy HH:mma')
                                                  .format(now);
                                            }
                                            String extenstion =
                                                attachments[index]
                                                    ['FileExtension'];
                                            var type = extenstion.split('.');
                                            //  Map<String , dynamic>  video= { "mp4", "avi", "mpg", "qt", "mov", "3gp", ".webm", "wav", "aiff", "mp3", "aac", "wma", "opus" },

                                            List videoexe = [
                                              "mp4",
                                              "avi",
                                              "mpg",
                                              "qt",
                                              "mov",
                                              "3gp",
                                              ".webm"
                                            ];
                                            bool isVideo = false;
                                            String? mediatype;
                                            for (var i = 0;
                                                i < videoexe.length;
                                                i++) {
                                              if (videoexe[i] == type[1]) {
                                                mediatype = 'video';
                                                isVideo = true;
                                              } else {
                                                print('Not Found');
                                              }
                                            }

                                            List picexe = [
                                              "JPG",
                                              "JPEG",
                                              "PNG",
                                              "GIF",
                                              "WebP"
                                            ];
                                            bool isimage = false;
                                            for (var i = 0;
                                                i < picexe.length;
                                                i++) {
                                              if (picexe[i] == type[1]) {
                                                isimage = true;
                                              } else {
                                                print('audio not found');
                                              }
                                            }

                                            List audioexe = [
                                              "wav",
                                              "aiff",
                                              "mp3",
                                              "aac",
                                              "wma",
                                              "opus",
                                              "ogg",
                                              "m4a"
                                            ];
                                            bool isAudio = false;
                                            String? audiotype;
                                            for (var i = 0;
                                                i < audioexe.length;
                                                i++) {
                                              if (audioexe[i] == type[1]) {
                                                audiotype = 'audio';
                                                isAudio = true;
                                              } else {
                                                print('audio not found');
                                              }
                                            }
                                            //var baseURL2='http://10.1.1.13:8081/';
                                            String videourl =
                                                '${baseUrl2}/Video/Index?name=${attachments[index]['Name']}&type=${mediatype}';
                                            String audiourl =
                                                '${baseUrl2}/Video/Index?name=${attachments[index]['Name']}&type=${audiotype}';
                                            //  Future<void> _launchInWebViewOrVC() async{
                                            //         if(await canLaunchUrl(Uri.parse(videourl))){
                                            //           await launchUrl(
                                            //             Uri.parse(videourl),
                                            //             mode: LaunchMode.inAppWebView,
                                            //         );
                                            //                                                                 }
                                            //         else{
                                            //           print('Can not use url');
                                            //         }
                                            //       }
                                            // final bytes =
                                            //     Io.File(attachments[index]['File'])
                                            //         .readAsBytesSync();

                                            // String img64 = base64Encode(bytes);
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      isVideo
                                                          ? Icon(
                                                              Icons
                                                                  .video_camera_back,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      117,
                                                                      116,
                                                                      116),
                                                            )
                                                          : isAudio
                                                              ? Icon(
                                                                  Icons.mic,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          117,
                                                                          116,
                                                                          116),
                                                                )
                                                              : isimage
                                                                  ? Icon(
                                                                      Icons
                                                                          .image,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          117,
                                                                          116,
                                                                          116),
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .file_copy,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          117,
                                                                          116,
                                                                          116),
                                                                    ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 290,
                                                        // color: Colors.amber,
                                                        child: InkWell(
                                                          onTap: () {
                                                            print('Hello');
                                                            print(videourl);

                                                            if (isVideo) {
                                                              openAudioVideo(
                                                                  videourl);
                                                            } else if (isAudio) {
                                                              openAudioVideo(
                                                                  audiourl);
                                                            } else {
                                                              _createFileFromString(
                                                                  attachments[
                                                                          index]
                                                                      ['File'],
                                                                  attachments[
                                                                          index]
                                                                      [
                                                                      'FileExtension']);
                                                            }

                                                            // _createFileFromString(attachments[index]['File'], attachments[index]['FileExtension']);
                                                          },
                                                          child: Text(
                                                              attachments[index]
                                                                      ['Name']
                                                                  .toString()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          dateTimeFormat!,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Container(
                                                          width: 142,
                                                          child: Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            attachments[index][
                                                                        'DataEntryName'] ==
                                                                    null
                                                                ? ''
                                                                : attachments[
                                                                            index]
                                                                        [
                                                                        'DataEntryName']
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .grey[600]),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            );
                                          }))
                                ]),
                          ),

                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
