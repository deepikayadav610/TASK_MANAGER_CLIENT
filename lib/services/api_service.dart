import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://task-manager-api-se18.onrender.com/api"; // Update API URL

  // Register User
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/register");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      print("Debug - Response Code: ${response.statusCode}");
      print("Debug - Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      // ✅ Accept both 200 OK & 201 Created
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data; // ✅ Return successful response
      } else {
        throw Exception("Failed to register user: ${data['message']}");
      }
    } catch (e) {
      throw Exception("Error during registration: $e");
    }
  }

  // Login User
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to login: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error during login: $e");
    }
  }

  // Fetch all tasks for a specific user
  static Future<List<Map<String, dynamic>>> fetchTasks(String userId) async {
    if (userId.isEmpty) {
      throw Exception("User ID cannot be empty");
    }

    final url = Uri.parse("$baseUrl/tasks?userId=$userId");
    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load tasks: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching tasks: $e");
    }
  }

  // Add a new task for a user
  static Future<Map<String, dynamic>> addTask(
      String userId, String title, String description) async {
    if (userId.isEmpty) {
      throw Exception("User ID cannot be empty");
    }

    final url = Uri.parse("$baseUrl/tasks");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "title": title,
          "description": description,
          "completed": false,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to add task: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

  // Update a task (toggle completion)
  static Future<Map<String, dynamic>> updateTask(
      String taskId, String title, String description, bool completed) async {
    final url = Uri.parse("$baseUrl/tasks/$taskId");
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "description": description,
          "completed": completed,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to update task: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error updating task: $e");
    }
  }

  // Delete a task
  static Future<void> deleteTask(String taskId) async {
    final url = Uri.parse("$baseUrl/tasks/$taskId");
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return; // Successfully deleted, no need to return anything.
      } else {
        throw Exception("Failed to delete task: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }

  // for contactMessage
  static Future<Map<String, dynamic>> contactMessage(
      String name, String email, String message) async {
    final url = Uri.parse("$baseUrl/contact");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "message": message,
        }),
      );

      // Debugging: Print response details
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        // Handle successful creation
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          return responseBody; // Return success response data
        } else {
          throw Exception("Failed to send message: ${responseBody['message']}");
        }
      } else {
        throw Exception("Failed to send message: ${response.body}");
      }
    } catch (e) {
      // Catch any error and throw an exception with the error message
      print("Error: $e");
      throw Exception("Error sending message: $e");
    }
  }
}
