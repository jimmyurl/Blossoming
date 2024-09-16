import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://localhost:5000'; // Replace with your backend URL

  // Method to batch process images
  Future<List<dynamic>> batchProcessImages(List<String> imageBase64List) async {
    final response = await http.post(
      Uri.parse('$baseUrl/batch-process'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'images': imageBase64List}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process images');
    }
  }

  // Method to count flowers in a single image (if applicable)
  Future<int> countFlowers(String imageBase64) async {
    final response = await http.post(
      Uri.parse('$baseUrl/count-flowers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': imageBase64}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to count flowers');
    }
  }
}
