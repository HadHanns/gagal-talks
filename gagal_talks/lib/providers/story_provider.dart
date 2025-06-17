import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final String _collection = 'stories';

  Stream<List<Story>> get storiesStream {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Story.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addStory(Story story) async {
    await _firestore.collection(_collection).add(story.toMap());
  }
} 