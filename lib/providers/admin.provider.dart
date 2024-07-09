import 'package:flutter/foundation.dart';

import '../models/admin.dart';

class AdminData extends ChangeNotifier {
  Admin currentAdmin = Admin(email: "none", password: "none");

  void getAdmin(Admin admin) {
    currentAdmin = admin;
    notifyListeners();
  }

  // String get userName => currentUser.name;
  String get adminEmail => currentAdmin.email;
  String get adminPassword => currentAdmin.password;
}
