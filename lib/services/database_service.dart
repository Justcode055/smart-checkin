// Database Service
import 'package:flutter/foundation.dart';
import '../models/attendance.dart';
import '../models/reflection.dart';
import '../db/database_helper.dart';

class DatabaseService {
  final _databaseHelper = DatabaseHelper();
  
  Future<int> saveAttendance(Attendance attendance) async {
    try {
      // On web, skip database operations
      if (kIsWeb) {
        print('⚠️ Database operations not supported on web platform');
        return -1;
      }
      
      final db = await _databaseHelper.database;
      return await db.insert(
        'class_sessions',
        {
          'student_id': attendance.studentId,
          'class_id': attendance.classId,
          'checkin_time': attendance.checkInTime.toIso8601String(),
          'gps_lat': attendance.latitude,
          'gps_long': attendance.longitude,
          'qr_code': attendance.qrCode,
          'created_at': attendance.createdAt.toIso8601String(),
        },
      );
    } catch (e) {
      print('✗ Error saving attendance: $e');
      rethrow;
    }
  }

  Future<int> saveReflection(Reflection reflection) async {
    try {
      // On web, skip database operations
      if (kIsWeb) {
        print('⚠️ Database operations not supported on web platform');
        return -1;
      }
      
      final db = await _databaseHelper.database;
      return await db.insert(
        'reflections',
        {
          'student_id': reflection.studentId,
          'class_id': reflection.classId,
          'type': reflection.type,
          'previous_topic': reflection.previousTopic,
          'expected_topic': reflection.expectedTopic,
          'mood_score': reflection.moodScore,
          'what_learned': reflection.whatLearned,
          'feedback': reflection.feedback,
          'created_at': reflection.createdAt.toIso8601String(),
        },
      );
    } catch (e) {
      print('✗ Error saving reflection: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    try {
      // On web, return empty list
      if (kIsWeb) {
        print('⚠️ Database operations not supported on web platform');
        return [];
      }
      
      return await _databaseHelper.getAllSessions();
    } catch (e) {
      print('✗ Error fetching sessions: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCompletedSessions() async {
    try {
      if (kIsWeb) {
        return [];
      }
      
      return await _databaseHelper.getCompletedSessions();
    } catch (e) {
      print('✗ Error fetching completed sessions: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceRecords() async {
    try {
      if (kIsWeb) {
        return [];
      }
      
      final sessions = await _databaseHelper.getAllSessions();
      return sessions.map((session) {
        return Attendance(
          studentId: session['student_id'] ?? '',
          classId: session['class_id'] ?? '',
          checkInTime: DateTime.tryParse(session['checkin_time'] ?? '') ?? DateTime.now(),
          latitude: (session['gps_lat'] as num?)?.toDouble() ?? 0.0,
          longitude: (session['gps_long'] as num?)?.toDouble() ?? 0.0,
          qrCode: session['qr_code'] ?? '',
          createdAt: DateTime.tryParse(session['created_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('✗ Error getting attendance records: $e');
      rethrow;
    }
  }

  Future<List<Reflection>> getReflectionRecords() async {
    try {
      // This would require a separate reflections table query
      if (kIsWeb) {
        return [];
      }
      
      return [];
    } catch (e) {
      print('✗ Error getting reflection records: $e');
      rethrow;
    }
  }
}
