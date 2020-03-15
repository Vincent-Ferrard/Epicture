import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class MyUpload extends StatefulWidget {
  @override
  MyUploadState createState() => MyUploadState();
}

class MyUploadState extends State<MyUpload> {
  File _image;
  String _title;
  String _description;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
        actions: _image == null ? <Widget>[] : <Widget>[
          IconButton(icon: Icon(Icons.send), onPressed: () {upload(context);}),
        ],
      ),
      body: _image == null ? AlertDialog(
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              GestureDetector(
                child: new Text('Take a picture'),
                onTap: getImage,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              GestureDetector(
                child: new Text('Select from gallery'),
                onTap: getImageFromGallery,
              ),
            ],
          ),
        ),
      ) : Center(
          child: ListView(
              padding: const EdgeInsets.all(30.0),
              children: <Widget>[
                Image.file(_image, width: 360.0, height: 360.0),
                Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter a title'
                    ),
                    onChanged: (text) {
                      _title = text;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter a description'
                    ),
                    onChanged: (text) {
                      _description = text;
                    },
                  ),
                ),
              ]
          )
      ),
    );
  }

  void upload(BuildContext context) async {
    final response =
    await http.post('https://api.imgur.com/3/upload',
      headers: {"Authorization": "Bearer ${User.accessToken}"},
      body: {"image": base64Encode(_image.readAsBytesSync()),
        "name": _image.path.split("/").last,
        "title": _title,
        "description": _description,
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      throw Exception('Failed to load post');
    }
  }
}