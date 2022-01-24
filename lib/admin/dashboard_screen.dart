import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maisha/admin/admin_home.dart';
import 'package:maisha/admin/chart.dart';
import 'package:maisha/admin/create_therapist.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/add_button.dart';
import 'package:maisha/components/background.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../constant.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Size ? size = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      child: Background(
          child: Scaffold(
            appBar: AppBar(automaticallyImplyLeading: false,
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
              backgroundColor: kPrimaryColor.withOpacity(0.9),
            ),
            body: Column(
                children: [
                  const Text(
                    'Admin Dashboard',
                    style: TextStyle(
                        color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AddButton(
                        title: 'Therapist',
                        addLabel: 'Add Therapist',
                        onPressed: (){
                          Navigator.pushNamed(context, CreateTherapist.id);
                        }
                    ),
                  ),
                  const Divider(
                    height: 20,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  if(index == 0)
                    const AdminHome(),
                  if(index == 1)
                    const Chart(),
                ],
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
                    icon:const Icon(Icons.addchart_outlined),
                    title:const Text('Charts'),
                    selectedColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

      ),
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
