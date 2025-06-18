import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
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

  Future<void> addReply(String storyId, Reply reply) async {
    final storyRef = _firestore.collection(_collection).doc(storyId);
    final storyDoc = await storyRef.get();
    
    if (storyDoc.exists) {
      final story = Story.fromMap(storyDoc.data()!, storyDoc.id);
      final updatedReplies = [...story.replies, reply];
      
      await storyRef.update({
        'replies': updatedReplies.map((r) => r.toMap()).toList(),
      });
    }
  }

  Future<void> likeReply(String storyId, String replyId) async {
    final storyRef = _firestore.collection(_collection).doc(storyId);
    final storyDoc = await storyRef.get();
    
    if (storyDoc.exists) {
      final story = Story.fromMap(storyDoc.data()!, storyDoc.id);
      final updatedReplies = story.replies.map((reply) {
        if (reply.id == replyId) {
          return Reply(
            id: reply.id,
            content: reply.content,
            isAnonymous: reply.isAnonymous,
            date: reply.date,
            likes: reply.likes + 1,
          );
        }
        return reply;
      }).toList();
      
      await storyRef.update({
        'replies': updatedReplies.map((r) => r.toMap()).toList(),
      });
    }
  }
} 