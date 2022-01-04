import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/top_button.dart';
import 'package:maisha/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_user_screen';

  @override
  _DashboardUserScreenState createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  final _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .orderBy('ts', descending: true)
      .snapshots();
  String ? authorID;
  bool likeButton = false;
  Color ? likeButtonColor;
  int totalLikes = 0;

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
              child: TopButton(
                  title: 'Blogs',
                  addLabel: 'Session',
                  onPressed: (){
                    _auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (r) => false);
                  }
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 10,
              width: size.width,
              color: kPrimaryColor.withOpacity(0.5),
              child:const Text(''),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: posts,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    final data = snapshot.requireData;
                    return ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: size.width,
                        height: 400,
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data.size,
                          itemBuilder:  (context, index){
                            authorID = data.docs[index]['uid'];
                            totalLikes = data.docs[index]['totalLikes'];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.7,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.docs[index]['title'] ?? '',
                                                      style:const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.7,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.purple.withOpacity(0.5),
                                                        borderRadius:const BorderRadius.all(Radius.circular(4))

                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          data.docs[index]['type'] ?? '',
                                                          style:const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async{
                                                        Future<DocumentSnapshot<Map<String, dynamic>>> subSnapshot = FirebaseFirestore.instance.collection('posts').doc(data.docs[index].reference.id).collection('likedBy').doc(_auth.currentUser!.uid).get();
                                                        DocumentSnapshot doc = await subSnapshot;
                                                          if(doc.exists){
                                                            DocumentReference documentReference = FirebaseFirestore.instance
                                                                .collection('posts')
                                                                .doc(data.docs[index].reference.id)
                                                                .collection('likedBy')
                                                                .doc(_auth.currentUser!.uid);
                                                            int likes = totalLikes - 1;
                                                            FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                                                              transaction.delete(documentReference);
                                                            }).then((value) {
                                                              FirebaseFirestore.instance
                                                                  .collection('posts')
                                                                  .doc(data.docs[index].reference.id)
                                                                  .update({
                                                                'totalLikes' : likes,
                                                              });
                                                            }).then((value) {
                                                              setState(() {
                                                                likeButtonColor = Colors.grey;
                                                                likeButton = true;
                                                              });
                                                            });
                                                          }
                                                          else{
                                                            int likes = totalLikes + 1;
                                                            FirebaseFirestore.instance.collection('posts')
                                                                .doc(data.docs[index].reference.id)
                                                                .collection('likedBy')
                                                                .doc(_auth.currentUser!.uid)
                                                                .set({
                                                              'userId' : _auth.currentUser!.uid
                                                            }).then((value){
                                                              FirebaseFirestore.instance
                                                                  .collection('posts')
                                                                  .doc(data.docs[index].reference.id)
                                                                  .update({
                                                                'totalLikes' : likes,
                                                              });
                                                            }).then((value) {
                                                              setState(() {
                                                                likeButtonColor = Colors.purple;
                                                                likeButton = false;
                                                              });
                                                            });

                                                          }
                                                      },
                                                      icon: Icon(
                                                        const IconData(0xe358, fontFamily: 'MaterialIcons'),
                                                        color: likeButtonColor ?? Colors.grey,
                                                        size: 70,
                                                      )
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:  [
                                                  const SizedBox(
                                                    width: 40,
                                                  ),
                                                  Text(
                                                    totalLikes.toString(),
                                                    style:const TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: kPrimaryColor,
                                      ),
                                      Text(
                                        data.docs[index]['body'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.9),
                                          fontSize: 20,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20.0),
                                      child: buildWidget(context),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 10,
                                  width: size.width,
                                  color: kPrimaryColor.withOpacity(0.5),
                                  child:const Text(''),
                                ),
                                const SizedBox(
                                  height: 10,
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
  Widget buildWidget(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(authorID).snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data.data();
          return  Text(
            'By ${userDocument['username']}',
            style: GoogleFonts.abhayaLibre(
              textStyle:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            )
          );
        }
    );
  }
}
