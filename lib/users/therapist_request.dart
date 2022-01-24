import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/components/show_toast.dart';
import 'package:maisha/components/square_button.dart';

import '../constant.dart';

class TherapistRequest extends StatefulWidget {
  const TherapistRequest({Key? key}) : super(key: key);
  static String id = 'therapist_request';

  @override
  _TherapistRequestState createState() => _TherapistRequestState();
}

class _TherapistRequestState extends State<TherapistRequest> {
  final Stream<QuerySnapshot> therapists = FirebaseFirestore
      .instance.collection('users')
      .where('role', isEqualTo: 'Therapist')
      .snapshots();
  final _auth = FirebaseAuth.instance;
  Map ? requests;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Available Therapist',
                style: GoogleFonts.aclonica(
                    color: kPrimaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const Divider(
            color: kPrimaryColor,
            height: 20,
          ),
          StreamBuilder(
            stream: therapists,
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  final data = snapshot.requireData;
                  return ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: size.height * 0.7,
                        width: size.width
                      ),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.size,
                        itemBuilder: (context, i){
                          requests = data.docs[i]['request'];
                          return Column(
                            children: [
                              Card(
                                shadowColor: Colors.grey,
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Dr ${data.docs[i]['username']}',
                                            style: GoogleFonts.acme(
                                              textStyle:const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Patients ${data.docs[i]['patients']}/4',
                                            style: GoogleFonts.aladin(
                                              textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          requests!.containsKey(_auth.currentUser!.uid)
                                              ? SquareButton(
                                              label: 'Request Sent',
                                              color: Colors.grey,
                                              onPressed: (){
                                                null;
                                              }
                                          ) : SquareButton(
                                            label:'Request',
                                            color: Colors.green,
                                            onPressed: () async{
                                                requests![_auth.currentUser!.uid] = true;
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(data.docs[i].reference.id)
                                                    .update({
                                                  'request' : requests,
                                                }).then((value) {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(data.docs[i].reference.id)
                                                      .collection('requests')
                                                      .doc(_auth.currentUser!.uid)
                                                      .set({
                                                    'sender' : _auth.currentUser!.uid,
                                                    'receiver' : data.docs[i].reference.id,
                                                  });
                                                  showToast(
                                                    message: 'Request sent successfully',
                                                    color: Colors.green,
                                                  );
                                                  setState(() {
                                                    requests![_auth.currentUser!.uid] = true;
                                                  });
                                                });
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
              },
          ),
        ],
      ),
    );
  }
}