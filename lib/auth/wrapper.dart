import 'package:flutter/material.dart';
import 'package:ohstel_hostel_app/auth/pages/login_page.dart';
import 'package:ohstel_hostel_app/hostel_booking/hoste_home_page.dart';
import 'package:provider/provider.dart';

import 'models/login_user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // this wrapper class is here to monitor the auth changes, it returns home
    // page if the user is already logged in and login page if not instance of
    // login is present(no user is already logged in) or the user logged out.
    // provider is being used to monitor the UserStream in the auth method class

    final user = Provider.of<LoginUserModel>(context);

    if (user == null) {
      return ToggleBetweenLoginAndSignUpPage();
    } else {
      return HostelHomePage();
    }
  }
}
