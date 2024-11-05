import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syncspace/resource/auth_method.dart';
import 'package:syncspace/screens/home_screen.dart';
import 'package:syncspace/screens/login_screens.dart';
import 'package:syncspace/screens/video_call_screen.dart';
import './utils/colours.dart' show backgroundColor;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Android
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: " ", //add key
      appId: "1:344977288597:android:09e879dcf25cb8b122da9c",
      messagingSenderId: "344977288597",
      projectId: "syncspace-e7abf",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/video-call': (context) => const VideoCallScreen(),
      },
      home: StreamBuilder(
        stream: AuthMethods().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
