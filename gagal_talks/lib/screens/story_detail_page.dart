import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryDetailPage extends StatelessWidget {
  final Story story;
  const StoryDetailPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(story.category),
                  backgroundColor: Colors.orange.shade50,
                ),
                const SizedBox(width: 12),
                Text(
                  '${story.date.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              story.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Lesson Learned:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              story.lesson,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login required to like')),
                    );
                  },
                  color: Colors.grey,
                ),
                Text('${story.likes}'),
                const SizedBox(width: 16),
                if (!story.isAnonymous)
                  const Icon(Icons.person, size: 20, color: Colors.blueGrey),
                if (!story.isAnonymous)
                  const Text('Shared by User'),
                if (story.isAnonymous)
                  const Text('Anonymous', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 