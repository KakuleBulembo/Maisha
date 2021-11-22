import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/background.dart';

class DashboardTherapistScreen extends StatefulWidget {
  const DashboardTherapistScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_therapist_screen';

  @override
  _DashboardTherapistScreenState createState() => _DashboardTherapistScreenState();
}

class _DashboardTherapistScreenState extends State<DashboardTherapistScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        )
    );
  }
}
