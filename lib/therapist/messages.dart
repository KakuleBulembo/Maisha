import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/components/show_dialog.dart';
import 'package:maisha/therapist/chats.dart';

import '../constant.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);
  static String id = 'messages';

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Map ? session;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Messages'.toUpperCase(),
          style:GoogleFonts.acme(
            textStyle:const TextStyle(
              fontSize: 20,
              color: kPrimaryLightColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
              builder: (context, AsyncSnapshot snapshot){
                   return StreamBuilder(
                     stream: FirebaseFirestore.instance
                         .collection('users')
                         .where('role', isEqualTo: 'User')
                         .snapshots(),
                       builder: (context, AsyncSnapshot snap){
                          if(snap.hasData){
                            final users = snap.requireData;
                            return ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                width: size.width,
                                height: size.width * 1.2,
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: users.size,
                                  itemBuilder: (context, index){
                                    if(snapshot.data['session'].containsKey(users.docs[index].reference.id) && users.docs[index]['session'] == true){
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Divider(
                                            height: 20,
                                            color: kPrimaryColor,
                                          ),
                                          GestureDetector(
                                            onLongPress: () async{
                                              await FirebaseFirestore.instance.collection('users')
                                                  .doc(users.docs[index].reference.id)
                                                  .update({
                                                'session' : false,
                                              });
                                              Navigator.pop(context);
                                            },
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                                return Chats(userId: users.docs[index].reference.id);
                                              }));
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    users.docs[index]['username'],
                                                  style: GoogleFonts.acme(
                                                    textStyle:const TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    else{
                                      return Container();
                                    }
                                  }
                              ),
                            );
                          }
                          return Container();
                       }
                   );
              },
          ),
        ],
      ),
    );
  }
}
