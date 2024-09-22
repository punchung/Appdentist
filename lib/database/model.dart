class User {
  static const colIduser = 'iduser';
  static const colEmail = 'Email';
  static const colName = 'name';
  static const colLastname = 'lastname';
  static const colNickname = 'nickname';
  static const colBirthDate = 'birthDate';
  static const colBloodtype = 'bloodtype';
  static const colChonicillness = 'chonicillness';
  static const colMedicalhistory = 'medicalhistory';
  static const colPhonenumber = 'phonenumber';
  static const colGender = 'gender';
  static const colAge = 'age';
  static const colReferenceId = 'referenceId';

  final String iduser;
  final String email;
  final String name;
  final String lastname;
  final String nickname;
  final DateTime birthDate;
  final String bloodtype;
  final String chonicillness;
  final String medicalhistory;
  final String phonenumber;
  final String gender;
  final int age;
  final String? referenceId; // เปลี่ยนให้ referenceId เป็น nullable

  User({
    required this.iduser,
    required this.email,
    required this.name,
    required this.lastname,
    required this.nickname,
    required this.birthDate,
    required this.bloodtype,
    required this.chonicillness,
    required this.medicalhistory,
    required this.phonenumber,
    required this.gender,
    required this.age,
    this.referenceId, // อนุญาตให้ referenceId เป็นค่า null ได้
  });

  // แปลงจาก Map เป็น User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      iduser: map[colIduser] ?? '',
      email: map[colEmail] ?? '',
      name: map[colName] ?? '',
      lastname: map[colLastname] ?? '',
      nickname: map[colNickname] ?? '',
      birthDate: DateTime.tryParse(
              map[colBirthDate] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      bloodtype: map[colBloodtype] ?? '',
      chonicillness: map[colChonicillness] ?? '',
      medicalhistory: map[colMedicalhistory] ?? '',
      phonenumber: map[colPhonenumber] ?? '',
      gender: map[colGender] ?? '',
      age: map[colAge] ?? 0,
      referenceId: map[colReferenceId],
    );
  }

  // แปลง User เป็น Map
  Map<String, dynamic> toMap() {
    return {
      colIduser: iduser,
      colEmail: email,
      colName: name,
      colLastname: lastname,
      colNickname: nickname,
      colBirthDate: birthDate.toIso8601String(),
      colBloodtype: bloodtype,
      colChonicillness: chonicillness,
      colMedicalhistory: medicalhistory,
      colPhonenumber: phonenumber,
      colGender: gender,
      colAge: age,
      colReferenceId: referenceId, // จัดการกับ referenceId ที่เป็นค่า null
    };
  }
}