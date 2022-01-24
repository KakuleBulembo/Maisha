import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/components/message_bubble.dart';

import '../constant.dart';

class Chats extends StatefulWidget {
  const Chats({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String ? messageText;
  String ? uid;
  getString(String val){
    print(val);
  }
  @override
  void initState() {
    // TODO: implement initState
    uid = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:Text(
          'Chats',
          style: GoogleFonts.aclonica(
            textStyle:const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: size.width,
                height: size.height * 0.75,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('messages')
                    .where('uid', isEqualTo: uid)
                    .orderBy('ts', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot){

                  if(snapshot.connectionState == ConnectionState.active) {
                     if(snapshot.hasData){
                       final messages = snapshot.requireData;
                       return ConstrainedBox(
                         constraints: BoxConstraints.tightFor(
                           width: size.width,
                           height: size.height * 0.75,
                         ),
                         child: ListView.builder(
                             reverse: true,
                             scrollDirection: Axis.vertical,
                             shrinkWrap: true,
                             itemCount: messages.size,
                             itemBuilder: (context, index){
                               final messageSender = messages.docs[index]['sender'];
                               bool isMe = (messages.docs[index]['sender'] == _auth.currentUser!.email);
                               if(messages.docs[index]['uid'] == uid){
                                 return MessageBubble(
                                   isMe: messageSender == _auth.currentUser!.email,
                                   sender: isMe ? 'Me' : messageSender,
                                   text: messages.docs[index]['message'],
                                 );
                               }
                               return Container();
                             }),
                       );
                     }
                     else{
                       return Container();
                     }
                  }
                  else{
                    return Container();
                  }
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Colors.purple,
                      controller: messageTextController,
                      onChanged: (value){
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if(messageText != null){
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser!.uid)
                              .collection('messages')
                              .doc().set({
                            'uid' : widget.userId,
                            'message' : messageText,
                            'sender' : _auth.currentUser!.email,
                            'ts' : DateTime.now(),
                          });
                          messageTextController.clear();
                        }
                        else{
                          null;
                        }
                      },
                      icon:const Icon(
                        IconData(0xe571, fontFamily: 'MaterialIcons', matchTextDirection: true),
                        color: Colors.purple,
                        size: 35,
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
