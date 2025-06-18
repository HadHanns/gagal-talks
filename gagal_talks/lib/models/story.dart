import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  final String id;
  final String content;
  final String? username;
  final bool isAnonymous;
  final DateTime date;

  Reply({
    required this.id,
    required this.content,
    this.username,
    required this.isAnonymous,
    required this.date,
  });

  factory Reply.fromMap(Map<String, dynamic> map, String id) {
    try {
      return Reply(
        id: id,
        content: map['content'] ?? '',
        username: map['username'],
        isAnonymous: map['isAnonymous'] ?? false,
        date: map['date'] != null 
            ? (map['date'] is Timestamp 
                ? (map['date'] as Timestamp).toDate()
                : DateTime.parse(map['date'].toString()))
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing reply with id $id: $e');
      print('Reply data: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'username': username,
      'isAnonymous': isAnonymous,
      'date': date,
    };
  }
}

class Story {
  final String id;
  final String title;
  final String content;
  final String lesson;
  final String category;
  final bool isAnonymous;
  final String? username;
  final DateTime date;
  int likes;
  final List<Reply> replies;
  final int replyCount;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.lesson,
    required this.category,
    required this.isAnonymous,
    this.username,
    required this.date,
    this.likes = 0,
    this.replies = const [],
    this.replyCount = 0,
  });

  factory Story.fromMap(Map<String, dynamic> map, String id) {
    try {
      return Story(
        id: id,
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        lesson: map['lesson'] ?? '',
        category: map['category'] ?? '',
        isAnonymous: map['isAnonymous'] ?? false,
        username: map['username'],
        date: map['date'] != null 
            ? (map['date'] is Timestamp 
                ? (map['date'] as Timestamp).toDate()
                : DateTime.parse(map['date'].toString()))
            : DateTime.now(),
        likes: map['likes'] ?? 0,
        replies: (map['replies'] as List<dynamic>?)?.map((reply) {
          try {
            return Reply.fromMap(reply as Map<String, dynamic>, reply['id']?.toString() ?? '');
          } catch (e) {
            print('Error parsing reply: $e');
            return null;
          }
        }).whereType<Reply>().toList() ?? [],
        replyCount: map['replyCount'] ?? 0,
      );
    } catch (e) {
      print('Error parsing story with id $id: $e');
      print('Story data: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'lesson': lesson,
      'category': category,
      'isAnonymous': isAnonymous,
      'username': username,
      'date': date,
      'likes': likes,
      'replyCount': replyCount,
    };
  }
} 