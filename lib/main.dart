import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/firebase_options.dart';
import 'package:gallery_app/image_list_page.dart';
import 'package:gallery_app/upload_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  File? _selectedImage;
  final List<File> _images = [];

  int? _selectedIndex;
  List<String> imageNames = [];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _images.add(_selectedImage!);
      });
    }
  }

  Future<void> _takeApicture(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _images.add(_selectedImage!);
      });
    }
  }

  Future<void> _editImage(File image) async {
    final Uint8List? editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(image: image),
      ),
    );

    if (editedImage != null) {
      final editedImageFile = await _saveEditedImage(editedImage, image.path);
      setState(() {
        int index = _images.indexOf(image);
        _images[index] = editedImageFile;
      });
    }
  }

  Future<File> _saveEditedImage(
      Uint8List imageBytes, String originalPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final editedImagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    final editedImageFile = File(editedImagePath);
    await editedImageFile.writeAsBytes(imageBytes);
    return editedImageFile;
  }

  Widget _buildImageGrid() {
    return GridView.count(
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      crossAxisCount: 3,
      padding: const EdgeInsets.all(0),
      children: _images.asMap().entries.map((entry) {
        final index = entry.key;
        final image = entry.value;
        return GestureDetector(
          onDoubleTap: () => _editImage(image),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Stack(
            children: [
              Image.file(image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity),
              if (_selectedIndex == index)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _shareImage(File image) {
    Share.shareXFiles([XFile(image.path)], text: 'Compartir imagen');
  }

  Future<void> downloadImage(BuildContext context) async {
    final storageRef = FirebaseStorage.instance.ref();

    final allImages = storageRef.child("images/");

    try {
      final ListResult result = await allImages.listAll();
      imageNames.clear();
      for (final Reference ref in result.items) {
        imageNames.add(ref.name);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageListPage(imageNames: imageNames),
        ),
      );
    } catch (e) {
      print('error en la descarga $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Gallery App',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildImageGrid()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
            onPressed: () => _pickImage(ImageSource.gallery),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.photo_size_select_actual),
                SizedBox(width: 8),
                Text('Seleccionar imagen'),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
            onPressed: () => _takeApicture(ImageSource.camera),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.camera),
                SizedBox(width: 8),
                Text(
                  'Tomar foto',
                ),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              onPressed: _selectedIndex != null
                  ? () async {
                      await uploadImage(_images[_selectedIndex!]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Imagen subida correctamente"),
                        ),
                      );
                    }
                  : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload),
                  SizedBox(width: 8),
                  Text('Subir imagen'),
                ],
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
            onPressed: _selectedIndex != null
                ? () => _shareImage(_images[_selectedIndex!])
                : null,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.share),
                SizedBox(width: 8),
                Text('Compartir imagen'),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white),
            onPressed: () {
              downloadImage(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.cloud_download),
                SizedBox(width: 8),
                Text('Descargar imagen'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
