import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maisha/auth/register_screen.dart';
import 'package:maisha/constant.dart';
import 'package:maisha/auth/login_screen.dart';
import 'components/background.dart';
import 'components/rounded_button.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'MAISHA BORA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: size.height * 0.03,),
            SvgPicture.asset(
                'assets/icons/chat.svg',
              height: size.height * 0.4,
            ),
            SizedBox(height: size.height * 0.06,),
            RoundedButton(
              label: 'Login',
              color: kPrimaryColor,
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(label: 'Register',
              color: kPrimaryLightColor,
              textColor: kPrimaryColor,
              onPressed: (){
                 Navigator.pushNamed(context, RegisterScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

