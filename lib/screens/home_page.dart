import 'package:flutter/material.dart';
import 'package:flutter_api/api/auth_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();
  String token = "Loading...";
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadTokenAndUser();
  }

  void loadTokenAndUser() async {
    String? savedToken = await authService.getToken();
    Map<String, dynamic>? savedUser = await authService.getUser();
    
    setState(() {
      token = savedToken ?? "No token found";
      user = savedUser;
    });

    // Jika user belum ada di local, ambil dari API
    if (user == null) {
      Map<String, dynamic>? fetchedUser = await authService.fetchUser();
      setState(() {
        user = fetchedUser;
      });
    }
  }

  void logout() async {
    await authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Token: $token', textAlign: TextAlign.center),
            SizedBox(height: 20),
            user != null
                ? Column(
                    children: [
                      Text("Nama: ${user!['name']}"),
                      Text("Email: ${user!['email']}"),
                    ],
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
