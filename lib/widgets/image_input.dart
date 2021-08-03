import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'
    as syspaths; //This package is giving us path on the device where we can store files
import 'package:path/path.dart' as pth;

class ImageInput extends StatefulWidget {
  final Function onSelectedImage;

  ImageInput(this.onSelectedImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  final _picker = ImagePicker();

  Future<void> _takePicture() async {
    final imageFile =
        await _picker.getImage(source: ImageSource.camera, maxWidth: 600);
    final pickedImageFile = imageFile!.path;
    if (pickedImageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(pickedImageFile);
    });
    //This is giving us directory where we can store our files
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    //Using path package to get path from picked image
    final fileName = pth.basename(pickedImageFile);

    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onSelectedImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No image taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
