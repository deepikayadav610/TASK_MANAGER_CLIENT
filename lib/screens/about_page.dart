import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Task Manager",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildFeatures(),
            SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.task, size: 80, color: Colors.blueAccent),
        SizedBox(height: 10),
        Text(
          "Task Manager App",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "A powerful and intuitive task management solution",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Key Features:",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _featureItem("✓ Add, edit, and delete tasks easily"),
        _featureItem("✓ Organize tasks with categories"),
        _featureItem("✓ Set deadlines and reminders"),
        _featureItem("✓ User authentication and data security"),
        _featureItem("✓ Sync across multiple devices"),
      ],
    );
  }

  Widget _featureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Divider(height: 40, thickness: 1, color: Colors.grey.shade300),
        Text(
          "Version 1.0.0",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        SizedBox(height: 10),
        Text(
          "Developed by Deepika Yadav",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
      ],
    );
  }
}
