import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/snackbar.dart';

class UpdatePasswordPage extends StatefulWidget {
  static const routeName = '/update-password';
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final String serverEndPoint = Api.userEndpoint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
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
                        hintText: "Current Password",
                        controller: currentPasswordController,
                        prefixIcon: const Icon(Icons.password_outlined),
                        obscure: true,
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
                        text: "Reset Password",
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
                              final String currentPassword =
                                  currentPasswordController.value.text.trim();
                              final String newPassword =
                                  newPasswordController.value.text.trim();
                              final String confirmPassword =
                                  confirmPasswordController.value.text.trim();
                              final String email = provider.userEmail;
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                if (newPassword == confirmPassword) {
                                  if (await updatePassword(
                                      email, newPassword, currentPassword)) {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "Password Changed Successfully");
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "The Current Password you Entered is Wrong. Try Again");
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    CustomSnackbar.show(context,
                                        "Passwords do not Match. Try Again");
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(context,
                                    "There was an error Changing Password");
                              }
                            }
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

  Future<bool> updatePassword(email, newPassword, currentPassword) async {
    final res = await http.put(
      Uri.parse("$serverEndPoint/update-password/$email"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"newPassword": newPassword, "enteredPassword": currentPassword},
      ),
    );
    if (res.statusCode == 200) return true;
    return false;
  }
}
