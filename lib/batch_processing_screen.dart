import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class BatchProcessingScreen extends StatefulWidget {
  @override
  _BatchProcessingScreenState createState() => _BatchProcessingScreenState();
}

class _BatchProcessingScreenState extends State<BatchProcessingScreen> {
  List<Uint8List?> _images = [];
  List<int> _flowerCounts = [];

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _images = result.files.map((file) => file.bytes).toList();
        _flowerCounts = List.filled(_images.length, 0);
      });
    }
  }

  Future<void> _countFlowersInBatch() async {
    // Add API logic here to send images and receive flower count
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batch Flower Counting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Select Images for Batch Processing'),
            ),
            if (_images.isNotEmpty)
              ElevatedButton(
                onPressed: _countFlowersInBatch,
                child: Text('Count Flowers in Batch'),
              ),
            // Display flower counts for each image
          ],
        ),
      ),
    );
  }
}
