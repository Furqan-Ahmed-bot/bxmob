// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GetX/cartController.dart';

class CartTotal extends StatefulWidget {

   CartTotal({Key? key}) : super(key: key);
   
  @override
  State<CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<CartTotal> {
  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find();
   
    return Obx(() => 
       Container(
        child: Row(children: [
          // if(controller.total.length == 0)...[
          //   Text('')
          // ],
          // if(controller.total.length > 1)...[
          //   Text('Total ${controller.total}'),
           

          // ]       
     
             Text('Total: ${controller.total.toString()}' , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),

          //  Text('Total sun ${controller.productSubtotal}')
        ]),
      ),
    );

    
  }
}