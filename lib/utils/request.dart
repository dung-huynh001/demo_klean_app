import 'package:http/http.dart' as http;
import 'dart:convert';

class Request {
  final String _baseUrl = 'https://localhost:7127';

  Request();

  Future<dynamic> get(String endpoint, String? token) async {
    try {
      final res = await http.get(
        _buildUri(endpoint),
        headers: _createHeaders(token)
      );
      return _handleResponse(res);
    } catch(e) {
      throw Exception('Error occurred during GET request: $e');
    }
  }

  Future<dynamic> post(String endpoint, dynamic body, String? token) async {
    try {
      final response = await http.post(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during POST request: $e');
    }
  }

  Future<dynamic> put(String endpoint, dynamic body, String? token) async {
    try {
      final response = await http.put(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during PUT request: $e');
    }
  }

  Future<dynamic> patch(String endpoint, dynamic body, String? token) async {
    try {
      final response = await http.patch(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during PATCH request: $e');
    }
  }

  Future<dynamic> delete(String endpoint, dynamic body, String? token) async {
    try {
      final response = await http.delete(
        _buildUri(endpoint),
        headers: _createHeaders(token),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error occurred during DELETE request: $e');
    }
  }

  Map<String, String> _createHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _buildUri(String endpoint) {
    return Uri.parse('$_baseUrl/$endpoint');
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not Found: ${response.body}');
      case 500:
      default:
        throw Exception('Server Error: ${response.body}');
    }
  }
}