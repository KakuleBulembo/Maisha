import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maisha/components/post_input_field.dart';
import 'package:maisha/components/post_type.dart';
import 'package:maisha/components/rounded_button.dart';
import 'package:maisha/components/show_toast.dart';
import 'package:maisha/constant.dart';


class CreatePostForm extends StatefulWidget {
  const CreatePostForm({Key? key}) : super(key: key);
  static String id = 'create_post_form';

  @override
  _CreatePostFormState createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  String ? type;
  String ? title;
  String ? body;
  bool showSpinner = false;
  String ? selectedType;

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for(String type in postType){
      pickerItems.add(Text(type));
    }
    return CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex){
          setState(() {
            type = postType[selectedIndex];
          });
        },
        children: pickerItems
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: showSpinner,
      opacity: 0.5,
      color: kPrimaryColor,
      progressIndicator:const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            'Create Post'.toUpperCase(),
            style:const TextStyle(
                color: kPrimaryLightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostInputField(
                label: 'Title*',
                hintText: 'Enter Title',
                maxLines: 1,
                minLines: 1,
                onChanged: (value){
                  title = value;
                },
              ),

              GestureDetector(
                onTap:  () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                },
                child: PostInputField(
                    label: 'Body*',
                    hintText: 'Enter Body',
                    maxLines: 7,
                    minLines: 4,
                    onChanged: (value){
                      body = value;
                    }
                ),
              ),
             RoundedButton(
                 label: 'Create Post',
                 color: Colors.purple,
                 onPressed: () async{
                   setState(() {
                     showSpinner = true;
                     selectedType = type;
                   });
                   User ? currentUser = FirebaseAuth.instance.currentUser;
                   await FirebaseFirestore.instance.collection('posts').doc().set({
                     'uid' : currentUser!.uid,
                     'title' : title,
                     'body' : body,
                     'totalLikes' : 0,
                     'type' : selectedType,
                     'ts' : DateTime.now(),
                   }).then((value) {
                     showToast(
                         message: 'Post added successfully',
                         color: Colors.green,
                     );
                     Navigator.pop(context);
                     setState(() {
                       showSpinner = false;
                     });
                   });
                 }
             ),
             Container(
               height: 150,
               alignment: Alignment.center,
               padding: const EdgeInsets.only(bottom: 30),
               color: Colors.purple,
               child: CupertinoTheme(
                 data:const CupertinoThemeData(
                   textTheme: CupertinoTextThemeData(
                     pickerTextStyle: TextStyle(
                       color: kPrimaryLightColor,
                       fontSize: 20,
                       fontWeight: FontWeight.bold
                     )
                   )
                 ),
                   child: iOSPicker(),
               ),
             ),
            ],
          ),
        ),
      ),
    );
  }
}
