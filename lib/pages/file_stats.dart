import 'dart:convert';

import 'package:file_server/models/api_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/file_stat.dart';
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
    "Email \nCount"
  ];
  final serverEndPoint = Api.fileStatsEndpoint;

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                                        fontSize: 18, color: color.onSecondary),
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
                              dataTextStyle: TextStyle(color: color.secondary),
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
}
