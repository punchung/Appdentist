import 'package:flutter/widgets.dart';

class Validators {
  // Validator เพื่อตรวจสอบค่าที่ไม่ว่าง
  static FormFieldValidator<String> required(String errorMessage) {
    return (value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    };
  }
 // Validator เพื่อตรวจสอบความยาวของข้อความต้องไม่เกินจำนวนที่กำหนด
  static FormFieldValidator<String> max(int max, String errorMessage) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return null; // ไม่ทำการตรวจสอบสำหรับค่าที่ว่าง
      }
      if (value.length > max) {
        return errorMessage;
      }
      return null;
    };
  }
  
  // Validator เพื่อตรวจสอบค่าที่เป็นตัวเลขและต้องมากกว่าค่าต่ำสุด
  static FormFieldValidator<String> min(double min, String errorMessage) {
    return (value) {
      // ตรวจสอบว่าค่าเป็น null หรือว่างหรือไม่
      if (value == null || value.trim().isEmpty) {
        return null; // ไม่ทำการตรวจสอบสำหรับค่าที่ว่าง
      }

      // ตรวจสอบว่าค่าเป็นตัวเลขที่ถูกต้องหรือไม่
      final dValue = double.tryParse(value);
      if (dValue == null) {
        return 'รูปแบบตัวเลขไม่ถูกต้อง!';
      }

      if (dValue < min) {
        return errorMessage;
      }
      return null;
    };
  }

  // Validator เพื่อนำ validator หลายตัวมารวมกัน
  static FormFieldValidator<String> compose(List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // Validator เพื่อตรวจสอบว่าค่าเป็นตัวเลข
  static FormFieldValidator<String> numeric(String errorMessage) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return null; // ไม่ทำการตรวจสอบสำหรับค่าที่ว่าง
      }

      final isNumeric = double.tryParse(value) != null;
      if (!isNumeric) {
        return errorMessage;
      }
      return null;
    };
  }
}
