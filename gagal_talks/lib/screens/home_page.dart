import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../models/story.dart';
import 'story_detail_page.dart';
import 'add_story_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gagal Talks'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Story>>(
        stream: storyProvider.storiesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading stories'));
          }
          final stories = snapshot.data ?? [];
          if (stories.isEmpty) {
            return const Center(child: Text('No stories yet. Be the first to share!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(story.title),
                  subtitle: Text(
                    story.content.length > 60
                        ? story.content.substring(0, 60) + '...'
                        : story.content,
                  ),
                  trailing: Chip(
                    label: Text(story.category),
                    backgroundColor: Colors.orange.shade50,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryDetailPage(story: story),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStoryPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Share Story'),
      ),
    );
  }
} 