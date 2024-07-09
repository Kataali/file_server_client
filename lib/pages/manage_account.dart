import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/landing.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/signup.dart';
import 'package:file_server/pages/update_password.dart';
import 'package:file_server/providers/user.provider.dart';
import 'package:file_server/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/app_bar.dart';
import '../utils/snackbar.dart';

class ManageAccountPage extends StatefulWidget {
  static const routeName = '/manage-account';
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  bool isLoading = false;
  final String serverEndPoint = Api.userEndpoint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    var provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: MyAppBar(
            title: "Manage Account",
            leading: SizedBox(),
          )),
      body: PopScope(
        canPop: false,
        child: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  width: 700,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: color.onPrimary,
                  ),
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                  child: Column(
                    children: [
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      Text(
                        "Account Information",
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: color.secondary),
                      ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User ID:",
                            style: TextStyle(
                              // letterSpacing: 2,
                              color: color.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          Text(
                            provider.userId,
                            style: TextStyle(
                              letterSpacing: 2,
                              color: color.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email:",
                            style: TextStyle(
                              // letterSpacing: 2,
                              color: color.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          Text(
                            provider.userEmail,
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
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(
                              // letterSpacing: 2,
                              color: color.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, UpdatePasswordPage.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              "Change Password",
                              style: TextStyle(color: color.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 120,
                        thickness: .001,
                      ),
                      MyButton(
                        leading: Icon(
                          Icons.logout_outlined,
                          color: color.onPrimary,
                        ),
                        text: "Logout",
                        color: color.onSecondary,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                width: 300,
                                child: AlertDialog(
                                  title: Text('LOGOUT',
                                      style: TextStyle(color: color.secondary)),
                                  content: Text(
                                      'Are you Sure you want to Logout',
                                      style: TextStyle(color: color.secondary)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, LandingPage.routeName);
                                      },
                                      child: Text(
                                        'LOGOUT',
                                        style:
                                            TextStyle(color: color.onSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const Divider(
                        height: 30,
                        thickness: .001,
                      ),
                      MyButton(
                        leading: Icon(
                          Icons.delete_outlined,
                          color: color.onPrimary,
                        ),
                        text: "Delete Account",
                        color: color.onSecondary,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('DELETE ACCOUNT',
                                    style: TextStyle(color: color.secondary)),
                                content: Text(
                                  'Are you Sure you want to Delete your Account? All your data will be Lost.',
                                  style: TextStyle(color: color.secondary),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        final userId = provider.userId;
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (await deleteUser(userId)) {
                                          if (context.mounted) {
                                            CustomSnackbar.show(context,
                                                "Account Successfully Deleted");
                                            Navigator.pushNamed(
                                                context, SingUpPage.routeName);
                                          }
                                        } else {
                                          if (context.mounted) {
                                            CustomSnackbar.show(context,
                                                "Error Deleting Account");
                                          }
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          CustomSnackbar.show(context,
                                              "Error deleting Account");
                                        }
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    child: Text(
                                      'DELETE',
                                      style:
                                          TextStyle(color: color.onSecondary),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
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

  Future<bool> deleteUser(userId) async {
    final response =
        await http.delete(Uri.parse("$serverEndPoint/delete/$userId"));
    // print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }
}
