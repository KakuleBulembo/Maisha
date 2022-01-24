import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../constant.dart';

class Posts extends StatefulWidget {
  const Posts({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Stream<QuerySnapshot> post;

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final _auth = FirebaseAuth.instance;
  String ? authorID;
  Map ? likedBy;
  Color ? likeButtonColor;
  int totalLikes = 0;
  bool ? likeButton;
  int home = 0;
  int school = 0;
  int work = 0;
  String ? adminUid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getAdmin();
    });
  }
  getAdmin(){
    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Admin').get().then((value) {
      adminUid = value.docs[0]['uid'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: widget.post,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final data = snapshot.requireData;
            return ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: size.width,
                height: size.height * 0.56,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.size,
                  itemBuilder:  (context, index){
                    authorID = data.docs[index]['uid'];
                    totalLikes = data.docs[index]['totalLikes'];
                    likedBy = data.docs[index]['likedBy'];
                    likeButton = data.docs[index]['likedBy'].containsKey(_auth.currentUser!.uid) ? (data.docs[index]['likedBy'][_auth.currentUser!.uid] == true) : false;
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
                                            buildAnalytics(context),
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
                                                if(likedBy!.containsKey(_auth.currentUser!.uid)){
                                                  if(likedBy![_auth.currentUser!.uid] == true){
                                                    setState(() {
                                                      likeButton = false;
                                                    });
                                                    likedBy![_auth.currentUser!.uid] = false;
                                                    FirebaseFirestore.instance
                                                        .collection('posts')
                                                        .doc(data.docs[index].reference.id)
                                                        .update({
                                                      'likedBy' : likedBy,
                                                      'totalLikes' : totalLikes - 1,
                                                    });
                                                    if(data.docs[index]['type'] == 'Home'){
                                                      FirebaseFirestore.instance
                                                          .collection('analytics')
                                                          .doc(adminUid).update({
                                                        'Home' : home - 1,
                                                      });
                                                    }
                                                    else if(data.docs[index]['type'] == 'Work'){
                                                      FirebaseFirestore.instance
                                                          .collection('analytics')
                                                          .doc(adminUid).update({
                                                        'Work' : work - 1,
                                                      });
                                                    }
                                                    else{
                                                      FirebaseFirestore.instance
                                                          .collection('analytics')
                                                          .doc(adminUid).update({
                                                        'School' : school - 1,
                                                      });
                                                    }
                                                  }
                                                  else{
                                                    setState(() {
                                                      likeButton = true;
                                                    });
                                                    likedBy![_auth.currentUser!.uid] = true;
                                                    FirebaseFirestore.instance
                                                        .collection('posts')
                                                        .doc(data.docs[index].reference.id)
                                                        .update({
                                                      'likedBy' : likedBy,
                                                      'totalLikes' : totalLikes + 1,
                                                    });
                                                    if(data.docs[index]['type'] == 'Home'){
                                                      FirebaseFirestore.instance
                                                          .collection('analytics')
                                                          .doc(adminUid).update({
                                                        'Home' : home + 1,
                                                      });
                                                    }
                                                    else if(data.docs[index]['type'] == 'Work'){
                                                      FirebaseFirestore.instance
                                                          .collection('analytics')
                                                          .doc(adminUid).update({
                                                        'Work' : work + 1,
                                                      });
                                                    }
                                                    else{
                                                      FirebaseFirestore.instance
                                                          .collection('analytics')
                                                          .doc(adminUid).update({
                                                        'School' : school + 1,
                                                      });
                                                    }
                                                  }
                                                }
                                                else{
                                                  setState(() {
                                                    likeButton = true;
                                                  });
                                                  likedBy![_auth.currentUser!.uid] = true;
                                                  FirebaseFirestore.instance
                                                      .collection('posts')
                                                      .doc(data.docs[index].reference.id)
                                                      .update({
                                                    'likedBy' : likedBy,
                                                    'totalLikes' : totalLikes + 1,
                                                  });
                                                  if(data.docs[index]['type'] == 'Home'){
                                                    FirebaseFirestore.instance
                                                        .collection('analytics')
                                                        .doc(adminUid).update({
                                                      'Home' : home + 1,
                                                    });
                                                  }
                                                  else if(data.docs[index]['type'] == 'Work'){
                                                    FirebaseFirestore.instance
                                                        .collection('analytics')
                                                        .doc(adminUid).update({
                                                      'Work' : work + 1,
                                                    });
                                                  }
                                                  else{
                                                    FirebaseFirestore.instance
                                                        .collection('analytics')
                                                        .doc(adminUid).update({
                                                      'School' : school + 1,
                                                    });
                                                  }
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
  Widget buildAnalytics(BuildContext context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('analytics')
            .doc(adminUid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var analysis = snapshot.data.data();
            if(analysis != null){
              home = analysis['Home'];
              work = analysis['Work'];
              school = analysis['School'];
            }
            return Container();
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
