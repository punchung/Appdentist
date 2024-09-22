import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'home.dart'; // ตรวจสอบว่าที่อยู่ไฟล์ถูกต้อง
import 'package:cloud_firestore/cloud_firestore.dart'; // ตรวจสอบว่าที่อยู่ไฟล์ถูกต้อง
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import '../database/doctormodel.dart';

class BookDentistScreen extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String profileImage;

  const BookDentistScreen({
    Key? key,
    required this.doctorName,
    required this.specialization,
    required this.profileImage,
  }) : super(key: key);

  @override
  State<BookDentistScreen> createState() => _BookDentistScreenState();
}

class _BookDentistScreenState extends State<BookDentistScreen> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  String initialSymptoms = '';
  bool isLoading = false;
  String loggedInUserEmail = ''; // อีเมลของผู้ใช้ที่ล็อกอิน

  @override
  void initState() {
    super.initState();

    // ดึงข้อมูลผู้ใช้ที่ล็อกอิน
    firebaseAuth.User? currentUser =
        firebaseAuth.FirebaseAuth.instance.currentUser;
    loggedInUserEmail = currentUser?.email ?? 'Unknown Email';

    // ตั้งค่า BookingService
    mockBookingService = BookingService(
      serviceName: 'บริการจองคิว',
      serviceDuration: 30, // ระยะเวลาการจองคิว 30 นาที
      bookingStart: DateTime(now.year, now.month, now.day, 15, 0),
      bookingEnd: DateTime(
          now.year, now.month, now.day, 21, 0), // เวลาเริ่มต้น 15.00 ถึง 21.00
    );
  }

 Future<void> uploadBooking({required BookingDoc newBooking}) async {
  setState(() {
    isLoading = true;
  });

  try {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(newBooking.bookingId)
        .set({
      ...newBooking.toJson(),
      'bookedByEmail': loggedInUserEmail,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('จองสำเร็จแล้ว')),
    );
  } catch (e) {
    print('Error uploading booking: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  Stream<List<DateTimeRange>> getBookingStream({required DateTime start, required DateTime end}) {
  return FirebaseFirestore.instance
      .collection('appointments')
      .where('appointmentDate', isGreaterThanOrEqualTo: start)
      .where('appointmentDate', isLessThanOrEqualTo: end)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      DateTime start = (doc['appointmentDate'] as Timestamp).toDate();
      DateTime end = start.add(const Duration(minutes: 30));
      return DateTimeRange(start: start, end: end);
    }).toList();
  });
}

 List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
  if (streamResult is List) {
    return streamResult.map<DateTimeRange>((dynamic doc) {
      DateTime start = (doc['appointmentDate'] as Timestamp).toDate();
      DateTime end = start.add(const Duration(minutes: 30)); // สมมติว่าเวลาจอง 30 นาที
      return DateTimeRange(start: start, end: end);
    }).toList();
  }
  return [];
}


  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
        start: DateTime(
            now.year, now.month, now.day, 17, 30), // เวลาพัก 17:30 ถึง 18:00
        end: DateTime(now.year, now.month, now.day, 18, 0),
      ),
    ];
  }

  Widget tabContent() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 110,
              backgroundImage: AssetImage(widget.profileImage),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: Text(
                widget.doctorName,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.specialization,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Kanit',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('นัดหมายแพทย์'),
        backgroundColor: Colors.blue,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ข้อมูลแพทย์',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  tabContent(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'บอกเล่าอาการเบื้องต้น',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      initialSymptoms = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      hintText: 'อาการเบื้องต้น',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'เลือกวันที่ และ เวลา ที่ต้องการจอง',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 600,
                    child: BookingCalendar(
                      key: UniqueKey(),
                      getBookingStream: getBookingStream,
                      bookingService: mockBookingService,
                      uploadBooking: (
                          {required BookingService newBooking}) async {
                        BookingDoc newBookingDoc = BookingDoc(
                          bookingId:
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          doctorName: widget.doctorName,
                          specialization: widget.specialization,
                          appointmentDate: newBooking.bookingStart,
                          status: 'pending',
                          symptoms: initialSymptoms,
                        );
                        await uploadBooking(newBooking: newBookingDoc);

                        // รีเฟรชข้อมูลช่องเวลาที่ถูกจองหลังจากจองสำเร็จ
                        setState(() {
                          getBookingStream(
                              start: newBooking.bookingStart,
                              end: newBooking.bookingEnd);
                        });
                      },
                      convertStreamResultToDateTimeRanges:
                          convertStreamResultMock,
                      bookingButtonColor: Colors.blue,
                      bookingButtonText: 'จองคิว',
                      availableSlotColor:
                          const Color.fromARGB(255, 120, 222, 123),
                      availableSlotText: 'ว่าง',
                      bookedSlotColor: Colors.red, // สีสำหรับเวลาที่ถูกจอง
                      bookedSlotText: 'ไม่ว่าง',
                      selectedSlotColor: Colors.yellow,
                      selectedSlotText: 'เลือกแล้ว',
                      loadingWidget: const CircularProgressIndicator(),
                      errorWidget: const Text('เกิดข้อผิดพลาด'),
                      uploadingWidget: const CircularProgressIndicator(),
                      pauseSlotColor: Colors.grey,
                      pauseSlotText: 'พัก',
                      hideBreakTime: false,
                      locale: 'en_US',
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      disabledDays: [],
                      pauseSlots: generatePauseSlots(),
                      
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
