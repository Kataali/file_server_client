import 'package:file_server/pages/manage_admin_account.dart';
import 'package:file_server/pages/upload.dart';
import 'package:file_server/pages/file_stats.dart';
import 'package:flutter/material.dart';

class AdminNavPage extends StatefulWidget {
  static const routeName = '/admin-home';
  const AdminNavPage({super.key});

  @override
  State<AdminNavPage> createState() => _AdminNavPageState();
}

class _AdminNavPageState extends State<AdminNavPage> {
  int _selectedIndex = 0;

  final List<NavigationRailDestination> _destinations = [
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.bar_chart_outlined),
      label: Text("Stats"),
      selectedIcon: Icon(Icons.bar_chart),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(
        Icons.upload_file_outlined,
      ),
      label: Text("Upload \nFiles"),
      selectedIcon: Icon(
        Icons.upload_file,
      ),
    ),
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(Icons.manage_accounts_outlined),
      label: Text("Manage \nAccount"),
      selectedIcon: Icon(Icons.manage_accounts),
    ),
  ];

  Widget changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        return const FileStatsPage();
      case 1:
        return const UploadFilePage();
      case 2:
        return const ManageAdminAccountPage();
      default:
        return const Text("No Such Destination");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      children: [
        NavigationRail(
          destinations: _destinations,
          selectedIndex: _selectedIndex,
          onDestinationSelected: changeDestination,
          useIndicator: false,
          labelType: NavigationRailLabelType.all,
          elevation: 5,
          selectedIconTheme: IconThemeData(color: color.primary, size: 40),
          selectedLabelTextStyle: TextStyle(color: color.primary),
          minWidth: 100,
        ),
        Expanded(
          child: changeDestination(_selectedIndex),
        ),
      ],
    );
  }
}
