import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/add_button.dart';
import 'package:maisha/therapist/create_post_form.dart';
import 'package:maisha/therapist/update_post_form.dart';

import '../constant.dart';

class DashboardTherapistScreen extends StatefulWidget {
  const DashboardTherapistScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_therapist_screen';

  @override
  _DashboardTherapistScreenState createState() => _DashboardTherapistScreenState();
}

class _DashboardTherapistScreenState extends State<DashboardTherapistScreen> {
  final _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .orderBy('ts', descending: true)
      .snapshots();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 20,
          right: 20,
          bottom: 40
        ),
        child: Column(
          children: [
            Column(
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
                const Divider(
                  height: 20,
                  color: kPrimaryColor,
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: posts,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                   if(snapshot.hasData){
                     final data = snapshot.requireData;
                     return ConstrainedBox(
                       constraints: const BoxConstraints.tightFor(
                         width: 350,
                         height: 400,
                       ),
                         child: ListView.builder(
                           scrollDirection: Axis.vertical,
                           shrinkWrap: true,
                           itemCount: data.size,
                           itemBuilder:  (context, index){
                             return Column(
                               children: [
                                 GestureDetector(
                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context){
                                       return UpdatePostForm(post: data.docs[index]);
                                     }));
                                   },
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Text(
                                         data.docs[index]['title'] ?? '',
                                         style:const TextStyle(
                                           color: Colors.purple,
                                           fontWeight: FontWeight.bold,
                                           fontSize: 25,
                                         ),
                                       ),
                                       Text(
                                           data.docs[index]['type'] ?? '',
                                           style: TextStyle(
                                             color: Colors.purple.withOpacity(0.6),
                                             fontWeight: FontWeight.bold,
                                             fontSize: 18,
                                           ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 const Divider(
                                   height: 20,
                                   color: kPrimaryColor,
                                 ),
                                 Text(
                                   data.docs[index]['body'] ?? '',
                                   style: TextStyle(
                                     color: Colors.purple.withOpacity(0.9),
                                     fontSize: 20,
                                     height: 1.5,
                                   ),
                                 ),
                                 const Divider(
                                   height: 20,
                                   color: kPrimaryColor,
                                 ),
                               ],
                             );
                           }
                       ),
                     );
                   }
                   else{
                     return Container();
                   }
                }
            ),
          ],
        ),
      ),
    );
  }
}
