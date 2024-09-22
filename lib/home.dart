// หน้าจอหลักของแอปพลิเคชัน
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'doctor.dart';
import 'news.dart';
import 'filedetail.dart';
import '../database/database_helper.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.person, size: screenWidth * 0.06),
            SizedBox(width: screenWidth * 0.02),
            Text('SmileCare Dental Clinic',
                style: TextStyle(fontSize: screenWidth * 0.045)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: screenWidth * 0.06),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              children: [
                _buildMenuItem(Icons.calendar_today, 'นัดหมายแพทย์', screenWidth, context, MyAppointmentScreen()),
                _buildMenuItem(Icons.monitor_heart, 'นัดหมายของฉัน', screenWidth, context, CheckupScreen()),
                _buildMenuItem(Icons.health_and_safety, 'บันทึกสุขภาพ', screenWidth, context, HealthRecordScreen()),
                _buildMenuItem(Icons.insert_drive_file, 'แฟ้มข้อมูล', screenWidth, context, FilesScreen(dbHelper: DatabaseHelper())),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => newsScreen1()),
                    );
                  },
                  child: _buildNewsItem(
                    screenWidth,
                    'เช็กสิทธิ! ทำฟันฟรี 3 ครั้งต่อปี ที่คลินิกทันตกรรมชุมชน',
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                // แทนที่บล็อก "แพทย์คนที่ 2" ด้วยวิดีโอ YouTube
                _buildYouTubeVideo(screenWidth),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, screenWidth),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, double screenWidth,
      BuildContext context, Widget targetScreen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: screenWidth * 0.09,
            backgroundColor: Colors.white,
            child: Icon(icon, size: screenWidth * 0.06, color: Colors.blueAccent),
          ),
          SizedBox(height: screenWidth * 0.02),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(double screenWidth, String title) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.06),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, size: screenWidth * 0.10, color: Colors.grey),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้าง widget สำหรับเล่นวิดีโอ YouTube
  Widget _buildYouTubeVideo(double screenWidth) {
    final String videoId = YoutubePlayer.convertUrlToId('https://www.youtube.com/embed/kcSWcElzgtY')!;
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        width: screenWidth,
        aspectRatio: 16 / 9,
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, double screenWidth) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyAppointmentScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckupScreen()),
            );
            break;
          case 3:
            _showMenuModal(context);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: screenWidth * 0.06),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today, size: screenWidth * 0.06),
          label: 'นัดหมายแพทย์',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services, size: screenWidth * 0.06),
          label: 'นัดหมายของฉัน',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, size: screenWidth * 0.06),
          label: 'เมนู',
        ),
      ],
      selectedFontSize: screenWidth * 0.035,
      unselectedFontSize: screenWidth * 0.035,
    );
  }

  void _showMenuModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text('แฟ้มข้อมูล'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilesScreen(dbHelper: DatabaseHelper())),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.health_and_safety),
                title: Text('บันทึกสุขภาพ'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HealthRecordScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('นัดหมายแพทย์'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAppointmentScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.monitor_heart),
                title: Text('นัดหมายของฉัน'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckupScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('ออกจากระบบ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ส่วนประกอบของหน้าจออื่นๆ
class CheckupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ดูคิวตรวจ')),
      body: Center(child: Text('นี่คือหน้าสำหรับการดูคิวตรวจ')),
    );
  }
}

class HealthRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('บันทึกสุขภาพ')),
      body: Center(child: Text('นี่คือหน้าสำหรับบันทึกสุขภาพ')),
    );
  }
}