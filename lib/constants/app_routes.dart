import 'package:file_server/pages/admin_login.dart';
import 'package:file_server/pages/admin_update_password.dart';
import 'package:file_server/pages/manage_admin_account.dart';
import 'package:file_server/pages/update_password.dart';
import 'package:file_server/pages/upload.dart';
import 'package:file_server/pages/admin_nav.dart';
import 'package:file_server/pages/file_email.dart';
import 'package:file_server/pages/file_stats.dart';
import 'package:file_server/pages/home.dart';
import 'package:file_server/pages/forgot_password.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/pages/opt.dart';
import 'package:file_server/pages/search.dart';
import 'package:file_server/pages/signup.dart';
import 'package:flutter/material.dart';

import '../pages/landing.dart';
import '../pages/reset_password.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      LoginPage.routeName: (context) => const LoginPage(),
      SingUpPage.routeName: (context) => const SingUpPage(),
      HomePage.routeName: (context) => const HomePage(),
      OtpPage.routeName: (context) => const OtpPage(),
      ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
      FileEmailPage.routeName: (context) => const FileEmailPage(),
      SearchPage.routeName: (context) => const SearchPage(),
      ResetPasswordPage.routeName: (context) => const ResetPasswordPage(),
      UploadFilePage.routeName: (context) => const UploadFilePage(),
      AdminNavPage.routeName: (context) => const AdminNavPage(),
      FileStatsPage.routeName: (context) => const FileStatsPage(),
      UpdatePasswordPage.routeName: (context) => const UpdatePasswordPage(),
      ManageAdminAccountPage.routeName: (context) =>
          const ManageAdminAccountPage(),
      LandingPage.routeName: (context) => const LandingPage(),
      AdminLoginPage.routeName: (context) => const AdminLoginPage(),
      AdminUpdatePasswordPage.routeName: (context) =>
          const AdminUpdatePasswordPage()
    };
  }
}
