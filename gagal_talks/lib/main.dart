import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/story_provider.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GagalTalksApp());
}

class GagalTalksApp extends StatelessWidget {
  const GagalTalksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryProvider(),
      child: MaterialApp(
        title: 'Gagal Talks',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.light,
            primary: Colors.orange.shade400,
            secondary: Colors.blue.shade200,
            background: const Color(0xFFFFF8F0),
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
