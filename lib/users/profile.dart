import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/constant.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildUsername(context),
            IconButton(
                onPressed: (){
                  _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                },
                icon:const Icon(
                  IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                  color: Colors.purple,
                  size: 35,
                )
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15,
            ),
            child: Column(
              children: [
                Text(
                    'Basic Info',
                  style: GoogleFonts.acme(
                    textStyle:const TextStyle(
                      color: Colors.purple,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  height: 20,
                  color: kPrimaryColor,
                ),
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.withOpacity(0.7),
                      ),
                    ),
                    buildUsername(context),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Email: ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      _auth.currentUser!.email.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.withOpacity(0.7),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget buildUsername(context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var userDocument = snapshot.data.data();
            return Text(
              userDocument['username'],
              style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.withOpacity(0.7),
                  ),
              ),
            );
          }
          return Container();
        }
    );
  }
}
