import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  Future<bool> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        return true; // ล็อกอินสำเร็จ
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'อีเมลนี้ถูกลงทะเบียนแล้ว';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'รูปแบบอีเมลไม่ถูกต้อง';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'รหัสผ่านไม่ถูกต้อง';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'ไม่พบผู้ใช้ที่ตรงกับอีเมลนี้';
      } else {
        errorMessage = 'การลงทะเบียนล้มเหลว กรุณาลองอีกครั้ง';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    return false; // ล็อกอินล้มเหลว
  }
}
