import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/components/show_toast.dart';
import 'package:maisha/components/square_button.dart';
import 'package:maisha/constant.dart';

class NotificationBuilder extends StatefulWidget {
  const NotificationBuilder({Key? key}) : super(key: key);

  @override
  _NotificationBuilderState createState() => _NotificationBuilderState();
}

class _NotificationBuilderState extends State<NotificationBuilder> {
  final Stream<QuerySnapshot> request = FirebaseFirestore
      .instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('requests')
      .snapshots();
  final Stream<DocumentSnapshot<Map<String, dynamic>>> totalPatients = FirebaseFirestore
      .instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  String ? userId;
  Map ? session;
  Map ? requests;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: request,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                final data = snapshot.requireData;
                return StreamBuilder(
                  stream: totalPatients,
                    builder: (context, AsyncSnapshot snap){
                       return ConstrainedBox(
                         constraints: BoxConstraints.tightFor(
                           width: size.width,
                           height: size.width * 1.2,
                         ),
                         child: ListView.builder(
                             scrollDirection: Axis.vertical,
                             shrinkWrap: true,
                             itemCount: data.size,
                             itemBuilder: (context, index){
                               userId = data.docs[index].reference.id;
                               session = snap.data['session'];
                               requests = snap.data['request'];
                               return Padding(
                                 padding: const EdgeInsets.only(
                                   right: 10,
                                   left: 10,
                                 ),
                                 child: Card(
                                   shadowColor: Colors.grey,
                                   elevation: 10.0,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                   child: Padding(
                                     padding: const EdgeInsets.all(20.0),
                                     child: Column(
                                       children: [
                                         Text(
                                           'Session Request',
                                           style: GoogleFonts.acme(
                                             textStyle:const TextStyle(
                                               fontSize: 20,
                                               color: Colors.black,
                                               fontWeight: FontWeight.bold,
                                             ),
                                           ),
                                         ),
                                         const Divider(
                                           color: kPrimaryColor,
                                           height: 20,
                                         ),
                                         buildNotification(context),
                                         const SizedBox(
                                           height: 20,
                                         ),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             SquareButton(
                                               label: 'Confirm',
                                               color: Colors.green,
                                               onPressed: () async{
                                                 session![data.docs[index].reference.id] = true;
                                                 requests![data.docs[index].reference.id] = false;
                                                 await FirebaseFirestore.instance
                                                     .collection('users')
                                                     .doc(FirebaseAuth.instance.currentUser!.uid)
                                                     .update({
                                                   'session' : session,
                                                   'request' : requests,
                                                 }).then((value) {
                                                   DocumentReference documentReference = FirebaseFirestore.instance
                                                       .collection('users')
                                                       .doc(FirebaseAuth.instance.currentUser!.uid)
                                                       .collection('requests')
                                                       .doc(data.docs[index].reference.id);
                                                   FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                                                     transaction.delete(documentReference);
                                                   }).then((value) {
                                                     FirebaseFirestore.instance
                                                         .collection('users')
                                                         .doc(FirebaseAuth.instance.currentUser!.uid)
                                                         .update({
                                                       'patients' : snap.data['patients'] + 1,
                                                     });
                                                     FirebaseFirestore.instance
                                                         .collection('users')
                                                         .doc(data.docs[index].reference.id)
                                                         .update({
                                                       'session' : true,
                                                       'therapist' : FirebaseAuth.instance.currentUser!.uid,
                                                     });
                                                     showToast(
                                                         message: 'Request Accepted',
                                                         color: Colors.green
                                                     );
                                                   });
                                                 });
                                               },
                                             ),
                                             SquareButton(
                                               label: 'Cancel',
                                               color: Colors.red,
                                               onPressed: (){
                                                 requests![data.docs[index].reference.id] = false;
                                                 DocumentReference documentReference = FirebaseFirestore.instance
                                                     .collection('users')
                                                     .doc(FirebaseAuth.instance.currentUser!.uid)
                                                     .collection('requests')
                                                     .doc(data.docs[index].reference.id);
                                                 FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                                                   transaction.delete(documentReference);
                                                 }).then((value) {
                                                   FirebaseFirestore.instance
                                                       .collection('users')
                                                       .doc(FirebaseAuth.instance.currentUser!.uid)
                                                       .update({
                                                     'request' : requests,
                                                   });
                                                   showToast(
                                                       message: 'Request Cancelled',
                                                       color: Colors.green
                                                   );
                                                 });
                                               },
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                             }
                         ),
                       );
                    }
                );
              }
              return Container();
            }
        ),
      ],
    );
  }
  Widget buildNotification(context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            var userDocument = snapshot.data.data();
            return Text(
              '${userDocument['username']} has requested a session',
              style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.7),
                  ),
              ),
            );
          }
          return Container();
        }
    );
  }
}
