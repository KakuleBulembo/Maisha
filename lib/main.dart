import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maisha/admin/create_therapist.dart';
import 'package:maisha/admin/dashboard_screen.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/auth/register_screen.dart';
import 'package:maisha/therapist/create_post_form.dart';
import 'package:maisha/therapist/dashboard_therapist_screen.dart';
import 'package:maisha/users/dashboard_user_screen.dart';
import 'package:maisha/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constant.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => const WelcomeScreen(),
        LoginScreen.id : (context) => const LoginScreen(),
        RegisterScreen.id : (context) => const RegisterScreen(),
        DashboardScreen.id : (context) => const DashboardScreen(),
        DashboardUserScreen.id : (context) => const DashboardUserScreen(),
        DashboardTherapistScreen.id : (context) => const DashboardTherapistScreen(),
        CreateTherapist.id : (context) => const CreateTherapist(),
        CreatePostForm.id : (context) => const CreatePostForm(),
      },
    );
  }
}

