import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/therapist/update_post_form.dart';
import 'package:readmore/readmore.dart';

import '../constant.dart';

class TherapistProfile extends StatefulWidget {
  const TherapistProfile({Key? key}) : super(key: key);

  @override
  _TherapistProfileState createState() => _TherapistProfileState();
}
class _TherapistProfileState extends State<TherapistProfile> {
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .orderBy('ts', descending: true)
      .snapshots();
  String ? authorID;
  bool likeButton = false;
  int totalLikes = 0;
  Color ? likeButtonColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Column(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: posts,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                final data = snapshot.requireData;
                return ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: size.width,
                    height: size.width,
                  ),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.size,
                      itemBuilder:  (context, index){
                        authorID = data.docs[index]['uid'];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                                  return UpdatePostForm(post: data.docs[index]);
                                                }));
                                              },
                                              child: Text(
                                                data.docs[index]['title'] ?? '',
                                                style:const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
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
                                        children:  [
                                          Text(
                                            data.docs[index]['totalLikes'].toString(),
                                            style:const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: Divider(
                                height: 10,
                                color: kPrimaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: ReadMoreText(
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
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 10,
                              width: size.width,
                              color: Colors.purple.withOpacity(0.07),
                              child:const Text(''),
                            ),
                          ],
                        );
                      }
                  ),
                );
              }
              return Center(
                child: Text(
                  'No Post',
                  style: GoogleFonts.acme(
                      textStyle:const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      )
                  ),
                ),
              );
            }
        ),
      ],
    );
  }

}
