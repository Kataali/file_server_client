import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/admin_nav.dart';
import 'package:file_server/providers/admin.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/snackbar.dart';

class AdminUpdatePasswordPage extends StatefulWidget {
  static const routeName = '/admin-update-password';
  const AdminUpdatePasswordPage({super.key});

  @override
  State<AdminUpdatePasswordPage> createState() =>
      _AdminUpdatePasswordPageState();
}

class _AdminUpdatePasswordPageState extends State<AdminUpdatePasswordPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final String serverEndPoint = Api.adminEndpoint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<AdminData>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: MyAppBar(
          title: "",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlurryModalProgressHUD(
            inAsyncCall: isLoading,
            dismissible: false,
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: color.onPrimary,
                  ),
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                  width: 700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Change Password',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: color.secondary),
                      ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      CustomTextField(
                        hintText: "Enter Admin Email",
                        controller: emailcontroller,
                        prefixIcon: const Icon(Icons.email_outlined),
                        obscure: false,
                      ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      CustomTextField(
                        hintText: "NewPassword",
                        controller: newPasswordController,
                        prefixIcon: const Icon(Icons.password_outlined),
                        obscure: true,
                      ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      CustomTextField(
                        hintText: "Confirm Password",
                        controller: confirmPasswordController,
                        prefixIcon: const Icon(Icons.password_outlined),
                        obscure: true,
                      ),
                      const Divider(
                        height: 130,
                        thickness: .001,
                      ),
                      MyButton(
                        text: "Update Password",
                        onPressed: () async {
                          SystemChannels.textInput
                              .invokeMethod<void>('TextInput.hide');
                          if (!_formKey.currentState!.validate()) {
                            return;
                          } else {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final String enteredEmail =
                                  emailcontroller.value.text.trim();
                              final String newPassword =
                                  newPasswordController.value.text.trim();
                              final String confirmPassword =
                                  confirmPasswordController.value.text.trim();
                              final String email = provider.adminEmail;
                              if (enteredEmail == email) {
                                if (newPassword == confirmPassword) {
                                  if (await updatePassword(newPassword)) {
                                    if (context.mounted) {
                                      // CustomDialog.showPopUp(
                                      //     context,
                                      //     "Password Updated",
                                      //     "Administrator Password changed successfully",
                                      //     'OK',
                                      //     null, () {
                                      //   Navigator.pop(context);
                                      // }, () {});
                                      CustomSnackbar.show(context,
                                          "Administrator Password Changed Successfully");
                                      Navigator.pushNamed(
                                          context, AdminNavPage.routeName);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "There was an error Changing Password");
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    CustomSnackbar.show(context,
                                        "Passwords do not Match. Try Again");
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  CustomSnackbar.show(context,
                                      "The Email you entered is not the administrator Email. Try Again");
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(context,
                                    "There was an error Changing Password $e");
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> updatePassword(newPassword) async {
    final res = await http.put(
      Uri.parse("$serverEndPoint/update-password"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"newPassword": newPassword},
      ),
    );
    print(res.statusCode);
    if (res.statusCode == 200) return true;
    return false;
  }
}
