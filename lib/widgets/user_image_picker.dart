import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class USerImagePicker extends StatefulWidget {
  final Function(File image) pickedImage;

  const USerImagePicker(this.pickedImage);
  @override
  _USerImagePickerState createState() => _USerImagePickerState();
}

class _USerImagePickerState extends State<USerImagePicker> {
  File _pickedImage;

  void getImage() async {
    final _imagePicker = ImagePicker();
    final imagePicked = await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 75, maxHeight: 200);
    setState(() {
      if (imagePicked != null) {
        _pickedImage = File(imagePicked.path);
      }
    });
    widget.pickedImage(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: _pickedImage == null
              ? Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                )
              : null,
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage.path)) : null,
        ),
        FlatButton.icon(
          onPressed: getImage,
          icon: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
          label: Text(
            'Add Photo',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
