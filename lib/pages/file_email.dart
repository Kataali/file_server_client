import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/models/file_args.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/app_bar.dart';
import '../utils/snackbar.dart';

class FileEmailPage extends StatefulWidget {
  static const routeName = '/email-file';
  const FileEmailPage({super.key});

  @override
  State<FileEmailPage> createState() => _FileEmailPageState();
}

class _FileEmailPageState extends State<FileEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String serverEndpoint = Api.filesEndpoint;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final args = ModalRoute.of(context)!.settings.arguments as FileArgs?;
    final String? title = args?.title;
    final String? path = args?.path;
    final int? fileId = args?.fileId;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: MyAppBar(title: "Email File"),
      ),
      body: BlurryModalProgressHUD(
        inAsyncCall: isLoading,
        dismissible: false,
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: 700,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: color.onPrimary,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\nEmail the Email address you want $title to be sent to below:",
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
                      hintText: "Email", controller: emailController),
                  const Divider(
                    height: 30,
                    thickness: .001,
                  ),
                  MyButton(
                      text: "Email File",
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final String email = emailController.value.text.trim();
                        SystemChannels.textInput
                            .invokeMethod<void>('TextInput.hide');
                        if (!_formKey.currentState!.validate()) {
                          return;
                        } else {
                          try {
                            if (await sendEmail(email, path, title, fileId)) {
                              if (context.mounted) {
                                CustomSnackbar.show(
                                  context,
                                  "File Sent to $email",
                                );
                                Navigator.pop(context);
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              CustomSnackbar.show(
                                context,
                                "Unable to send File to $email. Try Again",
                              );
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }),
                  const Divider(
                    height: 30,
                    thickness: .001,
                  ),
                  MyButton(
                    color: color.onSecondary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Cancel',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendEmail(email, path, title, fileId) async {
    final res = await http.post(
      Uri.parse("$serverEndpoint/mail/$path"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"email": email, "title": title, "fileId": fileId},
      ),
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
