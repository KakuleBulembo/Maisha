import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<String, double> ? dataMap;
  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            'What\'s mostly youth face the most',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
              fontSize: 27,
            ),
          ),
        ),
        const Divider(
          height: 30,
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('analytics')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
            builder: (context, AsyncSnapshot snapshot){
            dataMap ={
              "Home": snapshot.data.data()['Home'].toDouble(),
              "School": snapshot.data.data()['School'].toDouble(),
              "Work": snapshot.data.data()['Work'].toDouble(),
            };
              return PieChart(
                dataMap: dataMap!,
                animationDuration:const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: "Depression",
                legendOptions:const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions:const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
                // gradientList: ---To add gradient colors---
                // emptyColorGradient: ---Empty Color gradient---
              );
            }
        ),
      ],
    );
  }
}
