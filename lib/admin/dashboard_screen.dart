import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maisha/admin/create_therapist.dart';
import 'package:maisha/auth/login_screen.dart';
import 'package:maisha/components/add_button.dart';
import 'package:maisha/components/background.dart';

import '../constant.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size ? size = MediaQuery.of(context).size;
    final _therapists = FirebaseFirestore.instance;
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      child: Background(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  'Admin Dashboard',
                  style: TextStyle(
                      color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                AddButton(
                    title: 'Therapist',
                    addLabel: 'Add Therapist',
                    onPressed: (){
                      Navigator.pushNamed(context, CreateTherapist.id);
                    }
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SvgPicture.asset(
                  'assets/icons/signup.svg',
                  height: size.height * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _therapists.collection('users').orderBy('ts', descending: true).snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData){
                          final therapistDetails = snapshot.data!.docs;
                          List<DataRow> therapistData = [];
                          for(var therapistDetail in therapistDetails){
                            if(therapistDetail.data()['role'] == 'Therapist'){
                              final therapistName = therapistDetail.data()['username'];
                              final therapistEmail = therapistDetail.data()['email'];
                              final therapist = DataRow(
                                  cells: [
                                    DataCell(
                                      Text(therapistName, style:const TextStyle(color: kPrimaryColor),)
                                    ),
                                    DataCell(
                                        Text(therapistEmail, style:const TextStyle(color: kPrimaryColor),)
                                    ),
                                  ]
                              );
                              therapistData.add(therapist);
                            }
                          }
                            return DataTable(
                                columns:const [
                                   DataColumn(
                                    label: Text('Username', style:TextStyle(color: kPrimaryColor),),
                                  ),
                                  DataColumn(
                                    label: Text('Email', style: TextStyle(color: kPrimaryColor),),
                                  )
                                ],
                                rows: List.generate(
                                    therapistData.length,
                                        (index) => therapistData[index],
                                ),
                            );

                        }
                        else{
                          return const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.purple)
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),

      ),
    );
  }
}
