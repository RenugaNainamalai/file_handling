import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';



class MyApp1 extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<MyApp1> {

Future<void> _getPDF() async {
    var document = PdfDocument();
    document.pages.add().graphics.drawString(
        "Welcome to PDF page", PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 30));
    var bytes = document.save();
    document.dispose();
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    File file = File('$path/text/Output.pdf');
    await file.writeAsBytes(bytes, flush: true);
    // await file.copy('$path/texts');
    OpenFile.open('$path/Output.pdf');
  }
Future<void> _deletePDF() async {
    Directory directory = await getExternalStorageDirectory();
    var document = PdfDocument();
    document.pages.add().graphics.drawString(
        "Hello World", PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 30));
    var bytes = document.save();
    document.dispose();
    String path = directory.path;
    final dir = Directory('$path/text/Output.pdf');
    dir.deleteSync(recursive: true);

    File file = File('$path/texts/Output.pdf');
    await file.writeAsBytes(bytes, flush: true);
    // await file.copy('$path/texts');
    OpenFile.open('$path/Output.pdf');
  }
  String data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File handling PDF"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text(
                'Generate PDF',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: _getPDF,
            ),
            FlatButton(
                onPressed: () {
                  _deletePDF();
                },
                child: Text("Move to File"))
          ],
        ),
      ),
    );
  }
}