import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/posts.dart';

class SchoolPosts extends StatefulWidget {
  const SchoolPosts({Key? key}) : super(key: key);

  @override
  _SchoolPostsState createState() => _SchoolPostsState();
}

class _SchoolPostsState extends State<SchoolPosts> {
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .where('type', isEqualTo: 'School')
      .orderBy('totalLikes', descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Posts(post: posts);
  }
}
