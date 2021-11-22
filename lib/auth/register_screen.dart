import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/already_have_an_account_check.dart';
import 'package:maisha/components/background.dart';
import 'package:maisha/components/rounded_button.dart';
import 'package:maisha/components/rounded_input_field.dart';
import 'package:maisha/components/rounded_password_field.dart';
import 'package:maisha/components/show_toast.dart';
import 'package:maisha/constant.dart';
import 'package:loading_overlay/loading_overlay.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String ? username;
  late String email;
  late String password;
  String role = 'User';
  bool vuePass = true;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      progressIndicator:const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      ),
      child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('REGISTER', style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                SvgPicture.asset(
                    'assets/icons/signup.svg',
                  height: size.height * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                RoundedTextFormField(
                    hintText: 'Your Username',
                    icon: Icons.person,
                    onChanged: (value){
                       username = value;
                    }
                ),
                RoundedTextFormField(
                    hintText: 'Your Email',
                    icon: Icons.email,
                    onChanged: (value){
                      email = value;
                    }
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
                    label: 'Register',
                    color: kPrimaryColor,
                  onPressed: () async{
                      await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                      ).then((value) async{
                        setState(() {
                          showSpinner = true;
                        });
                        User? currentUser = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
                          'uid' : currentUser.uid,
                          'username' : username,
                          'email' : currentUser.email,
                          'role' : role,
                          'ts' : DateTime.now(),
                        });
                      }).then((value) {
                        setState(() {
                          showSpinner = false;
                        });
                      });
                      Navigator.pushNamed(context, LoginScreen.id);
                      showToast(
                        message: 'You have been registered. Please login',
                        color: Colors.green,
                      );
                  },
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                AlreadyHaveAnAccountCheck(
                  login: false,
                    onTap: (){
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                    }
                ),
              ],
            ),
          ),
      ),
    );
  }
}
