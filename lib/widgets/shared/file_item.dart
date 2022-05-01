import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileItem extends StatefulWidget {
  final FileSystemEntity file;
  final void Function()? onTap;
  final void Function(FileSystemEntity) onDeleteFile;

  const FileItem({
    Key? key,
    this.onTap,
    required this.file,
    required this.onDeleteFile
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
        icon: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) {
          return [ _FileOption.rename, _FileOption.delete ].map((String option) {
            return PopupMenuItem(
              value: option,
              child: Text(option),
              onTap: () => _handleFileOption(option)
            );
          }).toList();
        },
      ),
      subtitle: Text(_getFileDetails(widget.file)),
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
  }

  _renameFile(FileSystemEntity file) {
    setState(() {
      
    });
  }
}

class _FileOption {
  static String get rename => "Rename";
  static String get delete => "Delete";
}
