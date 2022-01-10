import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../constant.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .orderBy('ts', descending: true)
      .snapshots();
  String ? authorID;
  bool likeButton = false;
  Color ? likeButtonColor;
  int totalLikes = 0;
  Future<bool> checkLikeButtonStatus(String documentId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(documentId)
        .collection('likedBy')
        .doc(_auth.currentUser!.uid)
        .get().then((value) {
      return value.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
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
                    checkLikeButtonStatus(data.docs[index].reference.id).then((value) {
                      setState(() {
                        likeButton = value;
                      });
                    });
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
                                              padding: EdgeInsets.zero,
                                              onPressed: () async{
                                                Future<DocumentSnapshot> subSnapshot = FirebaseFirestore.instance.collection('posts').doc(data.docs[index].reference.id).collection('likedBy').doc(_auth.currentUser!.uid).get();
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
                                                color: likeButton == true ? Colors.purple : Colors.grey,
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
                                            width: 20,
                                          ),
                                          Text(
                                            totalLikes.toString(),
                                            style:TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: likeButton == true ? Colors.purple : Colors.grey,
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
                              ReadMoreText(
                                data.docs[index]['body'] ?? '',
                                trimLines: 2,
                                colorClickableText: Colors.purple,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show More',
                                trimExpandedText: 'Show Less',
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
                          color: Colors.purple.withOpacity(0.07),
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
}
