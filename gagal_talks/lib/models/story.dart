import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String title;
  final String content;
  final String lesson;
  final String category;
  final bool isAnonymous;
  final DateTime date;
  int likes;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.lesson,
    required this.category,
    required this.isAnonymous,
    required this.date,
    this.likes = 0,
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
    };
  }
} 