import 'package:flutter/material.dart';
import 'package:ohstel_hostel_app/auth/methods/auth_methods.dart';
import 'package:ohstel_hostel_app/hostel_booking/upload_hostel_page.dart';
import 'package:ohstel_hostel_app/widgets/styles.dart' as Styles;

import 'hostel_get_loctaion_page.dart';

class HostelHomePage extends StatefulWidget {
  @override
  _HostelHomePageState createState() => _HostelHomePageState();
}

class _HostelHomePageState extends State<HostelHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () async => await AuthService().signOut(),
            ),
          ],
          backgroundColor: Colors.grey[200],
          title: Text(
            'Hostel Management Console',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("Upload", style: Styles.captionTextStyle),
                icon: Icon(Icons.file_upload, color: Styles.themePrimary),
              ),
//              Tab(
//                child: Text("Inspect", style: Styles.captionTextStyle),
//                icon: Icon(Icons.remove_red_eye, color: Styles.themePrimary),
//              ),
//              Tab(
//                child: Text("Paid", style: Styles.captionTextStyle),
//                icon: Icon(Icons.payment, color: Styles.themePrimary),
//              ),
//              Tab(
//                child: Text("Edit", style: Styles.captionTextStyle),
//                icon: Icon(Icons.mode_edit, color: Styles.themePrimary),
//              ),
              Tab(
                child: Text("Location", style: Styles.captionTextStyle),
                icon: Icon(Icons.add_location, color: Styles.themePrimary),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UploadHostelPage(),
//            ViewInspectionRequestPage(),
//            ViewPaidHostel(),
//            HostelSearchPage(),
            GetLocationPage()
          ],
        ),
      ),
    );
  }
}
