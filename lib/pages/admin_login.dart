import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/admin_nav.dart';
import 'package:file_server/pages/landing.dart';
import 'package:file_server/providers/admin.provider.dart';
import 'package:file_server/utils/snackbar.dart';
import 'package:file_server/widgets/button.dart';
import 'package:file_server/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/admin.dart';
import '../models/api_model.dart';

class AdminLoginPage extends StatefulWidget {
  static const routeName = '/admin-login';
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  final String serverEndPoint = Api.adminEndpoint;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    // final deviceHeight = MediaQuery.of(context).size.height;
    // final deviceWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
            },
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30.0, top: 70),
                              child: Text(
                                'Login',
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: color.secondary),
                              ),
                            ),
                            AuthTextField(
                              prefixIcon: const Icon(Icons.key_outlined),
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
                            const Divider(
                              height: 30,
                              thickness: .001,
                            ),
                            MyButton(
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
                                    final String password =
                                        passwordController.value.text.trim();
                                    if (await logIn(password, context)) {
                                      if (context.mounted) {
                                        CustomSnackbar.show(
                                            context, "Login Successful");
                                        Navigator.pushNamed(
                                            context, AdminNavPage.routeName);
                                      }
                                    } else {
                                      if (context.mounted) {
                                        CustomSnackbar.show(context,
                                            "Wrong Password. Try Again!!");
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      CustomSnackbar.show(context,
                                          "Server Error. Try Again!!! $e");
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                // Navigator.pushNamed(
                                //     context, AdminNavPage.routeName);
                              },
                              text: 'Login',
                              leading: Icon(
                                Icons.login_outlined,
                                color: color.onPrimary,
                                size: 30,
                              ),
                            ),
                            const Divider(
                              height: 30,
                              thickness: .001,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, LandingPage.routeName);
                              },
                              child: Text(
                                "Back to Landing Page",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: color.onSecondary,
                                ),
                              ),
                            ),
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

  Future<bool> logIn(password, context) async {
    final res = await http.get(
      Uri.parse("$serverEndPoint/login/$password"),
    );
    // print(res.body);
    if (res.statusCode == 200) {
      final resData = jsonDecode(res.body);
      final Admin admin = Admin.fromJson(resData[0]);
      if (context.mounted) {
        Provider.of<AdminData>(context, listen: false).getAdmin(admin);
      }
      return true;
    } else {
      return false;
    }
  }
}
