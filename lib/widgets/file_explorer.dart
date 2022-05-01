import 'dart:io';
import 'package:filemanager/widgets/shared/file_item.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  String currentRelativePath = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _files(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return FileItem(
                  file: snapshot.data[index],
                  onTap: () => _goToDirectory(basename(snapshot.data[index].path)),
                  onDeleteFile: _deleteFile
                );
              },
            );
          }
          return const Center(child: Text("Loading"));
        }
      ),
    );
  }

  Future<List<FileSystemEntity>> _files() async {
    var dir = await getExternalStorageDirectory();
    dir = Directory(join(dir?.path as String, currentRelativePath));
    var files = dir.list().toList();
    return files;
  }

  _goToDirectory(String directory) {
    setState(() { 
      currentRelativePath = join(currentRelativePath, directory);
    });
  }

  _deleteFile(FileSystemEntity file) {
    setState(() {
      file.deleteSync();
    });
  }
}