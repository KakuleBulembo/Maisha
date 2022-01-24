import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/posts.dart';

class WorkPosts extends StatefulWidget {
  const WorkPosts({Key? key}) : super(key: key);

  @override
  _WorkPostsState createState() => _WorkPostsState();
}

class _WorkPostsState extends State<WorkPosts> {
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
