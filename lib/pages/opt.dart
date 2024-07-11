import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/reset_password.dart';
import 'package:file_server/utils/dialog.dart';
import 'package:file_server/widgets/otp_text_field.dart';
import 'package:file_server/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../models/user_args.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';

class OtpPage extends StatefulWidget {
  static const routeName = '/otp';
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController thirdController = TextEditingController();
  TextEditingController fourthController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String serverEndPoint = Api.userEndpoint;

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var args = ModalRoute.of(context)!.settings.arguments as UserArgs?;
    final String? email = args?.email;
    final String? password = args?.password;

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
        },
        child: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 70),
              child: MyAppBar(
                title: "Account Verification",
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Container(
                      width: 700,
                      padding: const EdgeInsets.all(30),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: color.onPrimary,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Divider(
                              height: 60,
                              thickness: 0.005,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Verification code sent to $email",
                                style: TextStyle(
                                  color: color.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "\n\n\nPlease check the inbox or spam folder and enter the code that was sent below to continue",
                                    style: TextStyle(
                                      letterSpacing: 2,
                                      color: color.secondary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Divider(
                              height: 30,
                              thickness: 0.005,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OtpTextField(controller: firstController),
                                OtpTextField(
                                  controller: secondController,
                                ),
                                OtpTextField(
                                  controller: thirdController,
                                ),
                                OtpTextField(
                                  controller: fourthController,
                                )
                              ],
                            ),
                            // const Divider(
                            //   height: 20,
                            //   thickness: 0.005,
                            // ),
                            // RichText(
                            //   text: TextSpan(
                            //     text: "Didn't recieve code?? ",
                            //     style: TextStyle(
                            //       color: color.secondary,
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.w300,
                            //       height: 0,
                            //     ),
                            //     children: [
                            //       TextSpan(
                            //         text: "Resend",
                            //         style: TextStyle(
                            //           color: color.primary,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.w700,
                            //           height: 0,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const Divider(
                              height: 70,
                              thickness: 0.005,
                            ),
                            MyButton(
                              onPressed: () async {
                                SystemChannels.textInput
                                    .invokeMethod<void>('TextInput.hide');
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  try {
                                    final String code =
                                        firstController.value.text +
                                            secondController.value.text +
                                            thirdController.value.text +
                                            fourthController.value.text;
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (await verifyOtp(code)) {
                                      try {
                                        if (password == null) {
                                          if (context.mounted) {
                                            Navigator.pushNamed(
                                              context,
                                              ResetPasswordPage.routeName,
                                              arguments: {"email": email},
                                            );
                                          }
                                        } else {
                                          if (await addUser(email, password)) {
                                            if (context.mounted) {
                                              CustomDialog.showPopUp(
                                                  context,
                                                  "USER REGISTERED",
                                                  "You have Successfully been Registered",
                                                  "PROCEED",
                                                  null, () {
                                                Navigator.pushNamed(context,
                                                    LoginPage.routeName);
                                              }, () {});
                                            }
                                          } else {
                                            if (context.mounted) {
                                              CustomSnackbar.show(context,
                                                  "User Registration Failed");
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          CustomSnackbar.show(context,
                                              "User Registration Failed $e");
                                        }
                                      }
                                    } else {
                                      if (context.mounted) {
                                        CustomSnackbar.show(context,
                                            "Incorrect Code. Try Again!!");
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "User verification Failed $e");
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              text: "Verify and Proceed",
                              // style: ElevatedButton.styleFrom(
                              //     backgroundColor: color.primary),
                              // child: Text(
                              //   "Verify and Proceed",
                              //   style: TextStyle(
                              //       color: color.secondary,
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w700),
                              // ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Verify OTP code
  Future<bool> verifyOtp(code) async {
    final res = await http.post(
      Uri.parse("$serverEndPoint/verify-otp"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "code": code,
        },
      ),
    );
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      final String verified = resData['verified'];
      if (verified == "true") {
        return true;
      }
      return false;
    } else {
      throw Exception("Failed to login.");
    }
  }

  // Register User
  Future<bool> addUser(email, password) async {
    Map<String, String> user = {
      'email': email,
      'password': password,
    };

    final res = await http.post(
      Uri.parse("$serverEndPoint/signup"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user),
    );
    if (res.statusCode == 200) {
      if (res.body == "duplicate") {
        throw "This email has been used by another user";
      }
      return true;
    }
    return false;
  }
}
