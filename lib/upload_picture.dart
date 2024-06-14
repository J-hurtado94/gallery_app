import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<void> uploadImage(File selectedImage) async {
  try {
    final String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference ref = storage.ref().child('images/$imageName.png');
    final UploadTask uploadTask = ref.putFile(selectedImage);
    await uploadTask;
    print('Image uploaded to Firebase Storage.');
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
  }
}
