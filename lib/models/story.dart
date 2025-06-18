import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  final String id;
  final String content;
  final bool isAnonymous;
  final DateTime date;
  int likes;

  Reply({
    required this.id,
    required this.content,
    required this.isAnonymous,
    required this.date,
    this.likes = 0,
  });

  factory Reply.fromMap(Map<String, dynamic> map, String id) {
    return Reply(
      id: id,
      content: map['content'] ?? '',
      isAnonymous: map['isAnonymous'] ?? false,
      date: (map['date'] as Timestamp).toDate(),
      likes: map['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isAnonymous': isAnonymous,
      'date': date,
      'likes': likes,
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
  final DateTime date;
  int likes;
  List<Reply> replies;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.lesson,
    required this.category,
    required this.isAnonymous,
    required this.date,
    this.likes = 0,
    this.replies = const [],
  });

  factory Story.fromMap(Map<String, dynamic> map, String id) {
    return Story(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      lesson: map['lesson'] ?? '',
      category: map['category'] ?? '',
      isAnonymous: map['isAnonymous'] ?? false,
      date: (map['date'] as Timestamp).toDate(),
      likes: map['likes'] ?? 0,
      replies: (map['replies'] as List<dynamic>? ?? [])
          .map((reply) => Reply.fromMap(reply as Map<String, dynamic>, reply['id'] as String))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'lesson': lesson,
      'category': category,
      'isAnonymous': isAnonymous,
      'date': date,
      'likes': likes,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }
} 