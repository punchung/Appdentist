import 'package:flutter/material.dart';

class newsScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ทำฟันฟรี 3 ครั้ง ตามสิทธิบัตรทอง'),
        backgroundColor: Colors.blue, // Change AppBar color
      ),
      body: ListView(
        children: [
          ImageSection(image: 'assets/images/news1.jpg'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สิทธิประโยชน์ทันตกรรมสำหรับประชาชนสิทธิบัตรทอง 30 บาท',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'วันที่ 13 พฤษภาคม 2567',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[600],
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'สิทธิประโยชน์ทันตกรรมในระบบหลักประกันสุขภาพแห่งชาติ (สิทธิบัตรทอง หรือ 30 บาทรักษาทุกโรค) มีดังนี้ คือ '
                  'ทันตกรรมส่งเสริมป้องกัน',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[800],
                  ),
                ),
                SizedBox(height: 16.0),
                Image(image: AssetImage('assets/images/n1.jpg')),
                Text(
                  '1. ตรวจสุขภาพช่องปาก ขัด และทำความสะอาดฟัน'
                  '2. การทาฟลูออไรด์วาร์นิช'
                  '3. การเคลือบฟันด้วยฟลูออไรด์ความเข้มข้นสูงเฉพาะที่'
                  '4. เคลือบหลุมร่องฟันในฟันกรามถาวรและฟันกรามน้อย'
                  '5. คัดกรองรอยโรคเสี่ยงมะเร็งและมะเร็งช่องปากโดยการตัดเนื้อเยื่อบริเวณรอยโรค (Biopsy) และตรวจทางพยาธิวิทยา (ผู้มีอายุ 40 ปีขึ้นไปที่มีความเสี่ยง)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: double.infinity,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}
