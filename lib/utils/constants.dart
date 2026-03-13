// App Constants
class AppConstants {
  // Strings
  static const String appName = 'Smart Class Check-in';
  
  // Error Messages
  static const String errorLocationDenied = 'Location permission denied';
  static const String errorLocationDisabled = 'Location services are disabled';
  static const String errorQrScanFailed = 'QR code scan failed';
  static const String errorSaveFailed = 'Failed to save data';
  
  // Success Messages
  static const String successCheckIn = 'Check-in successful!';
  static const String successCheckOut = 'Check-out successful!';
  static const String successReflectionSaved = 'Reflection saved!';
  
  // UI Sizes
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Database
  static const String dbName = 'smart_class_checkin.db';
  static const int dbVersion = 1;
  
  // Limits
  static const int maxReflectionLength = 500;
}
