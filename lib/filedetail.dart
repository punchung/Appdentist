import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import '../database/database_helper.dart';
import '../database/model.dart' as appModel;

class FilesScreen extends StatelessWidget {
  final DatabaseHelper dbHelper;

  FilesScreen({Key? key, required this.dbHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ดึงผู้ใช้ที่ล็อกอินเข้ามาจาก FirebaseAuth
    final firebaseAuth.User? currentUser = firebaseAuth.FirebaseAuth.instance.currentUser;
    final String? email = currentUser?.email;

    print('Current user email: $email'); // ดีบักแสดงอีเมล

    if (email == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(child: Text('No user is logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('แฟ้มข้อมูลผู้ใช้'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: dbHelper.getUserByEmail(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No data found for this user'); // ดีบักเมื่อไม่พบข้อมูล
            return const Center(child: Text('No data found for this user'));
          }

          // ตรวจสอบข้อมูลที่ได้รับ
          final userData = snapshot.data!.docs.first.data();
          print('User data retrieved: $userData'); // ดีบักข้อมูลผู้ใช้

          // แปลงข้อมูลผู้ใช้
          final appModel.User iduser = appModel.User.fromMap(userData);

          // แสดงข้อมูลผู้ใช้
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('ชื่อ: ${iduser.name}', style: Theme.of(context).textTheme.headline6),
                Text('นามสกุล: ${iduser.lastname}', style: Theme.of(context).textTheme.subtitle1),
                Text('ชื่อเล่น: ${iduser.nickname}', style: Theme.of(context).textTheme.subtitle1),
                Text('วันเกิด: ${iduser.birthDate.toLocal().toString().split(' ')[0]}', style: Theme.of(context).textTheme.subtitle1),
                Text('เบอร์โทร: ${iduser.phonenumber}', style: Theme.of(context).textTheme.subtitle1),
                Text('อีเมล: ${iduser.email}', style: Theme.of(context).textTheme.subtitle1),
                // ข้อมูลอื่น ๆ ตามที่คุณต้องการแสดง
              ],
            ),
          );
        },
      ),
    );
  }
}
