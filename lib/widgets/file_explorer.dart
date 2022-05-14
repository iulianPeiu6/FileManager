import 'dart:io';
import 'package:filemanager/widgets/shared/file_item.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'file_details.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({Key? key, required this.title, required this.path}) : super(key: key);

  final String title;
  final String path;

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
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
                  onTap: () => _goToDirectory(context, basename(snapshot.data[index].path)),
                  onDeleteFile: _deleteFile,
                  onDetailsFile: () => _showFileDetails(context, snapshot.data[index].path)
                );
              },
            );
          }
          return const Center(child: Text("Loading"));
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var dir = await getExternalStorageDirectory();
          await Directory(join(dir?.path as String, widget.path, "newFolder4R")).create();
          setState(() {
            
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  Future<List<FileSystemEntity>> _files() async {
    var dir = Directory(widget.path);
    var files = dir.list().toList();
    return files;
  }

  _goToDirectory(BuildContext context, String directory) {
    var path = join(widget.path, directory);
    Navigator.of(context)
      .push(
        MaterialPageRoute(builder: (context) {
          return FileExplorer(title: widget.title, path: path);
        })
      );
  }

  _showFileDetails(BuildContext context, path) {
    Navigator.of(context)
      .push(
        MaterialPageRoute(builder: (context) {
          return FileDetails(title: path, path: path);
        })
      );
  }

  _deleteFile(FileSystemEntity file) {
    setState(() {
      file.deleteSync(recursive: true);
    });
  }
}