// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String picturepath = '';
  String? videopath;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      child: FlutterCamera(
        color: Colors.amber,
        onImageCaptured: (value) {
          picturepath = value.path;
          print("::::::::::::::::::::::::::::::::: Picture $picturepath");
          if (picturepath.contains('.jpg')) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Image.file(File(picturepath)),
                  );
                });
          }
          setState(() {
            setpictureaData(picturepath);
          });
        },
        onVideoRecorded: (value) {
          videopath = value.path;
          print('::::::::::::::::::::::::;; Video $videopath');

          setState(() {
            setCameraData(videopath);
          });
        },
      ),
    );

    // return Container();
  }

  Future<void> setCameraData(videopath) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('videopath', videopath);
    print(videopath);
  }

  Future<void> setpictureaData(picturepath) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('picturepath', picturepath);
    print(picturepath);
  }
}
