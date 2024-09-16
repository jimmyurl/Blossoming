import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'api_service.dart'; // Ensure this path is correct

class ImageCaptureScreen extends StatefulWidget {
  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  final ApiService _apiService = ApiService();
  List<String> _imageBase64List = [];
  List<dynamic> _results = [];

  Future<void> _pickAndUploadImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      _imageBase64List = result.files.map((file) {
        final bytes = file.bytes!;
        return base64Encode(bytes);
      }).toList();

      try {
        final results = await _apiService.batchProcessImages(_imageBase64List);
        setState(() {
          _results = results;
        });
      } catch (e) {
        // Handle error
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Capture and Processing'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickAndUploadImages,
            child: const Text('Upload and Process Images'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return ListTile(
                  title: Text(
                      'Image ${index + 1}: ${result['count']} flowers detected'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
