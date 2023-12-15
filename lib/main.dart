import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _saveImage() async {
    if (_image != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final savedImage = await _image!.copy('${directory.path}/saved_image.png');

        // Save to gallery
        await GallerySaver.saveImage(savedImage.path);

        print('Image saved at: ${savedImage.path}');
      } catch (e) {
        print('Error saving image: $e');
      }
    } else {
      print('No image to save.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image sauvegarde'),
        backgroundColor: Colors.deepPurple, // Change app bar color
      ),
      body: Center(
        child: _image == null
            ? Text(
                'No image selected.',
                style: TextStyle(color: Colors.black),
              )
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.deepPurple, // Change FAB color
      ),
    );
  }
}
