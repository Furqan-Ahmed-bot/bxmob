import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  final id;
  List notification = [];
   Demo({Key? key , this.id , required this.notification}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ListView.builder(
              itemCount: widget.notification.length,
              itemBuilder: ((context, index) {
              return Container(
                child : Text('Hello'),
              );
              
            })),
            Container(
              child: Text('Hello' + widget.id),
            ),
          ],
        ),
      ),
    );
    
  }
}