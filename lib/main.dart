import 'package:file_server/constants/app_routes.dart';
import 'package:file_server/constants/theme_data.dart';
import 'package:file_server/pages/landing.dart';
import 'package:file_server/providers/admin.provider.dart';
import 'package:file_server/providers/file.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user.provider.dart';

void main() {
  runApp(const FileServerApp());
}

class FileServerApp extends StatelessWidget {
  const FileServerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
        ),
        ChangeNotifierProvider<FileData>(
          create: (_) => FileData(),
        ),
        ChangeNotifierProvider<AdminData>(
          create: (_) => AdminData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(context),
        routes: AppRoutes.getRoutes(),
        initialRoute: LandingPage.routeName,
        home: const LandingPage(),
      ),
    );
  }
}
