import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maisha/components/posts.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final Stream<QuerySnapshot> posts = FirebaseFirestore
      .instance.collection('posts')
      .where('likedBy.${FirebaseAuth.instance.currentUser!.uid}', isEqualTo: true)
      .orderBy('ts', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Posts(post: posts);
  }
}
