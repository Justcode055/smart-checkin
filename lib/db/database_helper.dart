// SQLite Database Helper
// Manages all database operations for class check-in and reflection data
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import sqflite_common_ffi for desktop support
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

/// DatabaseHelper - Singleton class for SQLite database management
/// 
/// Handles:
/// - Database initialization
/// - Table creation and schema
/// - CRUD operations for class sessions
/// - Check-in and check-out data management
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static const String dbName = 'class_checkin.db';
  static const int dbVersion = 1;
  static const String tableName = 'class_sessions';

  // Table column names
  static const String colId = 'id';
  static const String colCheckinTime = 'checkin_time';
  static const String colCheckoutTime = 'checkout_time';
  static const String colGpsLat = 'gps_lat';
  static const String colGpsLong = 'gps_long';
  static const String colPreviousTopic = 'previous_topic';
  static const String colExpectedTopic = 'expected_topic';
  static const String colMood = 'mood';
  static const String colLearnedToday = 'learned_today';
  static const String colFeedback = 'feedback';
  static const String colQrCode = 'qr_code';
  static const String colCheckoutQrCode = 'checkout_qr_code';
  static const String colCheckoutLat = 'checkout_lat';
  static const String colCheckoutLong = 'checkout_long';
  static const String colCreatedAt = 'created_at';

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  /// Get database instance
  /// Lazy-loads database on first access
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  /// Initialize database connection
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    // Use sqflite_ffi factory for desktop platforms
    Database db;
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
                    defaultTargetPlatform == TargetPlatform.linux ||
                    defaultTargetPlatform == TargetPlatform.macOS)) {
      db = await sqflite_ffi.databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: dbVersion,
          onCreate: _createDb,
          onUpgrade: _upgradeDb,
        ),
      );
    } else {
      // Use default openDatabase for mobile and web
      db = await openDatabase(
        path,
        version: dbVersion,
        onCreate: _createDb,
        onUpgrade: _upgradeDb,
      );
    }
    
    return db;
  }

  /// Create database tables on first initialization
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCheckinTime TEXT NOT NULL,
        $colCheckoutTime TEXT,
        $colQrCode TEXT,
        $colCheckoutQrCode TEXT,
        $colGpsLat REAL NOT NULL,
        $colGpsLong REAL NOT NULL,
        $colCheckoutLat REAL,
        $colCheckoutLong REAL,
        $colPreviousTopic TEXT,
        $colExpectedTopic TEXT,
        $colMood INTEGER,
        $colLearnedToday TEXT,
        $colFeedback TEXT,
        $colCreatedAt TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');
  }

  /// Handle database version upgrades
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    // Handle future schema migrations here if needed
  }

  // ============================================================================
  // CHECK-IN OPERATIONS
  // ============================================================================

  /// Insert check-in data (Step 1)
  /// 
  /// Returns: ID of the inserted record
  Future<int> insertCheckIn({
    required String checkinTime,
    required double gpsLat,
    required double gpsLong,
    required String qrCode,
    required String previousTopic,
    required String expectedTopic,
    required int mood,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();

      final result = await db.insert(
        tableName,
        {
          colCheckinTime: checkinTime,
          colGpsLat: gpsLat,
          colGpsLong: gpsLong,
          colQrCode: qrCode,
          colPreviousTopic: previousTopic,
          colExpectedTopic: expectedTopic,
          colMood: mood,
          colCreatedAt: now,
        },
      );

      print('✓ Check-in saved with ID: $result');
      return result;
    } catch (e) {
      print('✗ Error inserting check-in: $e');
      rethrow;
    }
  }

  // ============================================================================
  // CHECK-OUT OPERATIONS
  // ============================================================================

  /// Update session with check-out data (Step 2)
  /// 
  /// Updates the record with:
  /// - Check-out time
  /// - Exit location (GPS)
  /// - Exit QR code
  /// - Learning reflection
  /// - Feedback
  Future<int> updateCheckOut({
    required int sessionId,
    required String checkoutTime,
    required double checkoutLat,
    required double checkoutLong,
    required String checkoutQrCode,
    required String learnedToday,
    required String feedback,
  }) async {
    try {
      final db = await database;

      final result = await db.update(
        tableName,
        {
          colCheckoutTime: checkoutTime,
          colCheckoutLat: checkoutLat,
          colCheckoutLong: checkoutLong,
          colCheckoutQrCode: checkoutQrCode,
          colLearnedToday: learnedToday,
          colFeedback: feedback,
        },
        where: '$colId = ?',
        whereArgs: [sessionId],
      );

      print('✓ Check-out saved for session ID: $sessionId');
      return result;
    } catch (e) {
      print('✗ Error updating check-out: $e');
      rethrow;
    }
  }

  // ============================================================================
  // READ OPERATIONS
  // ============================================================================

  /// Get all class sessions
  Future<List<Map<String, dynamic>>> getAllSessions() async {
    try {
      final db = await database;
      final result = await db.query(
        tableName,
        orderBy: '$colCreatedAt DESC',
      );
      return result;
    } catch (e) {
      print('✗ Error fetching all sessions: $e');
      rethrow;
    }
  }

  /// Get a specific session by ID
  Future<Map<String, dynamic>?> getSessionById(int id) async {
    try {
      final db = await database;
      final result = await db.query(
        tableName,
        where: '$colId = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('✗ Error fetching session $id: $e');
      rethrow;
    }
  }

  /// Get incomplete sessions (checked in but not checked out)
  Future<List<Map<String, dynamic>>> getIncompleteSessions() async {
    try {
      final db = await database;
      final result = await db.query(
        tableName,
        where: '$colCheckoutTime IS NULL',
        orderBy: '$colCreatedAt DESC',
      );
      return result;
    } catch (e) {
      print('✗ Error fetching incomplete sessions: $e');
      rethrow;
    }
  }

  /// Get completed sessions (both checked in and out)
  Future<List<Map<String, dynamic>>> getCompletedSessions() async {
    try {
      final db = await database;
      final result = await db.query(
        tableName,
        where: '$colCheckoutTime IS NOT NULL',
        orderBy: '$colCreatedAt DESC',
      );
      return result;
    } catch (e) {
      print('✗ Error fetching completed sessions: $e');
      rethrow;
    }
  }

  /// Get sessions created today
  Future<List<Map<String, dynamic>>> getTodaySessions() async {
    try {
      final db = await database;
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day)
          .toIso8601String();
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59)
          .toIso8601String();

      final result = await db.query(
        tableName,
        where: '$colCreatedAt BETWEEN ? AND ?',
        whereArgs: [startOfDay, endOfDay],
        orderBy: '$colCreatedAt DESC',
      );
      return result;
    } catch (e) {
      print('✗ Error fetching today\'s sessions: $e');
      rethrow;
    }
  }

  /// Get unsynced sessions (for Firebase sync later)
  Future<List<Map<String, dynamic>>> getUnsyncedSessions() async {
    try {
      final db = await database;
      final result = await db.query(
        tableName,
        where: 'synced = 0',
        orderBy: '$colCreatedAt ASC',
      );
      return result;
    } catch (e) {
      print('✗ Error fetching unsynced sessions: $e');
      rethrow;
    }
  }

  /// Get session count
  Future<int> getSessionCount() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableName');
      return result.isNotEmpty ? result.first['count'] as int : 0;
    } catch (e) {
      print('✗ Error getting session count: $e');
      rethrow;
    }
  }

  // ============================================================================
  // DELETE OPERATIONS
  // ============================================================================

  /// Delete a specific session by ID
  Future<int> deleteSession(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        tableName,
        where: '$colId = ?',
        whereArgs: [id],
      );
      print('✓ Session $id deleted');
      return result;
    } catch (e) {
      print('✗ Error deleting session $id: $e');
      rethrow;
    }
  }

  /// Delete all sessions (use with caution!)
  Future<int> deleteAllSessions() async {
    try {
      final db = await database;
      final result = await db.delete(tableName);
      print('✓ All sessions deleted (count: $result)');
      return result;
    } catch (e) {
      print('✗ Error deleting all sessions: $e');
      rethrow;
    }
  }

  /// Delete sessions older than specified days
  Future<int> deleteOldSessions(int daysOld) async {
    try {
      final db = await database;
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final result = await db.delete(
        tableName,
        where: '$colCreatedAt < ?',
        whereArgs: [cutoffDate.toIso8601String()],
      );
      print('✓ Deleted sessions older than $daysOld days (count: $result)');
      return result;
    } catch (e) {
      print('✗ Error deleting old sessions: $e');
      rethrow;
    }
  }

  // ============================================================================
  // SYNC OPERATIONS
  // ============================================================================

  /// Mark session as synced to Firebase
  Future<int> markAsSynced(int id) async {
    try {
      final db = await database;
      final result = await db.update(
        tableName,
        {'synced': 1},
        where: '$colId = ?',
        whereArgs: [id],
      );
      print('✓ Session $id marked as synced');
      return result;
    } catch (e) {
      print('✗ Error marking session as synced: $e');
      rethrow;
    }
  }

  /// Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
