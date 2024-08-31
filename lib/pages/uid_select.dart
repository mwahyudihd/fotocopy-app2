import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/registrasi_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UidSelect extends StatefulWidget {
  const UidSelect({super.key});

  @override
  State<UidSelect> createState() => _UidSelectState();
}

class _UidSelectState extends State<UidSelect> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _uidController = TextEditingController();
  List _listdata = [];

  Future _getdata() async {
    try {
      var uid = _uidController.text.toString();
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pegawai/${uid.toUpperCase()}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata.add(data);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleSubmit() async {
    _getdata();
    if (formKey.currentState!.validate()) {
      await _getdata();
      if (_listdata.isNotEmpty) {
        if (_listdata[0]['email'] != null) {
          _listdata.clear();
          final snackBar = SnackBar(
            content: Text(
                'Kode [${_uidController.text}], sudah pernah disubmit silahkan gunakan yang lain!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          _listdata.clear();
          final snackBar = SnackBar(
            content: Text('Kode [${_uidController.text}], berhasil disubmit!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegistrasiPage(
                        getId: _uidController.text,
                      )));
        }
      } else {
        _listdata.clear();
        final snackBar = SnackBar(
          content: Text('Kode, tidak valid!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Text(
          'Check Registrasi Code',
          style: TextStyle(color: Colors.amberAccent),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10),
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  controller: _uidController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "UID KODE / REGISTER CODE",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Kode harus di isi!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    onPressed: _handleSubmit,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.amberAccent),
                    ))
              ],
            )),
      ),
    );
  }
}
