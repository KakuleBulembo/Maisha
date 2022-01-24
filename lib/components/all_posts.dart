import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/posts.dart';


class AllPosts extends StatefulWidget {
  const AllPosts({Key? key}) : super(key: key);

  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .orderBy('totalLikes', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Posts(post: posts);
  }
}
