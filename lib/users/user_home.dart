import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maisha/components/all_posts.dart';
import 'package:maisha/components/home_posts.dart';
import 'package:maisha/components/school_posts.dart';
import 'package:maisha/components/work_posts.dart';


class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int index = 0;
  String dropDownValue = 'All';
  List<String> spinnerItems = [
    'All',
    'School',
    'Home',
    'Work'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: Row(
            children: [
              DropdownButton(
                value: dropDownValue,
                  icon:const Icon(Icons.arrow_drop_down),
                  iconSize: 25,
                  elevation: 16,
                  style: GoogleFonts.acme(
                    textStyle: const TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                    ),
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String ? val){
                     setState(() {
                       dropDownValue = val!;
                     });
                  },
                  items: spinnerItems.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem(
                      value: value,
                        child: Text(value),
                    );
                  }).toList(),
              ),
            ],
          ),
        ),
        if(dropDownValue == 'All')
          const AllPosts(),
        if(dropDownValue == 'School')
          const SchoolPosts(),
        if(dropDownValue == 'Home')
          const HomePosts(),
        if(dropDownValue == 'Work')
          const WorkPosts(),
      ],
    );
  }

}
