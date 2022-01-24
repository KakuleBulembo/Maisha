import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/add_button.dart';
import 'package:maisha/components/favorites.dart';
import 'package:maisha/therapist/create_post_form.dart';
import 'package:maisha/therapist/messages.dart';
import 'package:maisha/therapist/notification_builder.dart';
import 'package:maisha/therapist/therapist_profile.dart';
import 'package:maisha/users/search_engine.dart';
import 'package:maisha/users/user_home.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../constant.dart';

class DashboardTherapistScreen extends StatefulWidget {
  const DashboardTherapistScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_therapist_screen';

  @override
  _DashboardTherapistScreenState createState() => _DashboardTherapistScreenState();
}

class _DashboardTherapistScreenState extends State<DashboardTherapistScreen> {
  String ? authorID;
  int index = 0;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MAISHA BORA',
              style: GoogleFonts.aclonica(
                textStyle:const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              children: [
                buildUsername(context),
                IconButton(
                    onPressed: (){
                      _auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                    },
                    icon:const Icon(
                      IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                      size: 35,
                    ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, Messages.id);
            },
            icon: const Icon(
              IconData(0xe571, fontFamily: 'MaterialIcons', matchTextDirection: true),
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AddButton(
                      title: 'Post',
                      addLabel: 'Add Post',
                      onPressed: (){
                        Navigator.pushNamed(context, CreatePostForm.id);
                      }
                  ),
                ),
                Container(
                  height: 10,
                  width: size.width,
                  color: Colors.purple.withOpacity(0.07),
                  child:const Text(''),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            if(index == 0)
              const UserHome(),
            if(index == 1)
              const NotificationBuilder(),
            if(index == 2)
              const TherapistProfile(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: SalomonBottomBar(
          currentIndex: index,
          onTap: (i){
            setState(() {
              index = i;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon:const Icon(Icons.home),
              title:const Text('Home'),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
                icon:const Icon(Icons.notifications),
                title:const Text('Notification'),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon:const Icon(Icons.person),
              title:const Text('Profile'),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
  Widget buildWidget(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(authorID).snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data.data();
          return  Text(
              'Posted by ${userDocument['username']}',
              style: GoogleFonts.abhayaLibre(
                textStyle:const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
          );
        }
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
                  textStyle:const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              ),
            );
          }
          return Container();
        }
    );
  }
}
