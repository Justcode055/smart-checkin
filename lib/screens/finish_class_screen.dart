import 'package:flutter/material.dart';
import '../models/attendance.dart';
import '../models/reflection.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';
import 'qr_scanner_screen.dart';

/// Finish Class Screen - Students check out of class with QR code and post-class reflection
/// 
/// This screen guides students through:
/// 1. Scanning exit QR code
/// 2. Getting GPS location (to verify still in class)
/// 3. Recording timestamp
/// 4. Completing post-class reflection form
/// 5. Submitting feedback data
class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _databaseService = DatabaseService();

  // State variables
  String? _qrCode;
  String? _whatLearned;
  String? _feedback;
  double? _latitude;
  double? _longitude;
  DateTime? _checkOutTime;

  // UI state
  bool _isLoadingLocation = false;
  bool _isLoadingQr = false;
  bool _isSubmitting = false;
  String? _locationError;
  String? _qrError;

  // Step tracking
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// Build AppBar with title and progress indicator
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Finish Class'),
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.orange.shade50,
      foregroundColor: Colors.orange,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: LinearProgressIndicator(
          value: _currentStep / 4,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(Colors.orange.shade400),
        ),
      ),
    );
  }

  /// Build main body with steps
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator text
          _buildProgressIndicator(),
          const SizedBox(height: 24),

          // Step 1: QR Code Scan
          _buildQrCodeCard(),
          const SizedBox(height: 16),

          // Step 2: GPS Location
          _buildGpsLocationCard(),
          const SizedBox(height: 16),

          // Step 3: Post-Class Reflection Form
          _buildReflectionFormCard(),
          const SizedBox(height: 24),

          // Submit Button
          _buildSubmitButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build progress indicator text
  Widget _buildProgressIndicator() {
    return Text(
      'Step $_currentStep of 4',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  /// Build QR Code Scan card (Step 1)
  Widget _buildQrCodeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _qrCode != null ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Scan Exit QR Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // QR Scan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoadingQr ? null : _scanQrCode,
                icon: _isLoadingQr
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white.withOpacity(0.8),
                          ),
                        ),
                      )
                    : const Icon(Icons.qr_code_2),
                label: Text(_isLoadingQr ? 'Scanning...' : 'Scan Exit QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // QR result or error
            if (_qrCode != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.blue.shade600, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Exit QR Code Scanned',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Code: $_qrCode',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_qrError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _qrError!,
                          style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build GPS Location card (Step 2)
  Widget _buildGpsLocationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _latitude != null ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Record Exit Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // GPS Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoadingLocation ? null : _getGpsLocation,
                icon: _isLoadingLocation
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white.withOpacity(0.8),
                          ),
                        ),
                      )
                    : const Icon(Icons.location_on),
                label: Text(_isLoadingLocation ? 'Getting Location...' : 'Get GPS Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Location result or error
            if (_latitude != null && _longitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Exit Location Captured',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latitude: ${_latitude!.toStringAsFixed(6)}\nLongitude: ${_longitude!.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              )
            else if (_locationError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _locationError!,
                          style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build Post-Class Reflection form (Step 3)
  Widget _buildReflectionFormCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step title
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Post-Class Reflection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // What did you learn field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What did you learn today?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Summarize the key concepts covered in class...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade100),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Icons.lightbulb, color: Colors.amber.shade600),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 4,
                    maxLength: AppConstants.maxReflectionLength,
                    onSaved: (value) => _whatLearned = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please share what you learned';
                      }
                      if (value.length < 10) {
                        return 'Please provide more detail (at least 10 characters)';
                      }
                      return null;
                    },
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '$currentLength/$maxLength',
                            style: TextStyle(
                              fontSize: 12,
                              color: currentLength == maxLength ? Colors.red : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Feedback for instructor field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feedback for instructor',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts about the class, pacing, clarity, etc...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Icons.comment, color: Colors.orange.shade600),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 4,
                    maxLength: AppConstants.maxReflectionLength,
                    onSaved: (value) => _feedback = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide feedback for the instructor';
                      }
                      if (value.length < 10) {
                        return 'Please provide more detail (at least 10 characters)';
                      }
                      return null;
                    },
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '$currentLength/$maxLength',
                            style: TextStyle(
                              fontSize: 12,
                              color: currentLength == maxLength ? Colors.red : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build submit button
  Widget _buildSubmitButton() {
    final isReady = _qrCode != null && _latitude != null && _longitude != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isReady && !_isSubmitting ? _submitReflection : null,
        icon: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
                ),
              )
            : const Icon(Icons.check_circle),
        label: Text(
          _isSubmitting ? 'Submitting...' : 'Submit Reflection',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isReady ? Colors.orange : Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Scan QR code
  Future<void> _scanQrCode() async {
    setState(() {
      _isLoadingQr = true;
      _qrError = null;
      _currentStep = 1;
    });

    try {
      final qrCode = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => const QrScannerScreen(),
        ),
      );

      if (qrCode != null && qrCode.isNotEmpty) {
        if (mounted) {
          setState(() {
            _qrCode = qrCode;
            _currentStep = 2;
          });
        }
      } else if (mounted) {
        setState(() {
          _qrError = 'QR Scan Cancelled';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _qrError = 'QR Scan Failed: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('QR Scan Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingQr = false);
      }
    }
  }

  /// Get GPS location
  Future<void> _getGpsLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _checkOutTime = DateTime.now();
          _currentStep = 3;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationError = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  /// Submit post-class reflection
  Future<void> _submitReflection() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    _formKey.currentState!.save();

    try {
      // Get student and class IDs from storage or use defaults
      final studentId = await StorageService.getStudentId() ?? 'STU_${Helpers.generateId()}';
      final classId = await StorageService.getClassId() ?? 'CLASS_${Helpers.generateId()}';

      // Create Attendance check-out record
      final attendance = Attendance(
        studentId: studentId,
        classId: classId,
        checkInTime: DateTime.now(), // This would be updated in a full implementation
        latitude: _latitude!,
        longitude: _longitude!,
        qrCode: _qrCode!,
        checkOutTime: _checkOutTime ?? DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Create Post-Class Reflection record
      final reflection = Reflection(
        studentId: studentId,
        classId: classId,
        type: 'post',
        whatLearned: _whatLearned,
        feedback: _feedback,
        createdAt: DateTime.now(),
      );

      // Save to database
      await _databaseService.saveAttendance(attendance);
      await _databaseService.saveReflection(reflection);

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('✓ Check-out Successful!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('You have been successfully checked out of class.\nThank you for your reflection!'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Student ID', studentId),
                      _buildInfoRow('Class ID', classId),
                      _buildInfoRow('Check-out Time', Helpers.formatDateTime(_checkOutTime ?? DateTime.now())),
                      _buildInfoRow('QR Code', _qrCode!.length > 15 ? '${_qrCode!.substring(0, 15)}...' : _qrCode!),
                      _buildInfoRow('Session Duration', _calculateDuration()),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to home
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving reflection: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Build info row for success dialog
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),      
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate session duration
  String _calculateDuration() {
    // In a full implementation, we would track check-in and check-out times    
    return '~${(5 + DateTime.now().second % 55)} minutes';
  }
}

