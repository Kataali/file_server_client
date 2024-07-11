import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/file_email.dart';
import 'package:file_server/pages/search.dart';
import 'package:file_server/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../models/api_model.dart';
import '../models/file.dart';
import '../models/file_args.dart';
import '../providers/file.provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_textfield.dart';

class HomePageView extends StatefulWidget {
  static const routeName = '/home';
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<String> cols = [
    "Title",
    "Type",
    "Description",
    "Uploaded on",
    "Download",
    "Send as Email"
  ];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final String serverEndpoint = Api.filesEndpoint;
  late List<File> files;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<FileData>(context, listen: false);

    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      dismissible: false,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: MyAppBar(
            title: "Library",
            leading: SizedBox(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      SizedBox(
                        // height: 35,
                        width: 200,
                        child: CustomTextField(
                          prefixIcon: const Icon(Icons.search_outlined),
                          hintText: "Search for File",
                          controller: searchController,
                        ),
                      ),
                      const VerticalDivider(
                        width: 15,
                        thickness: .001,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final keyword = searchController.value.text.trim();
                          if (!_formKey.currentState!.validate()) {
                            return;
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              files = await search(keyword);
                              provider.emptysearchedList();
                              provider.mergeWithSearchedFilesList(files);
                              if (context.mounted) {
                                Navigator.pushNamed(
                                    context, SearchPage.routeName,
                                    arguments: {"keyword": keyword});
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(
                                    context, "Error searching for file");
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          "Search",
                          style: TextStyle(color: color.onPrimary),
                        ),
                      ),
                      const VerticalDivider(
                        width: 10,
                        thickness: .001,
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            files = await getFiles();
                            
                            provider.emptyVitalsList();
                            provider.mergeWithFilesList(files);
                          } catch (e) {
                            if (context.mounted) {
                              CustomSnackbar.show(context, "$e");
                              // Navigator.pop(context);
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: color.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        // icon: Text(
                        //   "Get Files",
                        //   style: TextStyle(color: color.onPrimary),
                        // ),
                        icon: Icon(
                          Icons.refresh_outlined,
                          color: color.primary,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: .001,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                          future: getFiles(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.file_upload_off,
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
                                  // columnSpacing: 1,
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
                                                    filePath, ext, fileId)) {
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
                                                        BorderRadius.circular(
                                                            5),
                                                    side: const BorderSide(
                                                        width: 0.5),
                                                  ),
                                                  // color: color.tertiary,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(3),
                                                margin: const EdgeInsets.only(
                                                    right: 7),
                                                child: const Icon(
                                                    Icons.download_outlined),),
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
                                                    fileId: file.id),
                                              );
                                              // print("Email  ${file.title}");
                                            },
                                            icon: Container(
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    side: const BorderSide(
                                                        width: 1),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(3),
                                                margin: const EdgeInsets.only(
                                                    right: 7),
                                                child: const Icon(
                                                    Icons.email_outlined)),
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

  Future<List<File>> getFiles() async {
    List<File> interimFiles = [];
    final res = await http.get(
      Uri.parse("$serverEndpoint/all"),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      resData.forEach((i) {
        File file = File.fromJson(i);
        interimFiles.add(file);
      });
      return interimFiles;
    } else {
      throw Exception("Unable to get Files");
    }
  }

  Future<bool> downloadFile(filename, filePath, ext, fileId) async {
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
      // print(response.bodyBytes.length);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<File>> search(keyword) async {
    List<File> interimFiles = [];
    final res = await http.get(
      Uri.parse("$serverEndpoint/search/$keyword"),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      // print(resData);
      resData.forEach((i) {
        File file = File.fromJson(i);
        interimFiles.add(file);
      });
      return interimFiles;
    } else {
      throw Exception("Unable to get Files");
    }
  }
}
