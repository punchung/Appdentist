import 'dart:io';
import 'package:flutter/material.dart';
import 'login.dart';
//import 'home.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions( //อันนี้เพิ่มมาเพราะรันบนchorm แต่ถ้ารันในแอนดรอยปกติไม่ต้องเติม
      apiKey: 'AIzaSyB31s9Jz5jjmuupvZ8FD4Kh5W6jFmcnXpI',
      appId: '1:248546510242:android:b4fc3c243a19d18d7edefb',
      messagingSenderId: '',
      projectId: 'appdentist-82883',
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Kanit',  // กำหนดฟอนต์เริ่มต้นเป็น Kanit
        useMaterial3: true,
      ),
      home:MyHomePage (), // หน้าเริ่มต้นของแอป
    );
  }
}

