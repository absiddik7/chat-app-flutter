import 'package:flutter/material.dart';
import 'dart:io';
import 'package:messenger/loginUI/login.dart';
import 'package:firebase_core/firebase_core.dart';

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      // title: 'Messenger',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: LoginScreen(),
    );
  }
}