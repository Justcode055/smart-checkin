// Form Validation Logic
class Validators {
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length < minLength) {
      return 'Minimum length is $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length > maxLength) {
      return 'Maximum length is $maxLength characters';
    }
    return null;
  }

  static String? validateMoodScore(int? value) {
    if (value == null || value < 1 || value > 5) {
      return 'Please select a mood score between 1-5';
    }
    return null;
  }

  static String? validateQrCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'QR code is required';
    }
    if (value.length < 5) {
      return 'Invalid QR code';
    }
    return null;
  }
}
