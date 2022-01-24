import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/components/message_bubble.dart';

import '../constant.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String ? messageText;
  String ? therapist;

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
                    .doc(_auth.currentUser!.uid)
                    .snapshots(),
                  builder: (context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      therapist = snapshot.data['therapist'];
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(therapist)
                            .collection('messages')
                            .where('uid', isEqualTo: _auth.currentUser!.uid)
                            .orderBy('ts', descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snap){
                          if(snap.hasData){
                            final messages = snap.requireData;
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
                                    if(messages.docs[index]['uid'] == _auth.currentUser!.uid){
                                      return MessageBubble(
                                        isMe: messageSender == _auth.currentUser!.email,
                                        sender:isMe ? 'Me' : messageSender,
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
                        },
                      );
                    }
                    return Column();
                  }
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
                              .doc(therapist)
                              .collection('messages')
                              .doc().set({
                            'uid' : _auth.currentUser!.uid,
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
