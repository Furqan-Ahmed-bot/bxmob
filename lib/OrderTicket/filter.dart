// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:isolate';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/Generic/appConst.dart';

import '../DataLayer/Providers/FilterTaskDataProvider/filtertaskdata.dart';
import '../DataLayer/Providers/FiltersProvider/filterProviders.dart';
import 'BottomBarItems/home.dart';
import 'searchList.dart';

final today = DateUtils.dateOnly(DateTime.now());

class Filters extends StatefulWidget {
  final Caller;
  bool? isSupportMenu;
  Filters({super.key, required this.Caller, this.isSupportMenu});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List filterData = [];
  var startDate;
  var endDate;
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
    DateTime.now(),
  ];
  dynamic IsSelected;
  @override
  void initState() {
    super.initState();
    getFiltersData();
  }

  List reportFilterType = [
    {'filterName': 'EmployeeName', 'Designation': 'Designation'},
    {'filterName': 'EmployeeName', 'Designation': 'Designation'},
    {'filterName': 'EmployeeName', 'Designation': 'Designation'},
    {'filterName': 'EmployeeName', 'Designation': 'Designation'},
    {'filterName': 'Client', 'Designation': 'IsDebtor'},
    {'filterName': 'Name', 'Designation': 'FormIcon'},
    {'filterName': 'EmployeeName', 'Designation': 'Designation'},
    // {'filterName': 'EmployeeName', 'Designation': 'Designation'},
  ];

  void getFiltersData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? '';
    final appKey = prefs.getString('appKey') ?? '';
    Map<String, dynamic> userMap = jsonDecode(user);
    String url =
        '${prefs.getString('ApiUrl')}/TSBE/Reports/GetFilterComponents/1/1107/0';

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
        "Content-type": 'application/json'
      },
    );
    setState(() {
      // _isLoading = true;
    });
    if (response.statusCode == 200) {
      var res = response.body;
      dynamic data = json.decode(res);
      // TaskScheduler = data;
      filterData = data;
      print('fdata is ${filterData}');

      setState(() {
        // _isLoading = false;
      });
    } else {
      print(response.statusCode);
      print('Err');
      setState(() {
        // _isLoading = false;
      });
    }
  }

  void getIsSelectedData() async {
    dynamic getIsSelectedData;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    getIsSelectedData = pref.get('selectedData');
    print('Get is Selected Data is ${getIsSelectedData}');
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        startDate = values[0].toString().replaceAll('00:00:00.000', '');
        endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  List filter = [];

  void filteration(parameter, value) {
    filter.add(<String, dynamic>{"Parameter": parameter, "Value": value});

    print('FilterList ${filter}');
  }

  void setDateToProvider() {
    FilterTasksData().setFilter(startDate, endDate, filter);
  }

  @override
  Widget build(BuildContext context) {
    FilterTasksData filterProvider = Provider.of<FilterTasksData>(context);

    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );

    final config = CalendarDatePicker2WithActionButtonsConfig(
        dayTextStyle: dayTextStyle,
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: AppConst.appColorPrimary,
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        // controlsTextStyle: const TextStyle(
        //   color: Colors.black,
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        // ),
        selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
        dayTextStylePredicate: ({required date}) {
          TextStyle? textStyle;
          if (date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday) {
            textStyle = weekendTextStyle;
          }
          if (DateUtils.isSameDay(date, DateTime(2023, 1, 25))) {
            textStyle = anniversaryTextStyle;
          }
          return textStyle;
        },
        dayBuilder: ({
          required date,
          textStyle,
          decoration,
          isSelected,
          isDisabled,
          isToday,
        }) {
          Widget? dayWidget;
          if (date.day % 3 == 0 && date.day % 9 != 0) {
            dayWidget = Container(
              decoration: decoration,
              child: Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text(
                      MaterialLocalizations.of(context).formatDecimal(date.day),
                      style: textStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 27.5),
                      child: Container(
                        height: 4,
                        width: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isSelected == true
                              ? Colors.white
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return dayWidget;
        });
    print(reportFilterType[1]['filterName']);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(0),
                initialValue: _dialogCalendarPickerValue,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                setState(() {
                  _dialogCalendarPickerValue = values;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                  width: 0.8,
                )),
                child: startDate == null
                    ? Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Pick Date Range',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(Icons.calendar_month,
                                color: Colors.grey[700]),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'From : ${startDate}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('To : ${endDate}',
                              style: TextStyle(color: Colors.grey[700]))
                        ],
                      ),
              ),
            ),
          ),
          Container(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: filterData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filterData[index]['SoftwareComponentId'] == 154
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(
                                '${filterData[index]['DisplayName']} :',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                        child: filterData[index]['SoftwareComponentId'] == 154
                            ? Container()
                            : filterData[index]['SoftwareComponentId'] == 157
                                ? Container(
                                    height: 50,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: filterData[index]
                                            ['DisplayName'],
                                        hintStyle: TextStyle(fontSize: 14),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero),
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                      ),
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    // width: 350,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child:
                                                //  clientName == null
                                                //     ?
                                                Container(
                                              width: 150,
                                              child: Text(
                                                filterData[index][
                                                                'SelectedValue'] ==
                                                            null ||
                                                        filterData[index][
                                                                'SelectedValue']
                                                            .isEmpty
                                                    ? filterData[index]
                                                        ['DisplayName']
                                                    : filterData[index]
                                                        ['SelectedValue'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                            // : Text(
                                            //     clientName,
                                            //     style: TextStyle(color: Colors.black),
                                            //   )
                                            ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () async {
                                            // start the SecondScreen and wait for it to finish with a result
                                            final selectedValues =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => LOV(
                                                        SpType: filterData[
                                                                index][
                                                            'ReportFilterType'],
                                                        fields: [
                                                          'Name',
                                                          'ShortName'
                                                        ],
                                                        primaryField: 'Id',
                                                        hintText:
                                                            'Search Clients',
                                                        MultiSelection: filterData[
                                                                        index][
                                                                    'MultipleSelection'] ==
                                                                1
                                                            ? true
                                                            : false,
                                                      ),
                                                    ));
                                            // after the SecondScreen result comes back update the Text widget with it
                                            setState(() {
                                              List myList = [];
                                              //List isSelected = result;
                                              filterData[index]
                                                      ['SelectedValue'] =
                                                  selectedValues
                                                      .map((i) => i.toString())
                                                      .join(",");

                                              print('MyList ${myList}');
                                              // IsSelected = filterData[index];
                                              //filterData[index].add(isSelected);
                                              // String result = utf8.decode(selectedValues);

                                              filteration(
                                                  filterData[index]
                                                      ['Parameter'],
                                                  filterData[index]
                                                      ['SelectedValue']);

                                              print(
                                                  'List is ${filterData[index]['SelectedValue']}');
                                              //print(filterData);

                                              //print('Index 1 ${isSelected[0]}');
                                              //print('Index 1 ${isSelected[1].toString()}');
                                              //print(isSelected.length);
                                              // isSelected = json.encode(mylist);
                                              // final SharedPreferences pref =
                                              //     await SharedPreferences.getInstance();
                                              // pref.setString('selectedData', isSelected);
                                              // print('IsSelected ${isSelected}');
                                              // getIsSelectedData();
                                            });

                                            // Future<void> future = showModalBottomSheet(
                                            //     isScrollControlled: true,
                                            //     context: context,
                                            //     builder: (BuildContext context) {
                                            //       //  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                                            //       return LOV(
                                            //         SpType: filterData[index]
                                            //             ['ReportFilterType'],
                                            //         fields: [
                                            //           reportFilterType[index]['filterName'],
                                            //           reportFilterType[index]['Designation']
                                            //         ],
                                            //         primaryField: 'Id',
                                            //         hintText: 'Search Clients',
                                            //         MultiSelection: filterData[index]
                                            //                     ['ShortName'] ==
                                            //                 'Multi'
                                            //             ? true
                                            //             : false,
                                            //       );
                                            //     });
                                            //future.then((void value) => getClientData());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Icon(
                                              Icons.list,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  filterData[index]
                                                      ['SelectedValue'] = '';
                                                });
                                                print('Hello');
                                                print(filterData[index]
                                                    ['SelectedValue']);
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.grey[600],
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                      ),
                    ],
                  );
                }),
          ),
          Container(
            width: 100,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppConst.appColorPrimary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    )),
                onPressed: () {
                  filter.add(<String, dynamic>{
                    "StartDate": startDate,
                    "EndDate": endDate
                  });
                  filterProvider.setFilter(startDate, endDate, filter);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => widget.Caller));
                  //vaildation();
                  // _sendDataBack(context);
                },
                child: Text('Get Data')),
          ),
        ],
      ),
    );
  }
}
