import 'package:flutter/material.dart';

class FileDetails extends StatefulWidget {
  const FileDetails({Key? key, required this.title, required this.path}) : super(key: key);

  final String title;
  final String path;

  @override
  State<FileDetails> createState() => _FileDetailsState();
}

class _FileDetailsState extends State<FileDetails> {
  @override
  Widget build(BuildContext context) {
    print ("in build details");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Text(widget.path)
    );
  }
}
