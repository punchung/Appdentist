import 'package:app_dentist/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import '../database/auth.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart'; // เพิ่มการนำเข้า Firebase

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _email = '';
  String _passwd = '';
  final _formKey = GlobalKey<FormState>();

  Future _showAlert(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 212, 246, 255),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(
                Icons.local_hospital,
                size: 100,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              const Text(
                'LOGIN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                label: 'Email',
                hintText: 'กรอกอีเมลของคุณ',
                onChanged: (value) => setState(() {
                  _email = value;
                }),
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                label: 'รหัสผ่าน',
                hintText: 'กรอกรหัสผ่านของคุณ',
                obscureText: true,
                onChanged: (value) => setState(() {
                  _passwd = value;
                }),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 73, 180, 210),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(email: _email, password: _passwd);

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()),
                        );

                        setState(() {
                          _email = '';
                          _passwd = '';
                        });
                      } catch (e) {
                        _showAlert(context, 'ชื่อผู้ใช้/รหัสผ่านไม่ถูกต้อง!');
                      }
                    } else {
                      _showAlert(context, 'กรุณากรอกอีเมลและรหัสผ่านให้ครบถ้วน!');
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(dbHelper: DatabaseHelper()),
                    ),
                  );
                },
                child: const Text(
                  'ต้องการสร้างบัญชีใช่หรือไม่ ? สร้างบัญชี',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 75, 75)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: obscureText,
            keyboardType: keyboardType,
            cursorColor: const Color.fromARGB(255, 73, 180, 210),
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 73, 180, 210), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
