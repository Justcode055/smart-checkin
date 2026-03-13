import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// QR Scanner Screen - Full-screen camera view for QR code scanning
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController? _scannerController;
  bool _isScanning = false;
  bool _isWebPlatform = false;

  @override
  void initState() {
    super.initState();
    
    // Check if running on web
    _isWebPlatform = kIsWeb;
    
    if (_isWebPlatform) {
      _scannerController = null;
      // Show manual input dialog on web
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showManualQrInput();
      });
    } else {
      _scannerController = MobileScannerController(
        facing: CameraFacing.back,
        torchEnabled: false,
      );
    }
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  /// Show manual QR input dialog for web testing
  void _showManualQrInput() {
    final TextEditingController textController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Camera not available on this platform.\nPlease enter a test QR code manually.'),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter QR code (e.g., CLASS_001)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.qr_code_2),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Navigator.pop(context);
                Navigator.pop(context, textController.text);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Handle detected QR code
  void _onDetect(BarcodeCapture capture) {
    if (_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty) {
      final String? scannedValue = barcodes.first.rawValue;
      
      if (scannedValue != null && scannedValue.isNotEmpty) {
        setState(() => _isScanning = true);
        Navigator.pop(context, scannedValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: _isWebPlatform ? _buildWebPlaceholder() : _buildCameraView(),
    );
  }

  /// Build web platform placeholder
  Widget _buildWebPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.white70),
          const SizedBox(height: 16),
          const Text(
            'Camera QR Scanner\nRunning in Manual Input Mode',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check the input dialog above',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Build camera view for mobile
  Widget _buildCameraView() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              MobileScanner(
                controller: _scannerController!,
                onDetect: _onDetect,
                errorBuilder: (context, error, child) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          'Camera Error:\n${error.errorCode.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _showManualQrInput(),
                          child: const Text('Use Manual Input'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // QR Code scan frame overlay
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom controls
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black87,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Torch toggle
                  ValueListenableBuilder(
                    valueListenable: _scannerController!.torchState,
                    builder: (context, state, child) {
                      return FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white12,
                        onPressed: () => _scannerController!.toggleTorch(),
                        child: Icon(
                          state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),

                  // Camera facing toggle
                  ValueListenableBuilder(
                    valueListenable: _scannerController!.cameraFacingState,
                    builder: (context, state, child) {
                      return FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white12,
                        onPressed: () => _scannerController!.switchCamera(),
                        child: const Icon(Icons.flip_camera_android, color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Scan QR code within the frame',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
