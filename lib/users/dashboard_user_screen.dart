import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/chat_screen.dart';
import 'package:maisha/components/favorites.dart';
import 'package:maisha/components/top_button.dart';
import 'package:maisha/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/users/profile.dart';
import 'package:maisha/users/search_engine.dart';
import 'package:maisha/users/therapist_request.dart';
import 'package:maisha/users/user_home.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_user_screen';

  @override
  _DashboardUserScreenState createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
          ],
        ),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20,
            bottom: 20
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0,
                right: 20,
                bottom: 10,
              ),
              child: buildWidget(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 10,
              width: size.width,
              color: Colors.purple.withOpacity(0.07),
              child:const Text(''),
            ),
            const SizedBox(
              height: 10,
            ),
            if(index == 0)
              const UserHome(),
            if(index == 1)
              const Favorites(),
            if(index == 2)
              const SearchEngine(),
            if(index == 3)
              const Profile(),
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
              icon:const Icon(Icons.favorite_border),
              title:const Text('Favorite'),
              selectedColor: Colors.pink,
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
  Widget buildWidget(BuildContext context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var user = snapshot.data.data();
            if(user != null){
              if(user['session'] == true){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posts',
                      style: GoogleFonts.acme(
                        textStyle:const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const ChatScreen();
                        }));
                      },
                      icon:const Icon(
                        IconData(0xe571, fontFamily: 'MaterialIcons', matchTextDirection: true),
                        color: kPrimaryColor,
                        size: 35,
                      ),
                    ),
                  ],
                );
              }
              else {
                return TopButton(
                    title: 'Posts',
                    addLabel: 'Session',
                    onPressed: (){
                      Navigator.pushNamed(context, TherapistRequest.id);
                    }
                );
              }
            }
            return Container();
          }
          return Container();
        }
    );
  }
}
