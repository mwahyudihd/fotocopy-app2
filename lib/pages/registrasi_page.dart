import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class RegistrasiPage extends StatefulWidget {
  final String? getId;
  const RegistrasiPage({super.key, this.getId});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaTextboxController = TextEditingController();
  TextEditingController _noTelpTextboxController = TextEditingController();
  TextEditingController _selectedGender = TextEditingController();
  TextEditingController _emailTextboxController = TextEditingController();
  TextEditingController _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REGISTRASI", style: TextStyle(color: Colors.amberAccent),),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _namaTextField(),
                _spacingBox(),
                _noTelpTextField(),
                _spacingBox(),
                _genderDropdown(),
                _spacingBox(),
                _emailTextField(),
                _spacingBox(),
                _passwordTextField(),
                _spacingBox(),
                _passwordKonfirmasiTextField(),
                _spacingBox(),
                _buttonRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //komponen field kolom textbox
  Widget _namaTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nama",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus terdiri dari 3 karakter";
        }
        return null;
      },
    );
  }

  Widget _noTelpTextField() {
    return TextFormField(
      maxLength: 15,
      decoration: InputDecoration(
        labelText: "Nomor Telpon",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      keyboardType: TextInputType.number,
      controller: _noTelpTextboxController,
      validator: (value) {
        if (value!.length < 13) {
          return "Nomor telpon tidak valid!";
        }
        return null;
      },
    );
  }

  Widget _spacingBox() {
    return SizedBox(
      height: 15.0,
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email Address",
        border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        //require
        if (value!.isEmpty) {
          return "Email harus diisi!";
        }
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid!";
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus berisi minimal 6 karakter!";
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Konfirmasi Password",
        border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Password konfirmasi tidak sama!";
        }
        return null;
      },
    );
  }

  //dropdown

  Widget _buttonRegistrasi() {
    return ElevatedButton(
        child: const Text('SUBMIT'),
        onPressed: () {
          _submit();
        });
  }

  Future _simpan() async {
    final response = await http.put(
      Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/pegawai/${widget.getId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nama_pegawai": _namaTextboxController.text.capitalize(),
        "jobdesk": "Baru mendaftar",
        "no_tlp": _noTelpTextboxController.text,
        "gender": _selectedGender.text,
        "gaji": '0',
        "email": _emailTextboxController.text,
        "password": _passwordTextboxController.text
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool success = await _simpan();
        if (success) {
          final snackBar = SnackBar(
            content: Text(
                'Selamat, akun anda berhasil didaftarkan, silahkan login!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        } else {
          throw Exception('Gagal menyimpan data');
        }
      } catch (error) {
        final snackBar = SnackBar(
          content: Text(
              'Ops!, gagal menyimpan data silahkan daftarkan kembali nanti!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    }
  }

  Widget _genderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender.text.isEmpty ? null : _selectedGender.text,
      decoration: InputDecoration(
        hintText: "Gender",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: "Laki-laki",
          child: Text("Laki-laki"),
        ),
        DropdownMenuItem<String>(
          value: "Perempuan",
          child: Text("Perempuan"),
        ),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender.text = newValue!;
        });
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}
