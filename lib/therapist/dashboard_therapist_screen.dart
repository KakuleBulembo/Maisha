import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/add_button.dart';
import 'package:maisha/components/background.dart';
import 'package:maisha/therapist/create_post_form.dart';

import '../constant.dart';

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
    Size size = MediaQuery.of(context).size;
    return Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _auth.currentUser!.email.toString(),
                  style:const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: (){
                    _auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (r) => false);
                  },
                  child:const Icon(
                    IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            const Text(
              'Therapist Dashboard',
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            AddButton(
                title: 'Post',
                addLabel: 'Add Post',
                onPressed: (){
                  Navigator.pushNamed(context, CreatePostForm.id);
                }
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SvgPicture.asset(
              'assets/icons/signup.svg',
              height: size.height * 0.3,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        )
    );
  }
}
