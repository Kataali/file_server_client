import 'package:file_server/pages/file_email.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../models/api_model.dart';
import '../models/file.dart';
import '../models/file_args.dart';
import '../providers/file.provider.dart';
import '../widgets/app_bar.dart';
import '../utils/snackbar.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> cols = [
      "Title",
      "Type",
      "Description",
      "Uploaded on",
      "Download",
      "Send as Email"
    ];
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<FileData>(context, listen: false);
    final String serverEndpoint = Api.filesEndpoint;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final String? keyword = args?["keyword"];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: MyAppBar(
          title: "Search result(s) for $keyword",
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: color.secondary,
            ),
          ),
        ),
        
      ),
      body: provider.searchedFilesLength != 0
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Consumer<FileData>(builder:
                            (BuildContext context, FileData value,
                                Widget? child) {
                          return FittedBox(
                            fit: BoxFit.contain,
                            child: DataTable(
                              headingTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: color.onPrimary),
                              columnSpacing: 20,
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
                                provider.searchedFilesLength,
                                (index) {
                                  File file =
                                      provider.getSearchedFileByIndex(index);
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
                                      IconButton(
                                        onPressed: () async {
                                          // print("Download ${file.path}");
                                          final String filePath = file.path;
                                          final String name = file.title;
                                          final String ext = file.type;
                                          final int fileId = file.id;
                                          try {
                                            if (await downloadFile(
                                                name,
                                                filePath,
                                                ext,
                                                serverEndpoint,
                                                fileId)) {
                                              if (context.mounted) {
                                                CustomSnackbar.show(
                                                  context,
                                                  "Download Finished",
                                                );
                                              }
                                            } else {
                                              if (context.mounted) {
                                                CustomSnackbar.show(
                                                  context,
                                                  "Could not download file Try Again",
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              CustomSnackbar.show(
                                                context,
                                                "Could not download file Try Again $e",
                                              );
                                            }
                                          }
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
                                            margin:
                                                const EdgeInsets.only(right: 7),
                                            child: const Icon(
                                                Icons.download_outlined)),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            FileEmailPage.routeName,
                                            arguments: FileArgs(
                                              path: file.path,
                                              title: file.title,
                                              fileId: file.id,
                                            ),
                                          );
                                          // print("Email  ${file.title}");
                                        },
                                        icon: Container(
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side:
                                                    const BorderSide(width: 1),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            margin:
                                                const EdgeInsets.only(right: 7),
                                            child: const Icon(
                                                Icons.email_outlined)),
                                      ),
                                    ),
                                  ]);
                                },
                              ),
                            ),
                          );
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_outlined,
                    size: 300,
                  ),
                  Text(
                    "No search Results could be found for $keyword",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: color.onSecondary),
                  ),
                ],
              ),
            ),
    );
  }

  Future<bool> downloadFile(
      filename, filePath, ext, serverEndpoint, fileId) async {
    try {
      final url = Uri.parse("$serverEndpoint/download/$filePath/$fileId");
      final response = await http.get(url);
      final blob = html.Blob([response.bodyBytes]);
      final anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString(),
      )..setAttribute('download', "$filename$ext");
      html.document.body!.children.add(anchorElement);
      anchorElement.click();
      html.document.body!.children.remove(anchorElement);
      print(response.bodyBytes.length);
      return true;
    } catch (e) {
      return false;
    }
  }
}
