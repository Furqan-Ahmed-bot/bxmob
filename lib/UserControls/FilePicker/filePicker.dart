// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';

class PickFiles {
  pickfile(files) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    //  Uint8List  bytes = await  files![0].readAsBytesSync();fggfeg
    if (result != null) {
      if (files != null) {
        for (var i = 0; i < result.files.length; i++) {
          files.add(<String, dynamic>{
            'name': result.files[i].name,
            'path': result.files[i].path
          });
        }
      } else {
        files = result.files;
      }

      // pickedfile = result.files.first;
      print('Length  ${files.length}');
      return files;
    }
  }
}
