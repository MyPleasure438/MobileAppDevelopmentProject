import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:practical_assignment_project/taskbar.dart';
import 'firebase_options.dart';

// Import your pages barrel file
import 'widgets/widgets.dart';
import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Taskbar(), // Start at your login page
    );
  }
}

