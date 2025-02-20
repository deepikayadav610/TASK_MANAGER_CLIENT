import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageTaskPage extends StatefulWidget {
  final String userId;

  ManageTaskPage({required this.userId});

  @override
  _ManageTaskPageState createState() => _ManageTaskPageState();
}

class _ManageTaskPageState extends State<ManageTaskPage> {
  final String apiUrl = "https://task-manager-api-se18.onrender.com/api/tasks";
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _editingTaskId;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    if (widget.userId.isEmpty) {
      _showSnackbar("Error: userId is empty");
      return;
    }

    String url = "$apiUrl/${widget.userId}";
    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        setState(() {
          _tasks = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        _showSnackbar("Failed to fetch tasks! (${response.statusCode})");
      }
    } catch (e) {
      _showSnackbar("Error fetching tasks: $e");
    }
  }

  Future<void> _addOrUpdateTask() async {
    if (_titleController.text.isEmpty) {
      _showSnackbar("Task title cannot be empty!");
      return;
    }

    final task = {
      'userId': widget.userId,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    };

    try {
      if (_editingTaskId == null) {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(task),
        );

        if (response.statusCode == 201) {
          _showSnackbar("Task added successfully!");
        } else {
          _showSnackbar("Error adding task: ${response.body}");
        }
      } else {
        final response = await http.put(
          Uri.parse("$apiUrl/$_editingTaskId"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(task),
        );

        if (response.statusCode == 200) {
          _showSnackbar("Task updated successfully!");
        } else {
          _showSnackbar("Error updating task: ${response.body}");
        }
      }

      _titleController.clear();
      _descriptionController.clear();
      _editingTaskId = null;
      _fetchTasks();
      Navigator.pop(context);
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }

  void _editTask(int index) {
    setState(() {
      _editingTaskId = _tasks[index]['_id'];
      _titleController.text = _tasks[index]['title'];
      _descriptionController.text = _tasks[index]['description'] ?? "";
    });
    _showAddOrEditTaskDialog();
  }

  Future<void> _deleteTask(int index) async {
    final String taskId = _tasks[index]['_id'];

    try {
      final response = await http.delete(Uri.parse("$apiUrl/$taskId"),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        _showSnackbar("Task deleted successfully!");
        _fetchTasks(); // Refresh the list after deletion
      } else {
        _showSnackbar("Error deleting task: ${response.body}");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }

  void _showAddOrEditTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Task Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text(_editingTaskId == null ? "Add Task" : "Update Task",
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _toggleCompleteTask(int index) async {
    final String taskId = _tasks[index]['_id'];
    final bool isCompleted = _tasks[index]['completed'] ?? false;

    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$taskId"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'completed': !isCompleted}),
      );

      if (response.statusCode == 200) {
        _showSnackbar(
            "Task marked as ${!isCompleted ? 'completed' : 'incomplete'}");
        _fetchTasks(); // Refresh the task list
      } else {
        _showSnackbar("Error updating task: ${response.body}");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Tasks")),
      body: _tasks.isEmpty
          ? const Center(
              child: Text("No tasks yet, add some!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(_tasks[index]['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle:
                        Text(_tasks[index]['description'] ?? "No description"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Circle button to toggle completion
                        GestureDetector(
                          onTap: () => _toggleCompleteTask(index),
                          child: CircleAvatar(
                            radius: 12, // Small size of the circle
                            backgroundColor: _tasks[index]['completed'] ?? false
                                ? Colors.green
                                : Colors.grey,
                            child: Icon(
                              _tasks[index]['completed'] ?? false
                                  ? Icons.check
                                  : Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editTask(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editingTaskId = null;
          _titleController.clear();
          _descriptionController.clear();
          _showAddOrEditTaskDialog();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
