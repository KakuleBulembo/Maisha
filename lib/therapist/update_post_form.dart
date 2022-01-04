import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maisha/components/post_input_field.dart';
import 'package:maisha/components/post_type.dart';
import 'package:maisha/components/rounded_view_button.dart';
import 'package:maisha/components/show_toast.dart';

import '../constant.dart';

class UpdatePostForm extends StatefulWidget {
  const UpdatePostForm({
    Key? key,
    required this.post,
  }) : super(key: key);
  final DocumentSnapshot post;

  @override
  _UpdatePostFormState createState() => _UpdatePostFormState();
}

class _UpdatePostFormState extends State<UpdatePostForm> {
  String ? title;
  String ? body;
  String ? type;
  bool showSpinner = false;
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
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: Text(
              'Update Post'.toUpperCase(),
              style:const TextStyle(
                color: kPrimaryLightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body:Padding(
            padding:const EdgeInsets.only(
              top: 40,
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').doc(widget.post.reference.id).snapshots(),
                builder: (context,AsyncSnapshot snapshot){
                   if(snapshot.hasData){
                     final posts = snapshot.data!.data();
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         PostInputField(
                           initialValue: posts['title'],
                             label: 'Title*',
                             hintText: 'Enter Title',
                             maxLines: 1,
                             minLines: 1,
                             onChanged: (value){
                               title = value;
                             }
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
                             initialValue: posts['body'],
                               label: 'Body*',
                               hintText: 'Enter Body',
                               maxLines: 7,
                               minLines: 4,
                               onChanged: (value){
                                 body = value;
                               }
                           ),
                         ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedViewDetailsButton(
                                title: 'Upload',
                                color: Colors.purple.withOpacity(0.7),
                                onPressed: () async{
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  await FirebaseFirestore.instance.collection('posts').doc(widget.post.reference.id).update({
                                    'title' : title,
                                    'body' : body,
                                    'type' : type,
                                    'ts' : DateTime.now(),
                                  }).then((value) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              RoundedViewDetailsButton(
                                title: 'Delete',
                                color: kPrimaryColor,
                                onPressed: () async{
                                  setState(() {
                                    showSpinner = true;
                                  });
                                   await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async{
                                     myTransaction.delete(widget.post.reference);
                                   }).then((value) {
                                     setState(() {
                                       showSpinner = false;
                                     });
                                     showToast(
                                         message: 'Post Deleted Successfully',
                                         color: Colors.green,
                                     );
                                     Navigator.pop(context);
                                   });
                                },
                              ),
                            ],
                          ),
                        ),
                         Container(
                           height: 150,
                           width: MediaQuery.of(context).size.width,
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
                     );
                   }
                   else{
                     return Container();
                   }
                }
            ),
          ),
        ),
    );
  }
}
