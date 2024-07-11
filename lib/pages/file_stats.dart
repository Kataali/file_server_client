import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/models/api_model.dart';
import 'package:file_server/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/file_stat.dart';
import '../utils/snackbar.dart';
import '../widgets/app_bar.dart';

class FileStatsPage extends StatefulWidget {
  static const routeName = '/file-stats';
  const FileStatsPage({super.key});

  @override
  State<FileStatsPage> createState() => _FileStatsPageState();
}

class _FileStatsPageState extends State<FileStatsPage> {
  List<String> cols = [
    "Title",
    "Type",
    "Description",
    "Uploaded on",
    "Download \nCount",
    "Email \nCount",
    "Delete \nFile"
  ];
  final serverEndPoint = Api.fileStatsEndpoint;
  final filesEndPoint = Api.filesEndpoint;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: MyAppBar(
          title: "File Statistics",
          leading: SizedBox(),
        ),
      ),
      body: BlurryModalProgressHUD(
        inAsyncCall: isLoading,
        dismissible: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                          future: getFileStats(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.multiline_chart_outlined,
                                        size: 300,
                                      ),
                                      Text(
                                        "OOps!! No Uploads Yet",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: color.onSecondary),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return FittedBox(
                                child: DataTable(
                                  headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: color.onPrimary),
                                  headingRowColor:
                                      WidgetStateProperty.all(color.primary),
                                  dataTextStyle:
                                      TextStyle(color: color.secondary),
                                  columns: List.generate(
                                    cols.length,
                                    (index) => DataColumn(
                                      label: Text(
                                        cols[index],
                                      ),
                                    ),
                                  ),
                                  rows: List.generate(
                                    snapshot.data!.length,
                                    (index) {
                                      final file = snapshot.data![index];
                                      return DataRow(cells: <DataCell>[
                                        DataCell(
                                          Text(file.title),
                                        ),
                                        DataCell(
                                          Text(file.type),
                                        ),
                                        DataCell(
                                          Text(file.description),
                                        ),
                                        DataCell(
                                          Text(file.uploadedOn),
                                        ),
                                        DataCell(
                                          Text('${file.downloadCount}'),
                                        ),
                                        DataCell(
                                          Text('${file.emailCount}'),
                                        ),
                                        DataCell(
                                          IconButton(
                                            onPressed: () {
                                              CustomDialog.showPopUp(
                                                context,
                                                "DELETE FILE",
                                                "Are you sure you want to delete ${file.title}?",
                                                "Yes",
                                                "No",
                                                () async {
                                                  try {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    if (await deleteFile(
                                                        file.id)) {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        CustomSnackbar.show(
                                                            context,
                                                            "File Successfully Deleted");
                                                      }
                                                    } else {
                                                      if (context.mounted) {
                                                        CustomSnackbar.show(
                                                            context,
                                                            "Error Deleting File");
                                                      }
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      CustomSnackbar.show(
                                                          context,
                                                          "Error deleting File");
                                                    }
                                                  }
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                            icon: Container(
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: const BorderSide(
                                                      width: 0.5),
                                                ),
                                                // color: color.tertiary,
                                              ),
                                              padding: const EdgeInsets.all(3),
                                              margin: const EdgeInsets.only(
                                                  right: 7),
                                              child: const Icon(Icons
                                                  .delete_forever_outlined),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    },
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<FileStat>> getFileStats() async {
    List<FileStat> interimFiles = [];
    final res = await http.get(
      Uri.parse("$serverEndPoint/all"),
    );

    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      // print(resData);
      resData.forEach((i) {
        FileStat fileStat = FileStat.fromJson(i);
        // print(fileStat);
        interimFiles.add(fileStat);
      });
      // print(interimFiles);
      return interimFiles;
    } else {
      throw Exception("Unable to get Files");
    }
  }

  // Delete File
  Future<bool> deleteFile(fileId) async {
    final response =
        await http.delete(Uri.parse("$filesEndPoint/delete/$fileId"));
    // print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }
}
