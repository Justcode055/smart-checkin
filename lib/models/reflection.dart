class Reflection {
  final int? id;
  final String studentId;
  final String classId;
  final String type; // 'pre' or 'post'
  final String? previousTopic;
  final String? expectedTopic;
  final int? moodScore;
  final String? whatLearned;
  final String? feedback;
  final bool synced;
  final DateTime createdAt;

  Reflection({
    this.id,
    required this.studentId,
    required this.classId,
    required this.type,
    this.previousTopic,
    this.expectedTopic,
    this.moodScore,
    this.whatLearned,
    this.feedback,
    this.synced = false,
    required this.createdAt,
  });

  // Convert Reflection to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'class_id': classId,
      'type': type,
      'previous_topic': previousTopic,
      'expected_topic': expectedTopic,
      'mood_score': moodScore,
      'what_learned': whatLearned,
      'feedback': feedback,
      'synced': synced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create Reflection from Map
  factory Reflection.fromMap(Map<String, dynamic> map) {
    return Reflection(
      id: map['id'],
      studentId: map['student_id'],
      classId: map['class_id'],
      type: map['type'],
      previousTopic: map['previous_topic'],
      expectedTopic: map['expected_topic'],
      moodScore: map['mood_score'],
      whatLearned: map['what_learned'],
      feedback: map['feedback'],
      synced: map['synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
