import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ImagesProvider with ChangeNotifier {
  final String _imageUrl = '';
  dynamic get getImageUrl => _imageUrl;

  selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }
    return result.files.first;
  }

  Future<String> uploadFile(PlatformFile? pickedFile) async {
    final path = 'images/${DateTime.now()}_${pickedFile!.name}';
    final file = File(pickedFile.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    log(urlDownload);
    return urlDownload;
  }
}
