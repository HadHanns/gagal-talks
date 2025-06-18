import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LikedStoriesManager {
  static final LikedStoriesManager _instance = LikedStoriesManager._internal();
  factory LikedStoriesManager() => _instance;
  LikedStoriesManager._internal();

  static LikedStoriesManager get instance => _instance;

  static const String _likedStoriesKey = 'liked_stories';

  Future<List<String>> getLikedStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedStoriesJson = prefs.getString(_likedStoriesKey);
      if (likedStoriesJson != null) {
        final List<dynamic> decoded = jsonDecode(likedStoriesJson);
        return decoded.cast<String>();
      }
    } catch (e) {
      print('Error loading liked stories: $e');
    }
    return [];
  }

  Future<void> addLikedStory(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedStories = await getLikedStories();
      if (!likedStories.contains(storyId)) {
        likedStories.add(storyId);
        await prefs.setString(_likedStoriesKey, jsonEncode(likedStories));
      }
    } catch (e) {
      print('Error adding liked story: $e');
    }
  }

  Future<void> removeLikedStory(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedStories = await getLikedStories();
      likedStories.remove(storyId);
      await prefs.setString(_likedStoriesKey, jsonEncode(likedStories));
    } catch (e) {
      print('Error removing liked story: $e');
    }
  }

  Future<void> toggleLikedStory(String storyId) async {
    final likedStories = await getLikedStories();
    if (likedStories.contains(storyId)) {
      await removeLikedStory(storyId);
    } else {
      await addLikedStory(storyId);
    }
  }
} 