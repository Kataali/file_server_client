import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:file_server/pages/landing.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/signup.dart';
import 'package:file_server/pages/update_password.dart';
import 'package:file_server/providers/user.provider.dart';
import 'package:file_server/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/api_model.dart';
import '../widgets/app_bar.dart';
import '../utils/snackbar.dart';

class ManageAdminAccountPage extends StatefulWidget {
  static const routeName = '/manage-admin-account';
  const ManageAdminAccountPage({super.key});

  @override
  State<ManageAdminAccountPage> createState() => _ManageAdminAccountPageState();
}

class _ManageAdminAccountPageState extends State<ManageAdminAccountPage> {
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
            title: "Manage Admin Account",
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
                        style: TextStyle(
                          // letterSpacing: 2,
                          color: color.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
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