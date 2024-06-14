import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImageListPage extends StatelessWidget {
  final List<String> imageNames;

  const ImageListPage({super.key, required this.imageNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Text(
            'Lista de Imágenes',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          )),
      body: ListView.builder(
        itemCount: imageNames.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(imageNames[index],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () {
                downloadSingleImage(context, imageNames[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void downloadSingleImage(BuildContext context, String imageName) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('images/$imageName');

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/$imageName';
      File file = File(filePath);

      await storageRef.writeToFile(file);
      final result = await ImageGallerySaver.saveFile(filePath);

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Imagen descargada y guardada en la galería: $imageName')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al guardar la imagen en la galería')),
        );
      }
    } catch (e) {
      print('Error al descargar la imagen $imageName: $e');
    }
  }
}
