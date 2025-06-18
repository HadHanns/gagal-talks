import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final String _collection = 'stories';
  final String _repliesCollection = 'replies';

  Stream<List<Story>> get storiesStream {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('date', descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
            try {
              final stories = <Story>[];
              for (final doc in snapshot.docs) {
                final storyData = doc.data();
                final storyId = doc.id;
                
                // Get replies for this story using real-time listener
                final repliesStream = _firestore
                    .collection(_repliesCollection)
                    .where('storyId', isEqualTo: storyId)
                    .snapshots();
                
                // Take the latest snapshot of replies
                final repliesSnapshot = await repliesStream.first;
                
                final replies = repliesSnapshot.docs
                    .map((replyDoc) => Reply.fromMap(replyDoc.data(), replyDoc.id))
                    .toList();
                
                // Sort replies by date in memory since we can't orderBy in the query
                replies.sort((a, b) => a.date.compareTo(b.date));
                
                // Create story with replies
                final story = Story(
                  id: storyId,
                  title: storyData['title'] ?? '',
                  content: storyData['content'] ?? '',
                  lesson: storyData['lesson'] ?? '',
                  category: storyData['category'] ?? '',
                  isAnonymous: storyData['isAnonymous'] ?? false,
                  username: storyData['username'],
                  date: storyData['date'] != null 
                      ? (storyData['date'] is Timestamp 
                          ? (storyData['date'] as Timestamp).toDate()
                          : DateTime.parse(storyData['date'].toString()))
                      : DateTime.now(),
                  likes: storyData['likes'] ?? 0,
                  replies: replies,
                  replyCount: storyData['replyCount'] ?? replies.length,
                );
                stories.add(story);
              }
              return stories;
            } catch (e) {
              print('Error parsing story data: $e');
              rethrow;
            }
          })
          .handleError((error) {
            print('Firestore stream error: $error');
            throw error;
          });
    } catch (e) {
      print('Error creating stories stream: $e');
      rethrow;
    }
  }

  // Get a specific story with real-time replies
  Stream<Story> getStoryStream(String storyId) {
    try {
      return _firestore
          .collection(_collection)
          .doc(storyId)
          .snapshots()
          .asyncMap((storyDoc) async {
            if (!storyDoc.exists) {
              throw Exception('Story not found');
            }
            
            final storyData = storyDoc.data()!;
            
            // Get replies for this story using real-time listener
            final repliesStream = _firestore
                .collection(_repliesCollection)
                .where('storyId', isEqualTo: storyId)
                .snapshots();
            
            // Take the latest snapshot of replies
            final repliesSnapshot = await repliesStream.first;
            
            final replies = repliesSnapshot.docs
                .map((replyDoc) => Reply.fromMap(replyDoc.data(), replyDoc.id))
                .toList();
            
            // Sort replies by date in memory since we can't orderBy in the query
            replies.sort((a, b) => a.date.compareTo(b.date));
            
            return Story(
              id: storyId,
              title: storyData['title'] ?? '',
              content: storyData['content'] ?? '',
              lesson: storyData['lesson'] ?? '',
              category: storyData['category'] ?? '',
              isAnonymous: storyData['isAnonymous'] ?? false,
              username: storyData['username'],
              date: storyData['date'] != null 
                  ? (storyData['date'] is Timestamp 
                      ? (storyData['date'] as Timestamp).toDate()
                      : DateTime.parse(storyData['date'].toString()))
                  : DateTime.now(),
              likes: storyData['likes'] ?? 0,
              replies: replies,
              replyCount: storyData['replyCount'] ?? replies.length,
            );
          })
          .handleError((error) {
            print('Firestore story stream error: $error');
            throw error;
          });
    } catch (e) {
      print('Error creating story stream: $e');
      rethrow;
    }
  }

  Future<void> addStory(Story story) async {
    try {
      await _firestore.collection(_collection).add(story.toMap());
    } catch (e) {
      print('Error adding story: $e');
      rethrow;
    }
  }

  Future<void> addReply(String storyId, Reply reply) async {
    try {
      // Add reply to separate collection
      final replyData = {
        'storyId': storyId,
        'content': reply.content,
        'username': reply.username,
        'isAnonymous': reply.isAnonymous,
        'date': reply.date,
      };
      
      await _firestore.collection(_repliesCollection).add(replyData);
      print('Reply added successfully for story: $storyId');
      
      // Increment replyCount in the story document
      await _firestore.collection(_collection).doc(storyId).update({
        'replyCount': FieldValue.increment(1),
      });
      // The stream will automatically update, so no need to call notifyListeners()
    } catch (e) {
      print('Error adding reply: $e');
      rethrow;
    }
  }

  Future<void> toggleLike(String storyId, bool isLiked) async {
    try {
      await _firestore.collection(_collection).doc(storyId).update({
        'likes': isLiked ? FieldValue.increment(1) : FieldValue.increment(-1),
      });
      print('Like toggled successfully for story: $storyId');
      
      // The stream will automatically update, so no need to call notifyListeners()
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }

  Future<void> deleteReply(String storyId, String replyId) async {
    try {
      // Delete the reply document
      await _firestore.collection(_repliesCollection).doc(replyId).delete();
      // Decrement replyCount in the story document
      await _firestore.collection(_collection).doc(storyId).update({
        'replyCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error deleting reply: $e');
      rethrow;
    }
  }

  Future<void> fixAllStoryReplyCounts() async {
    final stories = await _firestore.collection(_collection).get();
    for (final storyDoc in stories.docs) {
      final storyId = storyDoc.id;
      final repliesSnapshot = await _firestore
          .collection(_repliesCollection)
          .where('storyId', isEqualTo: storyId)
          .get();
      final replyCount = repliesSnapshot.docs.length;
      await _firestore.collection(_collection).doc(storyId).update({
        'replyCount': replyCount,
      });
      print('Updated $storyId with replyCount $replyCount');
    }
  }
} 