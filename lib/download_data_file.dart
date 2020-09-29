import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;


class MyApp2 extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}
class MyAppState extends State<MyApp2> {
  final imgUrl1 =
      "https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg";
  final imgUrl =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    super.initState();

    downloadFile();
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print(directory.path);
    return directory.path;
  }
Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getExternalStorageDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

 Future<void> downloadFile() async {
   Dio dio = Dio();
    var dir = await getExternalStorageDirectory();

    try {
      print("path ${dir.path}");
      await dio.download(imgUrl, "${dir.path}/file1/demo.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Downloading File: $progressString",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _localPath;
                      },
                      child: Text("Get file path"),
                    ),
                    Text("Check Data your app files"),
                  ],
                )
                ),
    );
  }
}
