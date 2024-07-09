import 'package:file_server/pages/files.dart';
import 'package:file_server/pages/manage_account.dart';
import 'package:file_server/pages/search.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<NavigationRailDestination> _destinations = [
    const NavigationRailDestination(
      padding: EdgeInsets.symmetric(vertical: 20),
      icon: Icon(
        Icons.dashboard_outlined,
      ),
      label: Text("Files"),
      selectedIcon: Icon(
        Icons.dashboard,
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
        return const HomePageView();
      case 1:
        return const ManageAccountPage();
      case 2:
        return const SearchPage();
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
