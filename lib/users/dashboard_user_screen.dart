import 'package:flutter/material.dart';
import 'package:maisha/components/background.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_user_screen';

  @override
  _DashboardUserScreenState createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column()
    );
  }
}
