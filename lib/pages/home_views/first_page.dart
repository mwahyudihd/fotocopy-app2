import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fotocopy_app/pages/login_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    String? role = prefs.getString('role');

    return {
      'userEmail': userEmail,
      'role': role,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text(''),
              ),
              ListTile(
                title: const Text('Logout'),
                trailing: const Icon(Icons.logout),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: _getUserData(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('User data not found'));
              } else {
                int? pegawaiId = snapshot.data!['pegawai_id'];
                String? userEmail = snapshot.data!['userEmail'];
                String? role = snapshot.data!['role'];
                return Container(
                  color: Colors.brown,
                  child: Center(
                    child: Text(
                      "Welcome To Fotocopy App $role",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}