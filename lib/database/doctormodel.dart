class Doctor {
  final String name;
  final String specialization;
  final String profileImage;

  Doctor({
    required this.name,
    required this.specialization,
    required this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'profileImage': profileImage,
    };
  }
}


class BookingDoc {
  static const colBookingId = 'bookingId'; // ตัวระบุการจอง
  static const colDoctorName = 'doctorName'; // ชื่อหมอ
  static const colSpecialization = 'specialization'; // สาขาวิชา
  static const colAppointmentDate = 'appointmentDate'; // วันที่นัดหมาย
  static const colStatus = 'status'; // สถานะ
  static const colSymptoms = 'symptoms'; // อาการเบื้องต้น

  final String bookingId; // รหัสการจอง
  final String doctorName; // ฟิลด์สำหรับชื่อหมอ
  final String specialization; // ฟิลด์สำหรับสาขาวิชา
  final DateTime appointmentDate; // วันที่นัดหมาย
  final String status; // สถานะการจอง
  final String symptoms; // ฟิลด์สำหรับอาการเบื้องต้น

  BookingDoc({
    required this.bookingId, // รหัสการจองที่จำเป็น
    required this.doctorName, // ชื่อหมอที่จำเป็น
    required this.specialization, // สาขาวิชาที่จำเป็น
    required this.appointmentDate, // กำหนดเวลาการจองที่นี่
    required this.status, // สถานะที่จำเป็น
    required this.symptoms, // อาการเบื้องต้นที่จำเป็น
  });

  factory BookingDoc.fromMap(Map<String, dynamic> map) {
    return BookingDoc(
      bookingId: map[colBookingId] ?? '', // กำหนดรหัสการจองจากแผนที่
      doctorName: map[colDoctorName] ?? '', // กำหนดชื่อหมอจากแผนที่
      specialization: map[colSpecialization] ?? '', // กำหนดสาขาวิชาจากแผนที่
     appointmentDate: map[colAppointmentDate] != null
    ? DateTime.tryParse(map[colAppointmentDate]) ?? DateTime.now()
    : DateTime.now(), // กำหนดวันที่นัดหมายจากแผนที่
      status: map[colStatus] ?? 'pending', // กำหนดสถานะจากแผนที่
      symptoms: map[colSymptoms] ?? '', // กำหนดอาการเบื้องต้นจากแผนที่
    );
  }

  Map<String, dynamic> toMap() {
    return {
      colBookingId: bookingId, // ส่งกลับรหัสการจอง
      colDoctorName: doctorName, // ส่งกลับชื่อหมอ
      colSpecialization: specialization, // ส่งกลับสาขาวิชา
      colAppointmentDate: appointmentDate.toIso8601String(), // ส่งกลับวันที่นัดหมาย
      colStatus: status, // ส่งกลับสถานะ
      colSymptoms: symptoms, // ส่งกลับอาการเบื้องต้น
    };
  }

  Map<String, dynamic> toJson() {
    return {
      colBookingId: bookingId, // ส่งกลับรหัสการจอง
      colDoctorName: doctorName, // ส่งกลับชื่อหมอ
      colSpecialization: specialization, // ส่งกลับสาขาวิชา
      colAppointmentDate: appointmentDate.toIso8601String(), // ส่งกลับวันที่นัดหมาย
      colStatus: status, // ส่งกลับสถานะ
      colSymptoms: symptoms, // ส่งกลับอาการเบื้องต้น
    };
  }
  
}


