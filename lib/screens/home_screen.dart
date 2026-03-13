import 'package:flutter/material.dart';
import 'check_in_screen.dart';
import 'finish_class_screen.dart';
import 'view_history_screen.dart';

/// Home Screen - Navigation hub for the Smart Class Check-in app
/// 
/// This screen serves as the main entry point where students can:
/// - Check in to class (QR + GPS + pre-class reflection)
/// - Finish class (QR + post-class reflection)
/// - View check-in history (future feature)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  /// Build the AppBar with title
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue.shade50,
      centerTitle: true,
      title: const Text(
        'Smart Class Check-in',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build the main body with buttons
  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo / Title
              _buildHeader(),
              const SizedBox(height: 48),

              // Check-in Button
              _buildCheckInButton(context),
              const SizedBox(height: 20),

              // Finish Class Button
              _buildFinishClassButton(context),
              const SizedBox(height: 20),

              // View History Button (disabled for MVP)
              _buildViewHistoryButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header section with app title and description
  Widget _buildHeader() {
    return Column(
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.school,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        const Text(
          'Smart Class Check-in',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Track attendance & reflect on learning',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// Build Check-in button
  Widget _buildCheckInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          _navigateToCheckIn(context);
        },
        icon: const Icon(Icons.login, size: 24),
        label: const Text(
          'Check In',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.green.withOpacity(0.5),
        ),
      ),
    );
  }

  /// Build Finish Class button
  Widget _buildFinishClassButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          _navigateToFinishClass(context);
        },
        icon: const Icon(Icons.logout, size: 24),
        label: const Text(
          'Finish Class',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.orange.withOpacity(0.5),
        ),
      ),
    );
  }

  /// Build View History button
  Widget _buildViewHistoryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ViewHistoryScreen(),
            ),
          );
        },
        icon: const Icon(Icons.history, size: 24),
        label: const Text(
          'View History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.blue.withOpacity(0.5),
        ),
      ),
    );
  }

  /// Navigate to Check-in Screen
  void _navigateToCheckIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CheckInScreen(),
      ),
    );
  }

  /// Navigate to Finish Class Screen
  void _navigateToFinishClass(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FinishClassScreen(),
      ),
    );
  }
}
