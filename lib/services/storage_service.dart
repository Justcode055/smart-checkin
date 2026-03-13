// Shared Preferences / Local Storage Service
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveStudentId(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_id', studentId);
  }

  static Future<String?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('student_id');
  }

  static Future<void> saveClassId(String classId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('class_id', classId);
  }

  static Future<String?> getClassId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('class_id');
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
