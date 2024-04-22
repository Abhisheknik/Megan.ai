import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageToVideoPage extends StatefulWidget {
  @override
  _ImageToVideoPageState createState() => _ImageToVideoPageState();
}

class _ImageToVideoPageState extends State<ImageToVideoPage> {
  String _generationStatus = '';
  bool _isLoading = false;
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> convertImageToVideo() async {
    if (_image == null) {
      setState(() {
        _generationStatus = "Please select an image first.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String generationID =
        "a6dc6c6e20acda010fe14d71f180658f2896ed9b4ec25aa99a6ff06c796987c4";
    print('Generation ID: $generationID');

    final String apiUrl =
        'https://api.stability.ai/v2beta/image-to-video/$generationID';

    final String apiKey = 'sk-KLnLrNU6IHYcK7LZXMTgMnEeP45XvcBZ1i6LbX1aF2AySQyd';

    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $apiKey',
        HttpHeaders.acceptHeader: 'video/*',
      },
    );

    if (response.statusCode == 202) {
      setState(() {
        _generationStatus =
            "Generation is still running, try again in 10 seconds.";
      });
    } else if (response.statusCode == 200) {
      setState(() {
        _generationStatus = "Generation is complete!";
      });
      await File('video.mp4').writeAsBytes(response.bodyBytes);
    } else {
      setState(() {
        _generationStatus =
            "Error: Response ${response.statusCode}: ${response.body}";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            _image != null ? Image.file(_image!) : Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _isLoading || _image == null ? null : convertImageToVideo,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Convert to Video'),
            ),
            SizedBox(height: 20),
            Text(_generationStatus),
          ],
        ),
      ),
    );
  }
}
