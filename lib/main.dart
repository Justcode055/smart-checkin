import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/db/database_helper.dart';
import 'firebase_options.dart';

// Import sqflite based on platform
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize sqflite for FFI (required for desktop/web support)
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
                   defaultTargetPlatform == TargetPlatform.linux ||
                   defaultTargetPlatform == TargetPlatform.macOS)) {
    sqflite_ffi.sqfliteFfiInit();
  }
  
  // Initialize database on mobile/desktop platforms
  if (!kIsWeb) {
    try {
      await DatabaseHelper().database;
      debugPrint('✓ Database initialized successfully');
    } catch (e) {
      debugPrint('✗ Database initialization error: $e');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Class Check-in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
