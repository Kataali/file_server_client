import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/custom_textfield.dart';
import 'package:file_server/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/app_bar.dart';

class UploadFilePage extends StatefulWidget {
  static const routeName = '/upload-file';
  const UploadFilePage({super.key});

  @override
  State<UploadFilePage> createState() => _UploadFilePage();
}

class _UploadFilePage extends State<UploadFilePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final serverEndPoint = Api.filesEndpoint;
  bool isLoading = false;
  PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      dismissible: false,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: MyAppBar(
            title: "Upload File",
            leading: SizedBox(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: color.onPrimary,
              ),
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              width: 700,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Divider(
                      height: 30,
                      thickness: .001,
                    ),
                    Container(
                        color: color.tertiary,
                        padding: const EdgeInsets.all(15),
                        width: 500,
                        child: file == null
                            ? InkWell(
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(withReadStream: true);
                                  if (result != null) {
                                    // File file = File(result.files.single.bytes!);
                                    setState(() {
                                      file = result.files.single;
                                    });
                                    // print(file);
                                  }
                                },
                                child: Icon(
                                  Icons.add_outlined,
                                  size: 100,
                                  color: color.primary,
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: color.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(file!.name),
                                        leading: const Icon(
                                          Icons.upload_file_outlined,
                                          size: 30,
                                        ),
                                        tileColor: color.primary,
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              file = null;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            size: 30,
                                            color: color.onSecondary,
                                          ),
                                        ),
                                        titleTextStyle: TextStyle(
                                          color: color.secondary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                    file == null
                        ? Text(
                            "\nClick on the button to choose a file",
                            style: TextStyle(
                              letterSpacing: 2,
                              color: color.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                          )
                        : Text(
                            "\nFile Chosen",
                            style: TextStyle(
                              letterSpacing: 2,
                              color: color.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                          ),
                    const Divider(
                      height: 30,
                      thickness: .001,
                    ),
                    CustomTextField(
                        hintText: "File Title", controller: titleController),
                    const Divider(
                      height: 30,
                      thickness: .001,
                    ),
                    CustomTextField(
                        hintText: "File Description...",
                        controller: descriptionController),
                    const Divider(
                      height: 100,
                      thickness: .001,
                    ),
                    MyButton(
                      text: "Upload",
                      leading: Icon(
                        Icons.file_upload,
                        color: color.onPrimary,
                      ),
                      onPressed: () async {
                        SystemChannels.textInput
                            .invokeMethod<void>('TextInput.hide');
                        if (!_formKey.currentState!.validate()) {
                          return;
                        } else {
                          if (file == null) {
                            CustomSnackbar.show(
                                context, "You must Select a file to proceed");
                          } else {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final title = titleController.value.text.trim();
                              final description =
                                  descriptionController.value.text.trim();
                              if (await uploadFile(file!, title, description)) {
                                titleController.clear();
                                descriptionController.clear();
                                if (context.mounted) {
                                  CustomSnackbar.show(
                                      context, "File Uploaded Succefully");
                                  setState(() {
                                    file = null;
                                  });
                                }
                              } else {
                                if (context.mounted) {
                                  CustomSnackbar.show(
                                      context, "File Upload Failed");
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(
                                    context, "File Upload Failed $e");
                              }
                            }
                          }
                        }
                        
                        setState(() {
                          file = null;
                          isLoading = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> uploadFile(PlatformFile file, title, description) async {
    final serverUrl = "$serverEndPoint/file-upload";
    final postUrl = Uri.parse(serverUrl);
    final request = http.MultipartRequest("POST", postUrl);
    request.fields["title"] = title;
    request.fields["description"] = description;
    request.files.add(
      http.MultipartFile(
        "file",
        file.readStream!,
        file.size,
        filename: file.name,
      ),
    );
    final res = await request.send();
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
