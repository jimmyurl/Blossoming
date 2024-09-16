import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // To handle file system for images
import 'dart:async'; // For timer functionality

void main() {
  runApp(const BlossomingApp());
}

class BlossomingApp extends StatelessWidget {
  const BlossomingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blossoming App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ImageCapturePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageCapturePage extends StatefulWidget {
  const ImageCapturePage({super.key});

  @override
  State<ImageCapturePage> createState() => _ImageCapturePageState();
}

class _ImageCapturePageState extends State<ImageCapturePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Blossoming"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt), text: 'Capture'),
              Tab(icon: Icon(Icons.photo_library), text: 'Gallery'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CaptureTab(),
            GalleryTab(),
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}

class CaptureTab extends StatefulWidget {
  const CaptureTab({super.key});

  @override
  State<CaptureTab> createState() => _CaptureTabState();
}

class _CaptureTabState extends State<CaptureTab> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _metadataController = TextEditingController();
  Timer? _timer; // Timer for capturing images
  bool _isProcessing = false;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isProcessing = true;
    });

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isProcessing = false;
      });
    } else {
      setState(() {
        _isProcessing = false;
      });
      _showSnackbar('No image selected');
    }
  }

  void _startTimedCapture() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_imageFile == null) {
        await _pickImage(ImageSource.camera);
      } else {
        timer.cancel(); // Stop the timer if an image is already captured
        _showSnackbar('Timed capture stopped. Image captured.');
      }
    });
  }

  void _stopTimedCapture() {
    _timer?.cancel();
    _showSnackbar('Timed capture stopped.');
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
      _metadataController.clear();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_imageFile != null)
            Column(
              children: [
                Image.file(
                  _imageFile!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _metadataController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Metadata (e.g., Flower Type, Location)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text("Capture Image"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text("Select from Gallery"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _clearImage,
            child: const Text("Clear Image"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startTimedCapture,
            child: const Text("Start Timed Capture"),
          ),
          ElevatedButton(
            onPressed: _stopTimedCapture,
            child: const Text("Stop Timed Capture"),
          ),
          if (_isProcessing) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample grid view; replace with actual image fetching logic
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 10, // Replace with actual image count
      itemBuilder: (context, index) {
        // Replace with actual image fetching logic
        return Container(
          color: Colors.grey[300],
          child: Center(child: Text('Image $index')),
        );
      },
    );
  }
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _metadataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _metadataController,
            decoration: const InputDecoration(
              labelText: 'Enter Metadata (e.g., Flower Type, Location)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Save metadata action
            },
            child: const Text("Save Metadata"),
          ),
        ],
      ),
    );
  }
}
