import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_mobile_page/Screen/homepage.dart';
import 'package:login_mobile_page/Screen/videopage.dart';


import 'model/videoelement.dart';

List<VideosElement> videoElement = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:HomePgae(),
    );
  }
}
