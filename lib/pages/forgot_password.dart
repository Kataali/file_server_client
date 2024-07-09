import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/models/user_args.dart';
import 'package:file_server/pages/opt.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../utils/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final String serverEndPoint = Api.userEndpoint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
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
                      'Forgot Password',
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
                      hintText: "Email Address",
                      controller: emailController,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const Divider(
                      height: 130,
                      thickness: .001,
                    ),
                    MyButton(
                        text: "Proceed",
                        onPressed: () async {
                          SystemChannels.textInput
                              .invokeMethod<void>('TextInput.hide');
                          final String email =
                              emailController.value.text.trim();
                          if (!_formKey.currentState!.validate()) {
                            return;
                          } else {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              if (await sendOtp()) {
                                if (context.mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    OtpPage.routeName,
                                    arguments:
                                        UserArgs(email: email, password: null),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  CustomSnackbar.show(context,
                                      "Check Connection and Try Again");
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(
                                    context, "Check Connection and Try Again");
                              }
                            }
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendOtp() async {
    String email = emailController.value.text;
    final res = await http.post(
      Uri.parse("$serverEndPoint/send-otp"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"email": email},
      ),
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
