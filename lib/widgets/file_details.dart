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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        childAspectRatio: 3,
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
            height: 100,
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
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(lastAccessed),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text('Last time modified:'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(lastModified),
          )
        ]
      )
    );
  }
}
