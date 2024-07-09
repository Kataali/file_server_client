import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/opt.dart';
import 'package:file_server/widgets/auth_text_field.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../models/user_args.dart';

class SingUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool isLessThanSix = false;
  final String serverEndPoint = Api.userEndpoint;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
        },
        child: Scaffold(
          body: BlurryModalProgressHUD(
            inAsyncCall: isLoading,
            dismissible: false,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 30.0, top: 70),
                            child: Text(
                              'Register',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: color.secondary),
                            ),
                          ),
                          AuthTextField(
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText: 'Email',
                            controller: emailController,
                            contentPadding:
                                const EdgeInsets.only(top: 5, left: 16.0),
                            obscure: false,
                            keyboard: TextInputType.emailAddress,
                          ),
                          const Divider(
                            height: 30,
                            thickness: .001,
                          ),
                          AuthTextField(
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    showPassword = !showPassword;
                                  },
                                );
                              },
                              child: showPassword
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined),
                            ),
                            hintText: ' Password',
                            controller: passwordController,
                            contentPadding:
                                const EdgeInsets.only(top: 5, left: 16.0),
                            obscure: showPassword ? false : true,
                          ),
                          if (isLessThanSix)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20.0, top: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'The password should be at least 6 characters long',
                                  style: TextStyle(
                                      color: color.onSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          const Divider(
                            height: 30,
                            thickness: .001,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: MyButton(
                              onPressed: () async {
                                SystemChannels.textInput
                                    .invokeMethod<void>('TextInput.hide');
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  if (passwordController.value.text
                                          .trim()
                                          .length >=
                                      6) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (await sendOtp()) {
                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                              context, OtpPage.routeName,
                                              arguments: UserArgs(
                                                email: emailController
                                                    .value.text
                                                    .trim(),
                                                password: passwordController
                                                    .value.text
                                                    .trim(),
                                              ));
                                        }
                                      } else {
                                        if (context.mounted) {
                                          CustomSnackbar.show(context,
                                              "Check Connection and Try Again");
                                        }
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        CustomSnackbar.show(context,
                                            "Check Connection and Try Again $e");
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      isLessThanSix = true;
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              text: 'Register',
                              leading: Icon(
                                Icons.person_add_alt_1_outlined,
                                color: color.onPrimary,
                                size: 30,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 30,
                            thickness: .001,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, LoginPage.routeName);
                            },
                            child: Text(
                              "Back to Login Page",
                              style: TextStyle(
                                fontSize: 16,
                                color: color.onSecondary,
                              ),
                            ),
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
    );
  }

  Future<bool> sendOtp() async {
    String email = emailController.value.text.trim();
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
