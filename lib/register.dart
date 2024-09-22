import 'dart:io';
import 'package:app_dentist/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'validator.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_dentist/database/model.dart' as LocalModel;

class Register extends StatefulWidget {
  Register({Key? key, required this.dbHelper}) : super(key: key);
  DatabaseHelper dbHelper;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? iduser;
  String? email;
  String? passwd;
  String? name;
  String? lastname;
  String? nickname;
  DateTime? birthDate;
  String? bloodtype;
  String? chonicillness;
  String? medicalhistory;
  String? phonenumber;
  String? gender;
  int? age;
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        elevation: 0,
        title: const Text('สร้างบัญชีผู้ใช้ใหม่'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.local_hospital,
                size: 100,
                color: Colors.black,
              ),
              Text(
                'ข้อมูลส่วนตัว',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      label: 'ชื่อ',
                      hintText: 'กรอกชื่อ',
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
                      validator: Validators.required('กรุณากรอกชื่อ'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextFormField(
                      label: 'นามสกุล',
                      hintText: 'กรอกนามสกุล',
                      onChanged: (value) => setState(() {
                        lastname = value;
                      }),
                      validator: Validators.required('กรุณากรอกนามสกุล'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'เลขบัตรประชาชน',
                hintText: 'กรอกเลขบัตรประชาชน 13 หลัก',
                obscureText: false,
                onChanged: (value) => setState(() {
                  iduser = value;
                }),
                validator: Validators.compose([
                  Validators.required('กรุณากรอกเลขบัตรประชาชน'),
                  Validators.min(13, 'เลขบัตรประชาชนต้องมีอย่างน้อย 13 หลัก'),
                  Validators.max(13, 'เลขบัตรประชาชนต้องมีไม่เกิน 13 หลัก')
                ]),
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'Email',
                hintText: 'กรอกอีเมลของคุณ',
                onChanged: (value) => setState(() {
                  email = value;
                }),
                validator: Validators.required('กรุณากรอกอีเมล'),
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'รหัสผ่าน',
                hintText: 'สร้างรหัสผ่านของคุณ',
                obscureText: true,
                onChanged: (value) => setState(() {
                  passwd = value;
                }),
                validator: Validators.required('กรุณากรอกรหัสผ่าน'),
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'ชื่อเล่น',
                hintText: 'กรอกชื่อเล่น',
                onChanged: (value) => setState(() {
                  nickname = value;
                }),
                validator: Validators.required('กรุณากรอกชื่อเล่น'),
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'เบอร์โทรศัพท์',
                hintText: 'เบอร์โทรศัพท์ที่ใช้ติดต่อ',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // อนุญาตเฉพาะตัวเลข
                onChanged: (value) => setState(() {
                  phonenumber = value;
                }),
                validator: Validators.compose([
                  Validators.required('กรุณากรอกเบอร์โทรศัพท์'),
                  Validators.min(10, 'เบอร์โทรศัพท์ต้องมี 10 หลัก')
                ]),
              ),
              const SizedBox(height: 5),
              _buildAgeAndBirthdateFields(),
              const SizedBox(height: 10),
              _buildDropdownFormField(
                label: 'กรุ๊ปเลือด',
                hintText: 'เลือกกรุ๊ปเลือดของคุณ',
                value: bloodtype,
                items: ['A', 'B', 'AB', 'O'],
                onChanged: (value) {
                  setState(() {
                    bloodtype = value;
                  });
                },
                validator: Validators.required('กรุณาเลือกกรุ๊ปเลือด'),
              ),
              const SizedBox(height: 5),
              _buildDropdownFormField(
                label: 'เพศ',
                hintText: '',
                value: gender,
                items: ['ชาย', 'หญิง'],
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Text(
                'ข้อมูลโรคประจำตัว',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'โรคประจำตัว',
                hintText: 'กรอกประวัติโรคประจำตัว',
                onChanged: (value) => setState(() {
                  chonicillness = value;
                }),
                validator: Validators.required('กรุณากรอกโรคประจำตัว'),
              ),
              const SizedBox(height: 5),
              _buildTextFormField(
                label: 'ประวัติการแพ้ยา',
                hintText: 'กรอกประวัติการแพ้ยา',
                onChanged: (value) => setState(() {
                  medicalhistory = value;
                }),
                validator: Validators.required('กรุณากรอกประวัติการแพ้ยา'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // สร้างผู้ใช้ใหม่ใน Firebase Authentication
                        UserCredential userCredential =
                            await widget._auth.createUserWithEmailAndPassword(
                          email: email!,
                          password: passwd!,
                        );
                        // ถ้าสร้างผู้ใช้สำเร็จ ให้บันทึกข้อมูลผู้ใช้เพิ่มเติม
                        var newUser = LocalModel.User(
                          iduser: iduser!, // ตรวจสอบว่าค่า iduser ถูกต้อง
                          email: email!,
                          name: name!, // ตรวจสอบค่าที่ส่ง
                          lastname: lastname!,
                          nickname: nickname!,
                          birthDate:
                              birthDate!, // กำหนดข้อมูลวันเกิดในรูปแบบที่ถูกต้อง
                          bloodtype: bloodtype!,
                          chonicillness: chonicillness!,
                          medicalhistory: medicalhistory!,
                          phonenumber: phonenumber!,
                          gender: gender!,
                          age: age!,
                        );

                        // บันทึกข้อมูลลงในฐานข้อมูลผ่าน dbHelper
                        await widget.dbHelper.insertUser(newUser);

                        // นำทางไปยังหน้า MyHomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );

                        // แสดงข้อความแจ้งเตือนเมื่อสมัครสมาชิกสำเร็จ
                        await _showAlert(context, 'สมัครสมาชิกสำเร็จ!');
                      } catch (e) {
                        // แสดงข้อผิดพลาดหากการสมัครสมาชิกล้มเหลว
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  child: const Text('สมัครสมาชิก'),
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
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
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
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 73, 180, 210), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String hintText,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 73, 180, 210), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildAgeAndBirthdateFields() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: birthDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  birthDate = pickedDate;
                  age = DateTime.now().year - birthDate!.year;
                  if (DateTime.now().month < birthDate!.month ||
                      (DateTime.now().month == birthDate!.month &&
                          DateTime.now().day < birthDate!.day)) {
                    age = age! - 1;
                  }
                  _ageController.text = '$age ปี';
                });
              }
            },
            child: AbsorbPointer(
              child: _buildTextFormField(
                label: 'วัน/เดือน/ปีเกิด',
                hintText: birthDate != null
                    ? '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}'
                    : 'เลือกวัน/เดือน/ปีเกิด',
                onChanged: (value) {},
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
