import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  final FileSystemEntity file;
  final void Function()? onTap;
  final void Function(FileSystemEntity) onDeleteFile;
  final void Function()? onDetailsFile;

  const FileItem({
    Key? key,
    this.onTap,
    required this.file,
    required this.onDeleteFile,
    required this.onDetailsFile
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
          return fileOptions.map((String option) {
            return PopupMenuItem(
              value: option,
              child: Text(option),
              onTap: () => _handleFileOption(option)
            );
          }).toList();
        },
      ),
      subtitle: (widget.file is File) ? Text(_getFileDetails(widget.file)) : null,
      onTap: widget.onTap
    );
  }

  String _getFileDetails(FileSystemEntity file) {
    var stat = file.statSync();
    return "${stat.modeString()} | ${stat.size} bytes";
  }

  _handleFileOption(String option) {
    if (option == _FileOption.rename) {
      _renameFile(widget.file);
    }
    else if (option == _FileOption.delete) {
      widget.onDeleteFile(widget.file);
    }
    else if (option == _FileOption.open) {
      widget.onTap;
    }
    else if (option == _FileOption.details) {
      widget.onDetailsFile;
    }
  }

  _renameFile(FileSystemEntity file) {
    setState(() {
      
    });
  }
}

class _FileOption {
  static String get open => "Open";
  static String get rename => "Rename";
  static String get delete => "Delete";
  static String get details => "Details";
}
