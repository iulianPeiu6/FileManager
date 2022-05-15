import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  final FileSystemEntity file;
  final void Function() onTap;
  final void Function() onDeleteFile;
  final void Function() onDetailsFile;
  final void Function() onRenameFile;

  const FileItem({
    Key? key,
    required this.onTap,
    required this.file,
    required this.onDeleteFile,
    required this.onDetailsFile,
    required this.onRenameFile
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  var fileOptions = [ _FileOption.open, _FileOption.details, _FileOption.rename, _FileOption.delete ];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (widget.file is File) ? 
        const Icon(IconData(0xe342, fontFamily: 'MaterialIcons')) : 
        const Icon(IconData(0xe2a3, fontFamily: 'MaterialIcons')),
      title: Text(basename(widget.file.path)),
      trailing: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              value: "Open",
              child: Text("Open")
            ),
            const PopupMenuItem(
              value: "Details",
              child: Text("Details")
            ),
            const PopupMenuItem(
              value: "Rename",
              child: Text("Rename")
            ),
            const PopupMenuItem(
              value: "Delete",
              child: Text("Delete")
            ),
          ];
        },
        onSelected: (selectedItem) {
          switch(selectedItem) { 
            case "Open": { 
              widget.onTap();
            } 
            break; 
            case "Details": { 
              widget.onDetailsFile();
            } 
            break; 
            case "Rename": { 
              widget.onRenameFile();
            } 
            break; 
            case "Delete": { 
              widget.onDeleteFile();
            } 
            break; 
          } 
        },
      ),
      subtitle: (widget.file is File) ? Text(_getFileDetails(widget.file)) : null,
      onTap: widget.onTap,
      onLongPress: widget.onDetailsFile,
    );
  }

  String _getFileDetails(FileSystemEntity file) {
    var stat = file.statSync();
    return "${stat.modeString()} | ${stat.size} bytes";
  }
}

class _FileOption {
  static String get open => "Open";
  static String get rename => "Rename";
  static String get delete => "Delete";
  static String get details => "Details";
}
