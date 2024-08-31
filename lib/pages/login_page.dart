import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/uid_select.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_views/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final String apiUrl =
        'https://wahyudi.barudakkoding.com/fotocopy-api/public/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body) is Map<String, dynamic>) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      final Map<String, dynamic> user = responseData['user'];
      final String role = responseData['role'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', user['id']);
      await prefs.setString('userEmail', user['email']);
      await prefs.setString('role', role);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        if (_emailController.text.length == 0 ||
            _passwordController.text.length == 0) {
          final snackBar = SnackBar(
            content: Text('Kolom input, Harus diisi!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _message = '';
        } else {
          _message = response.body;
          final snackBar = SnackBar(
            content: Text('${_message}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  void _cekUid() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UidSelect()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email Address",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Email, harus diisi!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                return null;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Password, harus diisi!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              onPressed: _login,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.amberAccent),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
                onPressed: () {
                  _cekUid();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text(
                  'Registrasi',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
