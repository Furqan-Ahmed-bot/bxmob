// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_element, prefer_final_fields, unnecessary_brace_in_string_interps, unused_local_variable, use_build_context_synchronously, avoid_print, unused_field, sort_child_properties_last

import 'dart:convert';

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/Models/ApiResponse/ApiResponse.dart';
import 'package:ts_app_development/DataLayer/Providers/APIConnectionProvider/apiConnectionProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/Generic/AppScreens/appScreens.dart';
import 'package:ts_app_development/OrderTicket/myTicket.dart';
import 'package:ts_app_development/WaitersOrder/SelectTable.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../DataLayer/Providers/DataProvider/dataProvider.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../DataLayer/Services/AuthenticationService/authenticationService.dart';
import '../../Generic/APIConstant/apiConstant.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../../OrderTicket/dashboardMenusForWeb.dart';

import '../../OrderTicket/tempPageforUrlTesting.dart';
import '../PageRouteBuilder/pageRouteBuilder.dart';
import 'dart:math' as math;

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  //int levelOne = 0;
  //int selected = 3;
  bool isDisable = false;
  bool? _isSupportMenu;

  get http => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    APIConnectionProvider apiProvider =
        Provider.of<APIConnectionProvider>(context);

    //  print('This is my support data ${dataProvider.supportData}');
    print('This is  ${dataProvider.rolesData}');

    //  print('This is name ${dataProvider.supportData[0]['MenuName']}');

    void openWeb(String route) async {
      final prefs = await SharedPreferences.getInstance();
      final user = prefs.getString('user') ?? '';
      final appKey = prefs.getString('appKey') ?? '';
      String username = 'technosys';
      String password = 'Tech710';
      String basicAuth = 'Basic ' +
          base64Encode(
              utf8.encode('${username}:$password')); //ToDo, get from user
      Map<String, dynamic> userMap = jsonDecode(user);
      var hashMapHeader = <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        // "Authorization" : basicAuth,
        // "Content-type": 'application/json'
      };

      var url = ApiConstant.clientAPIs[appKey]!['url'] + '/technosys' + route;
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url,
            mode: LaunchMode.inAppWebView,
            webViewConfiguration: WebViewConfiguration(headers: hashMapHeader));
      }
      print('URL is' + url);
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            context.read<ThemeProvider>().selectedPrimaryColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Picture Container
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                          top: 10.0,
                          bottom: 15.0,
                        ),
                        child: userProvider.userData['ImageBlock'] != null
                            ?
                            // ? Container(
                            //     height: 80,
                            //     width: 80,
                            //     child: CircleAvatar(
                            //       child: PhysicalModel(
                            //           elevation: 20.0,
                            //           color: Colors.transparent,
                            //           child: Image.memory(
                            //             base64Decode(userProvider
                            //                 .userData['ImageBlock']),
                            //             height: screenSize.height * 0.13,
                            //             width: screenSize.width * 0.25,
                            //           )),
                            //     ),
                            //   )
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 115, 161, 182),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(
                                        base64Decode(userProvider
                                            .userData['ImageBlock']),
                                      )),
                                ),
                              )
                            // CircleAvatar(

                            //     radius: 30,
                            //     backgroundImage: (MemoryImage(

                            //       base64Decode(
                            //           userProvider.userData['ImageBlock']),
                            //     )),
                            //   )
                            : Center(
                                child: Text(
                                  'No Image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: context
                                        .read<ThemeProvider>()
                                        .selectedPrimaryColor,
                                    fontSize: AppConst.appFontSizeh10,
                                    fontWeight: AppConst.appTextFontWeightBold,
                                  ),
                                ),
                              ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ElevatedButton(
                            //     onPressed: () {
                            //       //Get.to(UrlTesting());
                            //     },
                            //     child: Text('Off')),
                            Container(
                              alignment: Alignment.center,
                              width: screenSize.width * 0.5,
                              child: Text(
                                '${userProvider.userData['EmployeeName']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        AppConst.appTextFontWeightMedium,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            // Designation Container
                            Text(
                              '${userProvider.userData['Designation']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: AppConst.appFontSizeh11,
                                fontWeight:
                                    AppConst.appTextFontWeightExtraLight,
                              ),
                            ),
                            // Department Container
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppConst.appMainBodyVerticalPadding),
                              child: Text(
                                '${userProvider.userData['Department']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: AppConst.appFontSizeh11,
                                  fontWeight:
                                      AppConst.appTextFontWeightExtraLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: ListTile(
                title: const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: AppConst.appFontSizeh10,
                  ),
                ),
                leading: const Icon(Icons.dashboard_outlined),
                onTap: () {
                  Navigator.pushReplacement(context,
                      CustomPageRouteBuilder.createRoute('/Dashboard'));
                },
                textColor: AppConst.appColorText,
                minLeadingWidth: 10.0,
                iconColor: AppConst.appColorText,
              ),
            ),
            // SizedBox(height : 20),
            // IntrinsicHeight(
            //   child: ListTile(
            //     title: const Text(
            //       'POS',
            //       style: TextStyle(
            //         fontSize: AppConst.appFontSizeh10,
            //       ),
            //     ),
            //     leading: const Icon(Icons.dashboard_outlined),
            //     onTap: () {
            //       Get.to(PointOfSell());
            //     },
            //     textColor: AppConst.appColorText,
            //     minLeadingWidth: 10.0,
            //     iconColor: AppConst.appColorText,
            //   ),
            // ),
            // Dynamic Menu
            SizedBox(
              height: screenSize.height * 0.50,
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int levelOne = 0;
                          levelOne < dataProvider.rolesData.length;
                          levelOne++)
                        ExpansionWidget(
                            titleBuilder: (double animationValue, _,
                                bool isExpaned, toogleFunction) {
                              return InkWell(
                                  onTap: () => toogleFunction(animated: true),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Icon(Icons.dashboard_outlined),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                dataProvider.rolesData[levelOne]
                                                    ['MenuName'],
                                                style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Transform.rotate(
                                            angle: math.pi * animationValue / 2,
                                            child: Icon(Icons.arrow_right,
                                                size: 25),
                                            alignment: Alignment.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                            content: Column(
                              children: [
                                for (int levelTwo = 0;
                                    levelTwo <
                                        dataProvider
                                            .rolesData[levelOne]['MenuChildren']
                                            .length;
                                    levelTwo++)
                                  dataProvider
                                              .rolesData[levelOne]
                                                  ['MenuChildren'][levelTwo]
                                                  ['MenuChildren']
                                              .length >
                                          0
                                      ? ExpansionWidget(
                                          titleBuilder: (double animationValue,
                                              _,
                                              bool isExpaned,
                                              toogleFunction) {
                                            return InkWell(
                                                onTap: () => toogleFunction(
                                                    animated: true),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 30, top: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.dashboard,
                                                        size: 20,
                                                        color: Colors.grey[800],
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          dataProvider.rolesData[
                                                                  levelOne]
                                                              ['MenuName'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: AppConst
                                                                .appFontSizeh11,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: Transform.rotate(
                                                          angle: math.pi *
                                                              animationValue /
                                                              2,
                                                          child: Icon(
                                                              Icons.arrow_right,
                                                              size: 25),
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          },
                                          content: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(0),
                                            child: Column(
                                              children: [
                                                for (int levelThree = 0;
                                                    levelThree <
                                                        dataProvider
                                                            .rolesData[levelOne]
                                                                ['MenuChildren']
                                                                [levelTwo]
                                                                ['MenuChildren']
                                                            .length;
                                                    levelThree++)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 10),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        final prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        final user =
                                                            prefs.getString(
                                                                    'user') ??
                                                                '';
                                                        final appKey =
                                                            prefs.getString(
                                                                    'appKey') ??
                                                                '';
                                                        // ignore: non_constant_identifier_names
                                                        final Url =
                                                            prefs.getString(
                                                                    'Url') ??
                                                                '';
                                                        Map<String, dynamic>
                                                            userMap =
                                                            jsonDecode(user);
                                                        var obj = dataProvider
                                                                            .rolesData[
                                                                        levelOne]
                                                                    [
                                                                    'MenuChildren']
                                                                [levelTwo][
                                                            'MenuChildren'][levelThree];
                                                        if (obj['IsVisibleWeb'] >
                                                            0) {
                                                          Get.to(
                                                              DashboardMenusForWeb(
                                                            route: obj['ModuleFormStatus'] ==
                                                                    5
                                                                ? ('/Dashboard/' +
                                                                    obj[
                                                                        'FormName'] +
                                                                    '/' +
                                                                    obj['ENId'])
                                                                : ('/Application/' +
                                                                    obj['FormName']),
                                                            appKey: appKey,
                                                            user: user,
                                                            userMap: userMap,
                                                            appurl: Url,
                                                          ));
                                                        } else {
                                                          var comp = AppScreens
                                                                      .screens[
                                                                  levelOne]
                                                              ['Component'];
                                                          Navigator.pushReplacement(
                                                              context,
                                                              CustomPageRouteBuilder
                                                                  .createRoute(AppScreens
                                                                              .screens[
                                                                          levelOne]
                                                                      [
                                                                      'Route']));
                                                        }
                                                      },
                                                      child: Text(
                                                        dataProvider.rolesData[
                                                                            levelOne]
                                                                        [
                                                                        'MenuChildren']
                                                                    [levelTwo]
                                                                ['MenuChildren']
                                                            [
                                                            levelThree]['FormName'],
                                                        style: const TextStyle(
                                                          fontSize: AppConst
                                                              .appFontSizeh10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ))
                                      : ExpansionWidget(
                                          initiallyExpanded: true,
                                          titleBuilder: (double animationValue,
                                              _,
                                              bool isExpaned,
                                              toogleFunction) {
                                            return InkWell(
                                                onTap: () => toogleFunction(
                                                    animated: true),
                                                child: Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () async {
                                                            final prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            final user =
                                                                prefs.getString(
                                                                        'user') ??
                                                                    '';
                                                            final appKey =
                                                                prefs.getString(
                                                                        'appKey') ??
                                                                    '';
                                                            final Url =
                                                                prefs.getString(
                                                                        'Url') ??
                                                                    '';

                                                            Map<String, dynamic>
                                                                userMap =
                                                                jsonDecode(
                                                                    user);
                                                            var obj = dataProvider
                                                                            .rolesData[
                                                                        levelOne]
                                                                    [
                                                                    'MenuChildren']
                                                                [levelTwo];
                                                            if (obj['SoftwareModuleFormId'] ==
                                                                808) {
                                                              Get.to(myTicket(
                                                                isSupportMenu:
                                                                    _isSupportMenu =
                                                                        false,
                                                              ));
                                                              print('Found');
                                                            } else {
                                                              print(
                                                                  'Not Found');
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  CustomPageRouteBuilder
                                                                      .createRoute(
                                                                          '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));

                                                              if (obj['IsVisibleWeb'] >
                                                                  0) {
                                                                Get.to(
                                                                    DashboardMenusForWeb(
                                                                  route: obj['ModuleFormStatus'] ==
                                                                          5
                                                                      ? ('/Dashboard/' +
                                                                          obj[
                                                                              'FormName'] +
                                                                          '/' +
                                                                          obj[
                                                                              'ENId'])
                                                                      : ('/Application/' +
                                                                          obj['FormName']),
                                                                  appKey:
                                                                      appKey,
                                                                  user: user,
                                                                  userMap:
                                                                      userMap,
                                                                  appurl: Url,
                                                                ));
                                                              } else {
                                                                var obj = dataProvider
                                                                            .rolesData[
                                                                        levelOne]
                                                                    [
                                                                    'MenuChildren'][levelTwo];
                                                                if (obj['SoftwareModuleFormId'] ==
                                                                    808) {
                                                                  Get.to(
                                                                      myTicket(
                                                                    isSupportMenu:
                                                                        _isSupportMenu =
                                                                            false,
                                                                  ));
                                                                  print(
                                                                      'Found');
                                                                } else {
                                                                  print(
                                                                      'Not Found');
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      CustomPageRouteBuilder
                                                                          .createRoute(
                                                                              '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                                                                }

                                                                //     Navigator.pushReplacement(
                                                                // context,
                                                                // CustomPageRouteBuilder.createRoute(
                                                                //     '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));

                                                              }
                                                            }

                                                            // var obj = dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo];
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    top: 5),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: AppConst
                                                                          .appMainPaddingSmall),
                                                                  child: dataProvider
                                                                              .rolesData[levelOne]['MenuChildren'][levelTwo][
                                                                                  'FormName']
                                                                              .length ==
                                                                          0
                                                                      ? const Icon(
                                                                          Icons
                                                                              .dashboard_outlined)
                                                                      : (AppScreens.screenIcons[dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]
                                                                              [
                                                                              'FormName']] ??
                                                                          Icon(
                                                                            Icons.dashboard,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.grey[800],
                                                                          )),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  child: Text(
                                                                    dataProvider.rolesData[levelOne]['MenuChildren']
                                                                            [
                                                                            levelTwo]
                                                                        [
                                                                        'MenuName'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh11,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          },
                                          content: Column(children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       left: AppConst
                                            //           .appMainPaddingSmall),
                                            //   child: dataProvider
                                            //               .rolesData[levelOne]
                                            //                   ['MenuChildren']
                                            //                   [levelTwo]
                                            //                   ['FormName']
                                            //               .length ==
                                            //           0
                                            //       ? const Icon(
                                            //           Icons.dashboard_outlined)
                                            //       : (AppScreens
                                            //               .screenIcons[dataProvider
                                            //                           .rolesData[
                                            //                       levelOne]
                                            //                   ['MenuChildren']
                                            //               [levelTwo]['FormName']] ??
                                            //          Text('')

                                            //           ),
                                            // ),
                                          ]),
                                        ),

                                //       ListTile(
                                //           minVerticalPadding: 0,
                                //           title: Padding(
                                //             padding:
                                //                 const EdgeInsets.only(left: 0),
                                //             child: Text(
                                //               dataProvider.rolesData[levelOne]
                                //                       ['MenuChildren'][levelTwo]
                                //                   ['MenuName'],
                                //               style: const TextStyle(
                                //                 fontSize: AppConst.appFontSizeh11,
                                //               ),
                                //             ),
                                //           ),
                                //           onTap: () async {
                                //             final prefs = await SharedPreferences
                                //                 .getInstance();
                                //             final user =
                                //                 prefs.getString('user') ?? '';
                                //             final appKey =
                                //                 prefs.getString('appKey') ?? '';
                                //             Map<String, dynamic> userMap =
                                //                 jsonDecode(user);
                                //             var obj =
                                //                 dataProvider.rolesData[levelOne]
                                //                     ['MenuChildren'][levelTwo];
                                //             if (obj['SoftwareModuleFormId'] ==
                                //                 808) {
                                //               Get.to(myTicket(
                                //                 isSupportMenu: _isSupportMenu =
                                //                     false,
                                //               ));
                                //               print('Found');
                                //             } else {
                                //               print('Not Found');
                                //               Navigator.pushReplacement(
                                //                   context,
                                //                   CustomPageRouteBuilder.createRoute(
                                //                       '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                                //             }

                                //             // var obj = dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo];

                                //             if (obj['IsVisibleWeb'] > 0) {
                                //               Get.to(Demo(
                                //                 route:
                                //                     obj['ModuleFormStatus'] == 5
                                //                         ? ('/Dashboard/' +
                                //                             obj['FormName'] +
                                //                             '/' +
                                //                             obj['ENId'])
                                //                         : ('/Application/' +
                                //                             obj['FormName']),
                                //                 appKey: appKey,
                                //                 user: user,
                                //                 userMap: userMap,
                                //               ));
                                //             } else {
                                //               var obj =
                                //                   dataProvider.rolesData[levelOne]
                                //                       ['MenuChildren'][levelTwo];
                                //               if (obj['SoftwareModuleFormId'] ==
                                //                   808) {
                                //                 Get.to(myTicket(
                                //                   isSupportMenu: _isSupportMenu =
                                //                       false,
                                //                 ));
                                //                 print('Found');
                                //               } else {
                                //                 print('Not Found');
                                //                 Navigator.pushReplacement(
                                //                     context,
                                //                     CustomPageRouteBuilder
                                //                         .createRoute(
                                //                             '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                                //               }

                                //               //     Navigator.pushReplacement(
                                //               // context,
                                //               // CustomPageRouteBuilder.createRoute(
                                //               //     '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));

                                //             }
                                //           },
                                //           leading: Padding(
                                //             padding: const EdgeInsets.only(
                                //                 left: AppConst
                                //                     .appMainPaddingMedium),
                                //             child: dataProvider
                                //                         .rolesData[levelOne]
                                //                             ['MenuChildren']
                                //                             [levelTwo]['FormName']
                                //                         .length ==
                                //                     0
                                //                 ? const Icon(
                                //                     Icons.dashboard_outlined)
                                //                 : (AppScreens
                                //                         .screenIcons[dataProvider
                                //                                     .rolesData[
                                //                                 levelOne]
                                //                             ['MenuChildren']
                                //                         [levelTwo]['FormName']] ??
                                //                     const Icon(
                                //                       Icons.dashboard_outlined,
                                //                       size: 20,
                                //                     )),
                                //           ),
                                //           textColor: AppConst.appColorText,
                                //           minLeadingWidth: 10.0,
                                //           iconColor: AppConst.appColorText,
                                //         ),
                                // Container(
                                //   width: double.infinity,
                                //   padding: EdgeInsets.all(0),
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(left: 20),
                                //     child: Text('Expaned Content'),
                                //   ),
                                // ),
                              ],
                            )),
                      // ExpansionTile(
                      //   title: Padding(
                      //     padding: const EdgeInsets.all(0),
                      //     child: Text(
                      //       dataProvider.rolesData[levelOne]['MenuName'],
                      //       style: const TextStyle(
                      //         fontSize: AppConst.appFontSizeh11,
                      //       ),
                      //     ),
                      //   ),
                      //   leading: Padding(
                      //     padding: const EdgeInsets.all(0),
                      //     child: const Icon(Icons.dashboard , size: 20,),
                      //   ),
                      //   textColor: AppConst.appColorText,
                      //   iconColor: AppConst.appColorText,
                      //   //initiallyExpanded: levelOne==selected,
                      //   children: <Widget>[
                      //     for (int levelTwo = 0;
                      //         levelTwo <
                      //             dataProvider
                      //                 .rolesData[levelOne]['MenuChildren']
                      //                 .length;
                      //         levelTwo++)
                      //       dataProvider
                      //                   .rolesData[levelOne]['MenuChildren']
                      //                       [levelTwo]['MenuChildren']
                      //                   .length >
                      //               0
                      //           ? ExpansionTile(

                      //               title: Text(
                      //                 dataProvider.rolesData[levelOne]
                      //                     ['MenuName'],
                      //                 style: const TextStyle(
                      //                   fontSize: AppConst.appFontSizeh11,
                      //                 ),
                      //               ),
                      //               leading: const Icon(Icons.dashboard , size: 20,),
                      //               textColor: AppConst.appColorText,
                      //               iconColor: AppConst.appColorText,
                      //               children: <Widget>[
                      //                 for (int levelThree = 0;
                      //                     levelThree <
                      //                         dataProvider
                      //                             .rolesData[levelOne]
                      //                                 ['MenuChildren'][levelTwo]
                      //                                 ['MenuChildren']
                      //                             .length;
                      //                     levelThree++)
                      //                   ListTile(

                      //                     title: Text(
                      //                       dataProvider.rolesData[levelOne]
                      //                                   ['MenuChildren']
                      //                               [levelTwo]['MenuChildren']
                      //                           [levelThree]['FormName'],
                      //                       style: const TextStyle(
                      //                         fontSize:
                      //                             AppConst.appFontSizeh10,
                      //                       ),
                      //                     ),
                      //                     onTap: () async{
                      //                 final prefs = await SharedPreferences.getInstance();
                      //                 final user = prefs.getString('user') ?? '';
                      //                 final appKey = prefs.getString('appKey') ?? '';
                      //                  Map<String, dynamic> userMap = jsonDecode(user);
                      //                       var obj = dataProvider
                      //                                   .rolesData[levelOne]
                      //                               ['MenuChildren'][levelTwo]
                      //                           ['MenuChildren'][levelThree];
                      //                       if (obj['IsVisibleWeb'] > 0) {
                      //                         Get.to(  Demo(route:
                      //                             obj['ModuleFormStatus'] == 5
                      //                                 ? ('/Dashboard/' +
                      //                                     obj['FormName'] +
                      //                                     '/' +
                      //                                     obj['ENId'])
                      //                                 : ('/Application/' +
                      //                                     obj['FormName']),
                      //                                   appKey: appKey,
                      //                                   user: user,
                      //                                   userMap: userMap,

                      //                                     ));

                      //                       } else {
                      //                         var comp =
                      //                             AppScreens.screens[levelOne]
                      //                                 ['Component'];
                      //                         Navigator.pushReplacement(
                      //                             context,
                      //                             CustomPageRouteBuilder
                      //                                 .createRoute(AppScreens
                      //                                         .screens[levelOne]
                      //                                     ['Route']));
                      //                       }
                      //                     },
                      //                     leading: const Padding(
                      //                       padding: EdgeInsets.only(
                      //                           left: AppConst
                      //                               .appMainPaddingMedium),
                      //                       child:
                      //                           Icon(Icons.dashboard_outlined),
                      //                     ),
                      //                     textColor: AppConst.appColorText,
                      //                     minLeadingWidth: 10.0,
                      //                     iconColor: AppConst.appColorText,
                      //                   ),
                      //               ],
                      //             )
                      //           : ListTile(
                      //             minVerticalPadding: 0,
                      //               title: Padding(

                      //                 padding: const EdgeInsets.only(
                      //                     left: 0),
                      //                 child: Text(
                      //                   dataProvider.rolesData[levelOne]
                      //                           ['MenuChildren'][levelTwo]
                      //                       ['MenuName'],
                      //                   style: const TextStyle(
                      //                     fontSize: AppConst.appFontSizeh11,
                      //                   ),
                      //                 ),
                      //               ),
                      //               onTap: () async{
                      //                 final prefs = await SharedPreferences.getInstance();
                      //                 final user = prefs.getString('user') ?? '';
                      //                 final appKey = prefs.getString('appKey') ?? '';
                      //                  Map<String, dynamic> userMap = jsonDecode(user);
                      //                 var obj = dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo];
                      //                 if (obj['SoftwareModuleFormId'] == 808){
                      //                 Get.to(myTicket(isSupportMenu: _isSupportMenu = false,));                                        print('Found');
                      //                 } else {
                      //                   print('Not Found');
                      //                        Navigator.pushReplacement(
                      //                 context,
                      //                 CustomPageRouteBuilder.createRoute(
                      //                     '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                      //                 }

                      //                 // var obj = dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo];

                      //                   if (obj['IsVisibleWeb'] > 0) {

                      //                     Get.to(
                      //                        Demo(route:
                      //                         obj['ModuleFormStatus'] == 5
                      //                             ? ('/Dashboard/' +
                      //                                 obj['FormName'] +
                      //                                 '/' +
                      //                                 obj['ENId'])
                      //                             : ('/Application/' +
                      //                                 obj['FormName']),

                      //                            appKey: appKey,
                      //                            user: user,
                      //                            userMap: userMap,
                      //                                  )
                      //                     );

                      //                   }
                      //                   else{
                      //                        var obj = dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo];
                      //                 if (obj['SoftwareModuleFormId'] == 808){
                      //                 Get.to(myTicket(isSupportMenu: _isSupportMenu = false,));                                        print('Found');
                      //                 } else {
                      //                   print('Not Found');
                      //                        Navigator.pushReplacement(
                      //                 context,
                      //                 CustomPageRouteBuilder.createRoute(
                      //                     '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                      //                 }

                      //                 //     Navigator.pushReplacement(
                      //                 // context,
                      //                 // CustomPageRouteBuilder.createRoute(
                      //                 //     '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));

                      //                   }

                      //               },
                      //               leading: Padding(
                      //                 padding: const EdgeInsets.only(
                      //                     left: AppConst.appMainPaddingMedium),
                      //                 child: dataProvider
                      //                             .rolesData[levelOne]
                      //                                 ['MenuChildren'][levelTwo]
                      //                                 ['FormName']
                      //                             .length ==
                      //                         0
                      //                     ? const Icon(Icons.dashboard_outlined)
                      //                     : (AppScreens.screenIcons[dataProvider
                      //                                     .rolesData[levelOne]
                      //                                 ['MenuChildren'][levelTwo]
                      //                             ['FormName']] ??
                      //                         const Icon(
                      //                             Icons.dashboard_outlined , size: 20,)),
                      //               ),
                      //               textColor: AppConst.appColorText,
                      //               minLeadingWidth: 10.0,
                      //               iconColor: AppConst.appColorText,
                      //             ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //will do come code improvements
                          for (int levelOne = 0;
                              levelOne < dataProvider.supportData.length;
                              levelOne++)
                            ExpansionWidget(
                                titleBuilder: (double animationValue, _,
                                    bool isExpaned, toogleFunction) {
                                  return InkWell(
                                      onTap: () =>
                                          toogleFunction(animated: true),
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Icon(Icons.help),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Text(
                                                dataProvider
                                                        .supportData[levelOne]
                                                    ['MenuName'],
                                                style: const TextStyle(
                                                  fontSize:
                                                      AppConst.appFontSizeh11,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Transform.rotate(
                                                angle: math.pi *
                                                    animationValue /
                                                    2,
                                                child: Icon(Icons.arrow_right,
                                                    size: 25),
                                                alignment: Alignment.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                },
                                content: Column(
                                  children: [
                                    for (int levelTwo = 0;
                                        levelTwo <
                                            dataProvider
                                                .supportData[levelOne]
                                                    ['MenuChildren']
                                                .length;
                                        levelTwo++)
                                      dataProvider
                                                  .supportData[levelOne]
                                                      ['MenuChildren'][levelTwo]
                                                      ['MenuChildren']
                                                  .length >
                                              0
                                          ? ExpansionWidget(
                                              initiallyExpanded: true,
                                              titleBuilder: (double animationValue,
                                                  _,
                                                  bool isExpaned,
                                                  toogleFunction) {
                                                return InkWell(
                                                    onTap: () => toogleFunction(
                                                        animated: true),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              dataProvider.supportData[
                                                                      levelOne]
                                                                  ['MenuName'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 30),
                                                            child: Transform
                                                                .rotate(
                                                              angle: math.pi *
                                                                  animationValue /
                                                                  2,
                                                              child: Icon(
                                                                  Icons
                                                                      .arrow_right,
                                                                  size: 20),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ));
                                              },
                                              content: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child:
                                                      Text('Expaned Content'),
                                                ),
                                              ))

                                          // ListTileTheme(
                                          //     contentPadding: EdgeInsets.all(0),
                                          //     child: ExpansionTile(
                                          //       title: Text(
                                          //         dataProvider.supportData[levelOne]
                                          //             ['MenuName'],
                                          //         style: const TextStyle(
                                          //           fontSize: AppConst.appFontSizeh11,
                                          //         ),
                                          //       ),
                                          //       leading: const Icon(Icons.dashboard),
                                          //       textColor: AppConst.appColorText,
                                          //       iconColor: AppConst.appColorText,
                                          //       children: <Widget>[
                                          //         // for (int levelThree = 0;
                                          //         //     levelThree <
                                          //         //         dataProvider
                                          //         //             .supportData[levelOne]
                                          //         //                 ['MenuChildren'][levelTwo]
                                          //         //                 ['MenuChildren']
                                          //         //             .length;
                                          //         //     levelThree++)
                                          //       ],
                                          //     ),
                                          //   )
                                          : dataProvider.supportData[levelOne]
                                                              ['MenuChildren'][levelTwo]
                                                          ['ModuleFormStatus'] >
                                                      0 &&
                                                  dataProvider.supportData[levelOne]['SoftwareModuleFormId'] >=
                                                      0
                                              ? ExpansionWidget(
                                                  titleBuilder:
                                                      (double animationValue,
                                                          _,
                                                          bool isExpaned,
                                                          toogleFunction) {
                                                    return InkWell(
                                                        onTap: () =>
                                                            toogleFunction(
                                                                animated: true),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 30,
                                                                  top: 10),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .support_agent,
                                                                size: 20,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Get.to(
                                                                        myTicket(
                                                                      isSupportMenu:
                                                                          _isSupportMenu =
                                                                              true,
                                                                    ));
                                                                  },
                                                                  child: Text(
                                                                    dataProvider.supportData[levelOne]['MenuChildren']
                                                                            [
                                                                            levelTwo]
                                                                        [
                                                                        'MenuName'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh11,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding: const EdgeInsets.only(right: 30),
                                                              //   child: Transform.rotate(
                                                              //     angle: math.pi * animationValue / 2,
                                                              //     child: Icon(Icons.arrow_right, size: 20),
                                                              //     alignment: Alignment.center,
                                                              //   ),
                                                              // )
                                                            ],
                                                          ),
                                                        ));
                                                  },
                                                  content: Padding(
                                                    padding: const EdgeInsets
                                                            .only(
                                                        left: AppConst
                                                            .appMainPaddingMedium),
                                                    child: dataProvider.rolesData[levelOne]
                                                                            ['MenuChildren']
                                                                        [levelTwo]
                                                                    [
                                                                    'FormName'] ==
                                                                null ||
                                                            dataProvider
                                                                .rolesData[levelOne]
                                                                    ['MenuChildren']
                                                                    [levelTwo]
                                                                    ['FormName']
                                                                .isEmpty
                                                        ? Text('')
                                                        : dataProvider
                                                                    .rolesData[levelOne]
                                                                        ['MenuChildren']
                                                                        [levelTwo]
                                                                        ['FormName']
                                                                    .length ==
                                                                0
                                                            ? const Icon(Icons.dashboard_outlined)
                                                            : (AppScreens.screenIcons[dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']] ?? const Icon(Icons.support_agent)),
                                                  ),
                                                )

                                              // ListTile(
                                              //     title: Padding(
                                              //       padding: const EdgeInsets.only(
                                              //           left: AppConst
                                              //               .appMainPaddingMedium),
                                              //       child: Row(
                                              //         children: [
                                              //           Icon(Icons.support_agent),
                                              //           SizedBox(
                                              //             width: 10,
                                              //           ),
                                              //           Text(
                                              //             dataProvider.supportData[
                                              //                         levelOne]
                                              //                     ['MenuChildren']
                                              //                 [levelTwo]['MenuName'],
                                              //             style: const TextStyle(
                                              //               fontSize: AppConst
                                              //                   .appFontSizeh11,
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     onTap: () {
                                              //       // Get.to(Ticket());
                                              //       Get.to(myTicket(
                                              //         isSupportMenu: _isSupportMenu =
                                              //             true,
                                              //       ));
                                              //     },
                                              //     leading: Padding(
                                              //       padding: const EdgeInsets.only(
                                              //           left: AppConst
                                              //               .appMainPaddingMedium),
                                              //       child: dataProvider.rolesData[levelOne]
                                              //                               ['MenuChildren']
                                              //                           [levelTwo]
                                              //                       ['FormName'] ==
                                              //                   null ||
                                              //               dataProvider
                                              //                   .rolesData[levelOne]
                                              //                       ['MenuChildren']
                                              //                       [levelTwo]
                                              //                       ['FormName']
                                              //                   .isEmpty
                                              //           ? Text('')
                                              //           : dataProvider
                                              //                       .rolesData[levelOne]
                                              //                           ['MenuChildren']
                                              //                           [levelTwo]
                                              //                           ['FormName']
                                              //                       .length ==
                                              //                   0
                                              //               ? const Icon(Icons.dashboard_outlined)
                                              //               : (AppScreens.screenIcons[dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']] ?? const Icon(Icons.support_agent)),
                                              //     ),
                                              //     textColor: AppConst.appColorText,
                                              //     minLeadingWidth: 10.0,
                                              //     iconColor: AppConst.appColorText,
                                              //   )
                                              : ExpansionWidget(
                                                  titleBuilder: (double animationValue,
                                                      _,
                                                      bool isExpaned,
                                                      toogleFunction) {
                                                    return InkWell(
                                                        onTap: () =>
                                                            toogleFunction(
                                                                animated: true),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Icon(Icons
                                                                  .support_agent),

                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  dataProvider.supportData[levelOne]
                                                                              [
                                                                              'MenuChildren']
                                                                          [
                                                                          levelTwo]
                                                                      [
                                                                      'MenuName'],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh10,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding: const EdgeInsets.only(right: 30),
                                                              //   child: Transform.rotate(
                                                              //     angle: math.pi * animationValue / 2,
                                                              //     child: Icon(Icons.arrow_right, size: 20),
                                                              //     alignment: Alignment.center,
                                                              //   ),
                                                              // )
                                                            ],
                                                          ),
                                                        ));
                                                  },
                                                  content: Text(''))

                                    // ListTile(
                                    //     title: Padding(
                                    //       padding: const EdgeInsets
                                    //               .only(
                                    //           left: AppConst
                                    //               .appMainPaddingMedium),
                                    //       child: Text(
                                    //         dataProvider.supportData[
                                    //                     levelOne]
                                    //                 ['MenuChildren']
                                    //             [levelTwo]['MenuName'],
                                    //         style: const TextStyle(
                                    //           fontSize: AppConst
                                    //               .appFontSizeh10,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     onTap: () {
                                    //       // Navigator.pushReplacement(
                                    //       //     context,
                                    //       //     CustomPageRouteBuilder.createRoute(
                                    //       //         '/${dataProvider.supportData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                                    //     },
                                    //     leading: Padding(
                                    //       padding: const EdgeInsets
                                    //               .only(
                                    //           left: AppConst
                                    //               .appMainPaddingMedium),
                                    //       child: dataProvider
                                    //                   .supportData[
                                    //                       levelOne]
                                    //                       ['MenuChildren']
                                    //                       [levelTwo]
                                    //                       ['FormName']
                                    //                   .length ==
                                    //               0
                                    //           ? const Icon(Icons
                                    //               .dashboard_outlined)
                                    //           : (AppScreens.screenIcons[
                                    //                   dataProvider.supportData[levelOne]
                                    //                               ['MenuChildren']
                                    //                           [levelTwo]
                                    //                       ['FormName']] ??
                                    //               const Icon(Icons.support_agent)),
                                    //     ),
                                    //     textColor: Colors.grey,
                                    //     minLeadingWidth: 10.0,
                                    //     iconColor: Colors.grey,
                                    //   ),
                                  ],
                                )),
                          SizedBox(
                            height: 5,
                          ),

                          ListTile(
                            dense: true,
                            title: const Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: AppConst.appFontSizeh11,
                              ),
                            ),
                            leading: const Icon(
                              Icons.settings,
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  CustomPageRouteBuilder.createRoute(
                                      '/settings'));
                            },
                            textColor: AppConst.appColorText,
                            minLeadingWidth: 20.0,
                            iconColor: AppConst.appColorText,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppConst.appMainPaddingMedium),
                            child: ListTile(
                              dense: true,
                              onTap: () async {
                                Functions.ShowPopUpDialog(
                                  context,
                                  'Confirm',
                                  SizedBox(
                                    width: screenSize.width * 0.65,
                                    height: 40.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  AppConst.appMainPaddingLarge),
                                          child: Text(
                                            'Are you sure?',
                                            style: TextStyle(
                                              fontSize: AppConst.appFontSizeh9,
                                              fontWeight: AppConst
                                                  .appTextFontWeightLight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  () async {
                                    try {
                                      if (userProvider.userData.isNotEmpty) {
                                        ApiResponse response =
                                            await AuthenticationService()
                                                .logoutUser(
                                                    userProvider
                                                        .userData['UserId']
                                                        .toString(),
                                                    userProvider
                                                        .userData['GUID'],
                                                    apiProvider.selectedAppKey);
                                        if (response.Data == "success") {
                                          if (mounted) {
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                            Functions.ShowSnackBar(context,
                                                'Logged Out Successfully');
                                          }
                                        } else {
                                          if (mounted) {
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                            // obtain shared preferences
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            // set value
                                            await prefs.remove('user');
                                            await prefs.remove('appKey');
                                            if (mounted) {
                                              Functions.ShowSnackBar(context,
                                                  'Something went wrong, please try again.');
                                            }
                                          }
                                        }
                                      } else {
                                        // obtain shared preferences
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        // set value
                                        await prefs.remove('user');
                                        await prefs.remove('appKey');
                                        if (mounted) {
                                          Functions.ShowSnackBar(context,
                                              'Logging out failed. No user found.');
                                        }
                                      }
                                    } catch (e) {
                                      // obtain shared preferences
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      // set value
                                      await prefs.remove('user');
                                      await prefs.remove('appKey');
                                      if (mounted) {
                                        Functions.ShowSnackBar(context,
                                            'Something went wrong, please try again.');
                                      }
                                    }
                                  },
                                  true,
                                  isHeader: true,
                                  isCloseBtn: true,
                                );
                              },
                              title: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: AppConst.appFontSizeh11,
                                ),
                              ),
                              leading: const Icon(
                                Icons.logout,
                              ),
                              textColor: AppConst.appColorText,
                              minLeadingWidth: 10.0,
                              iconColor: AppConst.appColorText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
