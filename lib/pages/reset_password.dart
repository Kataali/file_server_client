import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/custom_textfield.dart';
import '../utils/snackbar.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset-password';
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final String serverEndPoint = Api.userEndpoint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;
    final String? email = args?["email"];
    // print(email);

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
                        'Reset Password',
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
                              final String newPassword =
                                  newPasswordController.value.text.trim();
                              final String confirmPassword =
                                  confirmPasswordController.value.text.trim();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                if (newPassword == confirmPassword) {
                                  if (await resetPassword(email, newPassword)) {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "Password Reset Successfully");
                                      Navigator.pushNamed(
                                          context, LoginPage.routeName);
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    CustomSnackbar.show(
                                        context, "Passwords do not Match");
                                    
                                  }
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(
                                    context, "Error Resetting Password");
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

  Future<bool> resetPassword(email, password) async {
    final res = await http.put(
      Uri.parse("$serverEndPoint/reset-password/$email"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "newPassword": password,
        },
      ),
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
