import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class StorageServices {
  // function untuk get image dari gallery
  // funtion static langsung dipakai tidak perlu pakai provider
  // Jika berhasil image akan di upload ke database dan mengembalikan downloadurl dari imagenya
  // Jika gagal akan tampil snackbar
  static Future getImage(BuildContext context) async {
    final picker = ImagePicker();
    var imageFile;
    PickedFile? pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      var result = await _uploadPostImage(imageFile);
      return result;
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak ada foto yang dipilih")),
      );
    }
  }

  // Function untuk upload image ke database
  // Jika berhasil image akan di upload ke database
  // Jika gagal akan tampil snackbar
  static Future<String> _uploadPostImage(File imageFile) async {
    String fileName = basename(imageFile.path);

    Reference ref = FirebaseStorage.instance.ref('books').child(fileName);
    UploadTask task = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await task;

    return await taskSnapshot.ref.getDownloadURL();
  }
}
