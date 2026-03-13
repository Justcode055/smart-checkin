class Attendance {
  final int? id;
  final String studentId;
  final String classId;
  final DateTime checkInTime;
  final double latitude;
  final double longitude;
  final String qrCode;
  final DateTime? checkOutTime;
  final bool synced;
  final DateTime createdAt;

  Attendance({
    this.id,
    required this.studentId,
    required this.classId,
    required this.checkInTime,
    required this.latitude,
    required this.longitude,
    required this.qrCode,
    this.checkOutTime,
    this.synced = false,
    required this.createdAt,
  });

  // Convert Attendance to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'class_id': classId,
      'check_in_time': checkInTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'qr_code': qrCode,
      'check_out_time': checkOutTime?.toIso8601String(),
      'synced': synced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create Attendance from Map
  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['student_id'],
      classId: map['class_id'],
      checkInTime: DateTime.parse(map['check_in_time']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      qrCode: map['qr_code'],
      checkOutTime: map['check_out_time'] != null
          ? DateTime.parse(map['check_out_time'])
          : null,
      synced: map['synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
