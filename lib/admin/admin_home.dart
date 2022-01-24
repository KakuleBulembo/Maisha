import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').orderBy('ts', descending: true).snapshots(),
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
    );
  }
}
