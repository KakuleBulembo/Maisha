import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maisha/components/rounded_button.dart';
import 'package:maisha/components/rounded_input_field.dart';
import 'package:maisha/components/show_toast.dart';

import '../constant.dart';

class CreateTherapist extends StatefulWidget {
  const CreateTherapist({Key? key}) : super(key: key);
  static String id = 'create_therapist';

  @override
  _CreateTherapistState createState() => _CreateTherapistState();
}

class _CreateTherapistState extends State<CreateTherapist> {
  String ? username;
  late String email;
  String password = '123456';
  String role = 'Therapist';
  bool vuePass = true;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Therapist', style: TextStyle(
              color: kPrimaryLightColor,
              fontWeight: FontWeight.bold),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/signup.svg',
                    height: size.height * 0.3,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  RoundedTextFormField(
                      hintText: 'Therapist Username',
                      icon: Icons.person,
                      onChanged: (value){
                        username = value;
                      },
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the username';
                      }
                      return null;
                    },
                  ),
                  RoundedTextFormField(
                      hintText: 'Therapist Email',
                      icon: Icons.email,
                      onChanged: (value){
                        email = value;
                      },
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter the email';
                      }
                      else{
                        if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                          return null;
                        }
                        else{
                          return 'Enter a valid email';
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  RoundedButton(
                    label: 'Add Therapist',
                    color: kPrimaryColor,
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          showSpinner = true;
                        });
                        await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        ).then((value) async{
                          User? currentUser = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
                            'uid' : currentUser.uid,
                            'username' : username,
                            'email' : currentUser.email,
                            'role' : role,
                            'session' : {},
                            'ts' : DateTime.now(),
                          });
                        }).then((value) {
                          setState(() {
                            showSpinner = false;
                          });
                        }).then((value) {
                          Navigator.pop(context);
                          showToast(
                            message: 'You have created a therapist. Please login',
                            color: Colors.green,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
