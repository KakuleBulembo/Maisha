import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/posts.dart';

class HomePosts extends StatefulWidget {
  const HomePosts({Key? key}) : super(key: key);

  @override
  _HomePostsState createState() => _HomePostsState();
}

class _HomePostsState extends State<HomePosts> {
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .where('type', isEqualTo: 'Home')
      .orderBy('totalLikes', descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Posts(post: posts);
  }
}
