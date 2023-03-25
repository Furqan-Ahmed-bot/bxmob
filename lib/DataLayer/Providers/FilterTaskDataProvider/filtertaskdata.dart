import 'package:flutter/material.dart';

class FilterTasksData with ChangeNotifier {
  String? _toDate;
  String? _fromDate;
  List<dynamic> _filterData = [];

  String? get selectedStartDate => _toDate;
  String? get selectedEndDate => _fromDate;
  List<dynamic> get getfilterData => _filterData;

  void setFilter(startdate, enddate, filterData) async {
    _toDate = startdate;
    _fromDate = enddate;
    _filterData = await filterData;
    notifyListeners();
  }
}
