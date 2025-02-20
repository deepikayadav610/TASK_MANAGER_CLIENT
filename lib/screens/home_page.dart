import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'manage_task.dart';
import 'contact_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  String userId = '';

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  // Check if user is authenticated
  void checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? savedUserId = prefs.getString('user_id');

    if (token != null && savedUserId != null) {
      setState(() {
        isLoggedIn = true;
        userId = savedUserId;
      });
    }
  }

  // Logout function
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');

    setState(() {
      isLoggedIn = false;
      userId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawerMenu(),
      body: isLoggedIn ? ManageTaskPage(userId: userId) : _buildWelcomeScreen(),
    );
  }

  // Customized AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Task Manager",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 5.0,
    );
  }

  // Side Drawer Menu
  Widget _buildDrawerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Manager",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                SizedBox(height: 8),
                Text("Manage your tasks efficiently!",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.login, color: Colors.blueAccent),
            title: Text("Login"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add, color: Colors.blueAccent),
            title: Text("Register"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RegisterPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail, color: Colors.blueAccent),
            title: Text("Contact Me"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ContactPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blueAccent),
            title: Text("About"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutPage()));
            },
          ),
          Divider(),
          if (isLoggedIn)
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text("Logout"),
              onTap: logout,
            ),
        ],
      ),
    );
  }

  // Welcome screen for unauthenticated users
  Widget _buildWelcomeScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome to Task Manager",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Easily manage your tasks and boost productivity!\nLogin or register to get started.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // Action buttons for login and registration
  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
          child: Text("Login", style: TextStyle(fontSize: 18)),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RegisterPage()));
          },
          child: Text("Register", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
