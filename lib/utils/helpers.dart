// Helper Functions
import 'package:intl/intl.dart';

class Helpers {
  // Format timestamp
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Generate unique IDs
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Validate latitude/longitude
  static bool isValidCoordinate(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }

  // Distance calculation (placeholder)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Haversine formula can be implemented here
    // For MVP, return placeholder
    return 0.0;
  }
}
