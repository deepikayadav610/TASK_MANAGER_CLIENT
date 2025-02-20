import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

// add here for the contact message by connecting to the backend
  void showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3), // Optionally set duration
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final message = _messageController.text.trim();

      try {
        final response = await ApiService.contactMessage(name, email, message);

        // Debugging: Print the response
        print("API Response: $response");

        if (response != null && response is Map) {
          bool isSuccess = response['success'] == true;

          if (isSuccess) {
            // Successfully sent the message
            showSnackbar(response['message'] ?? "Message sent successfully",
                Colors.blue);
            _formKey.currentState!.reset(); // Reset form after success
          } else {
            // If success is false, show the backend message
            showSnackbar(
                response['message'] ?? "Failed to send message", Colors.red);
          }
        } else {
          // If response format is not as expected
          showSnackbar("Failed to send message", Colors.red);
        }
      } catch (e) {
        // Catch any error and display the error in the Snackbar
        print("Error: $e"); // Debugging the exception
        showSnackbar("Failed to send message: $e", Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "We'd love to hear from you!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: "Your Name",
                        icon: Icons.person,
                        validator: (value) =>
                            value!.isEmpty ? "Enter your name" : null,
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: _emailController,
                        label: "Your Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                    .hasMatch(value!)
                                ? "Enter a valid email"
                                : null,
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: _messageController,
                        label: "Message",
                        icon: Icons.message,
                        maxLines: 4,
                        validator: (value) =>
                            value!.isEmpty ? "Enter your message" : null,
                      ),
                      SizedBox(height: 20),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            ContactInfo(icon: Icons.email, text: "deepikaydv6104@gmail.com"),
            // ContactInfo(icon: Icons.phone, text: "+91 6389912500"),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: _submitForm,
        child: Text("Submit",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  ContactInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
