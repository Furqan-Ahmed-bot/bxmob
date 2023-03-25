// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, camel_case_types, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:ts_app_development/Generic/appConst.dart';
import 'package:ts_app_development/OrderTicket/BottomBarItems/home.dart';
import 'package:ts_app_development/OrderTicket/supportTicket.dart';

import 'BottomBarItems/myOpenTickets.dart';

class myTicket extends StatefulWidget {
  bool? isSupportMenu;
  final idx;
  myTicket({Key? key, this.idx, this.isSupportMenu}) : super(key: key);

  @override
  State<myTicket> createState() => _myTicketState();
}

class _myTicketState extends State<myTicket> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.idx != null? _selectedIndex = widget.idx : _selectedIndex;
    List<Widget> _widgetOptions = <Widget>[
      Home(
        isSupportMenu: widget.isSupportMenu,
      ),
      // Text(
      //   'Index 1: New',
      //   style: optionStyle,
      // ),
      Ticket(
        isSupportMenu: widget.isSupportMenu,
      ),

      OpenTicket(
          ActivityStatusId: '',
          PriorityId: '',
          TaskTypeId: '',
          ActvityStatus: '',
          isSupportMenu: widget.isSupportMenu),
    ];
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Last 7 Days complain'),
      // ),

      bottomNavigationBar: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              // backgroundColor: Colors.white,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppConst.appColorPrimary,
          //  Color(0xFFb54f40),
          onTap: _onItemTapped,
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
