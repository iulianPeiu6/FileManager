import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileDetails extends StatefulWidget {
  const FileDetails({Key? key, required this.title, required this.file}) : super(key: key);

  final String title;
  final FileSystemEntity file;

  @override
  State<FileDetails> createState() => _FileDetailsState();
}

class _FileDetailsState extends State<FileDetails> {
  @override
  Widget build(BuildContext context) {
    var file = widget.file;
    var fileStats = file.statSync();
    var fileType = fileStats.type.toString();
    var fileSize = fileStats.size.toString();
    var lastAccessed = fileStats.accessed.toString();
    var lastModified = fileStats.modified.toString();
    var mode = fileStats.modeString();

    return AlertDialog(
      content: Container(
        width: 600,
        child: GridView.count(
          primary: false,
          childAspectRatio: 2.5,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text("File name:"),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(basename(file.path)),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Type:'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(fileType),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Mode:'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(mode),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Size:'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text("$fileSize bytes"),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Last time accessed:'),
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(lastAccessed),
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Last time modified:'),
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(lastModified),
              height: 200,
            )
          ]
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ok')
        )
      ],
    );
  }
}
