import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/story.dart';
import '../providers/story_provider.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _lesson = '';
  String _category = 'Love';
  bool _isAnonymous = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Love', 'Career', 'Study', 'Startup'
  ];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      final newStory = Story(
        id: const Uuid().v4(),
        title: _title,
        content: _content,
        lesson: _lesson,
        category: _category,
        isAnonymous: _isAnonymous,
        date: DateTime.now(),
      );
      try {
        await context.read<StoryProvider>().addStory(newStory);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add story. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Your Story')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                onSaved: (val) => _content = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Enter your story' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lesson Learned'),
                onSaved: (val) => _lesson = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Enter a lesson' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? 'Love'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Post as Anonymous'),
                value: _isAnonymous,
                onChanged: (val) => setState(() => _isAnonymous = val),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
} 