import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_dentist/database/model.dart'; // ตรวจสอบว่าที่อยู่ไฟล์ถูกต้อง
import 'package:app_dentist/database/doctormodel.dart'; // ตรวจสอบว่าที่อยู่ไฟล์ถูกต้อง

class DatabaseHelper {
  final CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('iduser'); // ตรวจสอบชื่อคอลเล็กชัน


  // การเพิ่มข้อมูล
  Future<DocumentReference<Map<String, dynamic>>> insertUser(User user) {
    return collection.add(user.toMap());
  }

  // การอัพเดทข้อมูล
  Future<void> updateUser(String userId, User user) {
    return collection.doc(userId).update(user.toMap());
  }

  // การลบข้อมูล
  Future<void> deleteUser(String userId) {
    return collection.doc(userId).delete();
  }

  // การดึงข้อมูล
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(String email) {
    print('Querying for email: $email'); // ดีบักอีเมลที่ใช้ค้นหา
    return collection.where('Email', isEqualTo: email).limit(1).snapshots();
  }
}


class DatabaseDoctor {
  final CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('bookings');

  // เพิ่มข้อมูลการจอง
  Future<void> addBooking(BookingDoc booking) async {
    try {
      await collection.add(booking.toMap());
    } catch (e) {
      print('Error adding booking: $e');
      // เพิ่มการจัดการข้อผิดพลาดที่เหมาะสม
    }
  }

  // ลบข้อมูลการจอง
  Future<void> deleteBooking(String bookingId) async {
    try {
      await collection.doc(bookingId).delete();
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  // แก้ไขข้อมูลการจอง
  Future<void> updateBooking(String bookingId, BookingDoc booking) async {
    try {
      await collection.doc(bookingId).update(booking.toMap());
    } catch (e) {
      print('Error updating booking: $e');
    }
  }

  // รับข้อมูลการจองทั้งหมด
  Stream<List<BookingDoc>> getBookings() {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingDoc.fromMap(doc.data()!);
      }).toList();
    });
  }

  // รับข้อมูลการจองตาม ID
  Future<BookingDoc?> getBookingById(String bookingId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await collection.doc(bookingId).get();
      if (doc.exists) {
        return BookingDoc.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error getting booking: $e');
    }
    return null;
  }

  // เพิ่มข้อมูลการจองของแพทย์ตามชื่อ
  Future<void> addDoctorBooking(String doctorName, BookingDoc booking) async {
    try {
      CollectionReference<Map<String, dynamic>> doctorCollection = 
          FirebaseFirestore.instance.collection('bookings').doc(doctorName).collection('appointments');

      // ตรวจสอบว่ามีเอกสารแพทย์อยู่แล้วหรือไม่
      DocumentReference<Map<String, dynamic>> doctorDoc = 
          FirebaseFirestore.instance.collection('bookings').doc(doctorName);
      
      if (!(await doctorDoc.get()).exists) {
        await doctorDoc.set({
          'doctorName': doctorName,
          // ข้อมูลอื่น ๆ ของแพทย์สามารถเพิ่มได้ที่นี่
        });
      }

      await doctorCollection.add(booking.toMap());
    } catch (e) {
      print('Error adding booking for doctor: $e');
    }
  }
}

