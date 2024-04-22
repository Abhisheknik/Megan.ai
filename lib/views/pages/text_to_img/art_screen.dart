import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ArtScreen extends StatefulWidget {
  const ArtScreen({Key? key}) : super(key: key);

  @override
  State<ArtScreen> createState() => _ArtScreenState();
}

class _ArtScreenState extends State<ArtScreen> {
  List<FileSystemEntity> imgList = [];

  Future<void> getImages() async {
    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final directory = Directory("/storage/emulated/0/Pictures/");
    List<FileSystemEntity> list = directory.listSync();
    setState(() {
      imgList = list.whereType<File>().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Art Gallery",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8, // Adjust this value to change horizontal spacing
          mainAxisSpacing: 8, // Adjust this value to change vertical spacing
        ),
        padding: EdgeInsets.all(8), // Add padding to the GridView
        itemCount: imgList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.file(
              File(imgList[index].path),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
