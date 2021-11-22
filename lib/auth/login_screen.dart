import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maisha/admin/dashboard_screen.dart';
import 'package:maisha/auth/register_screen.dart';
import 'package:maisha/components/background.dart';
import 'package:maisha/components/rounded_button.dart';
import 'package:maisha/components/show_toast.dart';
import 'package:maisha/constant.dart';
import 'package:maisha/therapist/dashboard_therapist_screen.dart';
import 'package:maisha/users/dashboard_user_screen.dart';

import '../components/already_have_an_account_check.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  String ? role;
  bool showSpinner = false;
  bool vuePass = true;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ),
      child: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "LOGIN",
                style: TextStyle(
                  color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  height: size.height * 0.03,
              ),
              SvgPicture.asset(
                  'assets/icons/login.svg',
                height: size.height * 0.3,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              RoundedTextFormField(
                icon: Icons.email,
                hintText: 'Your Email',
                onChanged: (value){
                  email = value;
                },
              ),
              RoundedPasswordField(
                hintText: 'Password',
                obscureText: vuePass,
                onTap: (){
                  setState(() {
                    if(vuePass == true){
                      vuePass = false;
                    }
                    else{
                      vuePass = true;
                    }
                  });
                },
                onChanged: (value){
                  password = value;
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              RoundedButton(
                  label: 'Login',
                  onPressed: () async{
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                      ).then((value) {
                        setState(() {
                          showSpinner = false;
                        });
                      });
                      User? currentUser = _auth.currentUser;
                      final DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection('users').doc(currentUser!.uid).get();
                      role = snap['role'];
                      if(role == 'Admin'){
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context, DashboardScreen.id);
                      }
                      else if(role == 'Therapist'){
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context, DashboardTherapistScreen.id);
                      }
                      else{
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context, DashboardUserScreen.id);
                      }
                    }
                    catch(e){
                      showToast(message: 'Wrong credentials', color: Colors.red);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                  color: kPrimaryColor,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              AlreadyHaveAnAccountCheck(
                onTap: (){
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
              )
            ],
          )
      ),
    );
  }
}

