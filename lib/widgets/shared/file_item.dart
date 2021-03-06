import 'dart:io';
import 'package:filemanager/widgets/file_explorer.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  final FileSystemEntity file;
  final void Function() onOpen;
  final void Function() onDeleteFile;
  final void Function() onDetailsFile;
  final void Function() onRenameFile;
  final void Function(bool cutFile) onCopyFile;
  final void Function() onPasteFile;

  const FileItem({
    Key? key,
    required this.onOpen,
    required this.file,
    required this.onDeleteFile,
    required this.onDetailsFile,
    required this.onRenameFile,
    required this.onCopyFile,
    required this.onPasteFile,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
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
              value: "Copy",
              child: Text("Copy")
            ),
            const PopupMenuItem(
              value: "Cut",
              child: Text("Cut")
            ),
            PopupMenuItem(
              value: "Paste",
              child: const Text("Paste"),
              enabled: FileExplorer.copiedFile == null || widget.file is File ? false : true,
            ),
            const PopupMenuItem(
              value: "Delete",
              child: Text("Delete")
            ),
            const PopupMenuItem(
              value: "Rename",
              child: Text("Rename")
            ),
          ];
        },
        onSelected: (selectedItem) {
          switch(selectedItem) { 
            case "Open": { 
              widget.onOpen();
            } 
            break; 
            case "Details": { 
              widget.onDetailsFile();
            } 
            break; 
            case "Copy": { 
              widget.onCopyFile(false);
            } 
            break; 
            case "Cut": { 
              widget.onCopyFile(true);
            } 
            break;
            case "Paste": { 
              widget.onPasteFile();
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
      onTap: widget.onOpen,
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
