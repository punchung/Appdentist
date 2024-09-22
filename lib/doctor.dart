import 'package:flutter/material.dart';
import 'booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/doctormodel.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

Future<void> saveDoctorToFirestore(Doctor doctor) async {
  CollectionReference doctors = FirebaseFirestore.instance.collection('doctors');
  await doctors.add(doctor.toMap());
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('นัดหมายแพทย์'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'นัดหมายแพทย์',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'เลือกแพทย์ที่ต้องการนัดหมาย',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  DoctorListTile(
                    doctorName: 'แพทย์1',
                    specialization: 'ทันตแพทย์',
                    profileImage: 'assets/images/b1.png',
                    onTap: () async {
                      Doctor doctor = Doctor(
                        name: 'แพทย์1',
                        specialization: 'ทันตแพทย์',
                        profileImage: 'assets/images/b1.png',
                      );
                      await saveDoctorToFirestore(doctor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDentistScreen(
                            doctorName: 'แพทย์1',
                            specialization: 'ทันตแพทย์',
                            profileImage: 'assets/images/b1.png',
                          ),
                        ),
                      );
                    },
                  ),
                  DoctorListTile(
                    doctorName: 'แพทย์2',
                    specialization: 'ทันตแพทย์',
                    profileImage: 'assets/images/b2.png',
                    onTap: () async {
                      Doctor doctor = Doctor(
                        name: 'แพทย์2',
                        specialization: 'ทันตแพทย์',
                        profileImage: 'assets/images/b2.png',
                      );
                      await saveDoctorToFirestore(doctor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDentistScreen(
                            doctorName: 'แพทย์2',
                            specialization: 'ทันตแพทย์',
                            profileImage: 'assets/images/b2.png',
                          ),
                        ),
                      );
                    },
                  ),
                  DoctorListTile(
                    doctorName: 'แพทย์3',
                    specialization: 'ทันตแพทย์',
                    profileImage: 'assets/images/b3.png',
                    onTap: () async {
                      Doctor doctor = Doctor(
                        name: 'แพทย์3',
                        specialization: 'ทันตแพทย์',
                        profileImage: 'assets/images/b3.png',
                      );
                      await saveDoctorToFirestore(doctor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDentistScreen(
                            doctorName: 'แพทย์3',
                            specialization: 'ทันตแพทย์',
                            profileImage: 'assets/images/b3.png',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorListTile extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String profileImage;
  final VoidCallback onTap;

  const DoctorListTile({
    Key? key,
    required this.doctorName,
    required this.specialization,
    required this.profileImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 120,
          child: ListTile(
            leading: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profileImage),
            ),
            title: Text(doctorName, style: const TextStyle(fontSize: 20)),
            subtitle: Text(specialization, style: const TextStyle(fontSize: 16)),
            trailing: Icon(Icons.arrow_forward_ios, size: 24, color: Colors.blue.shade700),
          ),
        ),
      ),
    );
  }
}