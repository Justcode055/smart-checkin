import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../utils/helpers.dart';

/// View History Screen - Display all saved attendance records
class ViewHistoryScreen extends StatefulWidget {
  const ViewHistoryScreen({super.key});

  @override
  State<ViewHistoryScreen> createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  final _databaseService = DatabaseService();
  late Future<List<Map<String, dynamic>>> _historySessions;

  @override
  void initState() {
    super.initState();
    _historySessions = _databaseService.getAllSessions();
  }

  /// Format date and time
  String _formatDateTime(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr);
      return Helpers.formatDateTime(dt);
    } catch (e) {
      return dateTimeStr;
    }
  }

  /// Build status badge
  Widget _buildStatusBadge(Map<String, dynamic> session) {
    final hasCheckOut = session['checkout_time'] != null && session['checkout_time'].toString().isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: hasCheckOut ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasCheckOut ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Text(
        hasCheckOut ? '✓ Completed' : '⏱ Incomplete',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: hasCheckOut ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historySessions,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue.shade400),
                  const SizedBox(height: 16),
                  const Text('Loading history...'),
                ],
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _historySessions = _databaseService.getAllSessions();
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No attendance records yet',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete a check-in to see records here',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          // List of sessions
          final sessions = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _historySessions = _databaseService.getAllSessions();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final isCompleted = session['checkout_time'] != null && 
                                   session['checkout_time'].toString().isNotEmpty;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _showSessionDetails(context, session),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Session ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              _buildStatusBadge(session),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Class ID
                          Row(
                            children: [
                              Icon(Icons.class_, size: 16, color: Colors.blue.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Class: ${session['class_id'] ?? 'N/A'}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Check-in time
                          Row(
                            children: [
                              Icon(Icons.login, size: 16, color: Colors.green.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Check-in: ${_formatDateTime(session['checkin_time'] ?? '')}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Check-out time (if available)
                          if (isCompleted) ...[
                            Row(
                              children: [
                                Icon(Icons.logout, size: 16, color: Colors.orange.shade600),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Check-out: ${_formatDateTime(session['checkout_time'] ?? '')}',
                                    style: TextStyle(color: Colors.grey.shade700),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],

                          // QR Code
                          Row(
                            children: [
                              Icon(Icons.qr_code_2, size: 16, color: Colors.purple.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'QR: ${_getShortQRCode(session)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Mood (if available)
                          if (session['mood'] != null)
                            Row(
                              children: [
                                Icon(Icons.mood, size: 16, color: Colors.amber.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  'Mood: ${['😞', '😕', '😐', '🙂', '😄'][int.tryParse(session['mood'].toString()) ?? 2]}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),

                          const SizedBox(height: 12),
                          Text(
                            'Tap to view details',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Show detailed view of a session
  void _showSessionDetails(BuildContext context, Map<String, dynamic> session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Session Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Student ID', session['student_id'] ?? 'N/A'),
                _buildDetailRow('Class ID', session['class_id'] ?? 'N/A'),
                _buildDetailRow('Check-in Time', _formatDateTime(session['checkin_time'] ?? '')),
                if (session['checkout_time'] != null && session['checkout_time'].toString().isNotEmpty)
                  _buildDetailRow('Check-out Time', _formatDateTime(session['checkout_time'] ?? '')),
                _buildDetailRow('GPS Latitude', (session['gps_lat'] as num?)?.toStringAsFixed(6) ?? 'N/A'),
                _buildDetailRow('GPS Longitude', (session['gps_long'] as num?)?.toStringAsFixed(6) ?? 'N/A'),
                _buildDetailRow('QR Code', session['qr_code'] ?? 'N/A'),
                if (session['checkout_qr_code'] != null)
                  _buildDetailRow('Exit QR Code', session['checkout_qr_code'] ?? 'N/A'),
                if (session['mood'] != null)
                  _buildDetailRow('Mood', ['😞', '😕', '😐', '🙂', '😄'][int.tryParse(session['mood'].toString()) ?? 2]),
                if (session['previous_topic'] != null)
                  _buildDetailRow('Previous Topic', session['previous_topic'] ?? 'N/A'),
                if (session['expected_topic'] != null)
                  _buildDetailRow('Expected Topic', session['expected_topic'] ?? 'N/A'),
                if (session['learned_today'] != null)
                  _buildDetailRow('What Learned', session['learned_today'] ?? 'N/A'),
                if (session['feedback'] != null)
                  _buildDetailRow('Feedback', session['feedback'] ?? 'N/A'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build a detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
                fontFamily: label.contains('QR') ? 'monospace' : 'default',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get shortened QR code for display
  String _getShortQRCode(Map<String, dynamic> session) {
    final qrCode = session['qr_code'] as String?;
    if (qrCode == null || qrCode.isEmpty) {
      return 'N/A';
    }
    return qrCode.length > 20 ? '${qrCode.substring(0, 20)}...' : qrCode;
  }
}
