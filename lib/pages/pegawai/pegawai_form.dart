import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fotocopy_app/pages/pegawai/pegawai_page.dart';

class PegawaiForm extends StatefulWidget {
  const PegawaiForm({super.key});

  @override
  State<PegawaiForm> createState() => _PegawaiFormState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _PegawaiFormState extends State<PegawaiForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController(text: 'New Account');
  TextEditingController gender = TextEditingController();

  Future _simpan() async {
    final response = await http
        .post(Uri.parse('https://wahyudi.barudakkoding.com/fotocopy-api/public/pegawai'), body: {
      "nama_pegawai": nama.text.capitalize(),
      "no_tlp": '08',
      "gender": gender.text,
      "gaji": '',
      "email": '',
      "password": ''
    });
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 238, 225, 177),
          ),
          backgroundColor: Colors.brown,
          centerTitle: true,
          title: Text(
            'Tambah Data',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
        body: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  controller: nama,
                  decoration: InputDecoration(
                    fillColor: Colors.amberAccent,
                    filled: true,
                    hintText: "Nama Pegawai",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama harus di isi!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: gender.text.isEmpty
                      ? null
                      : gender.text,
                  decoration: InputDecoration(
                    hintText: "Jenis Kelamin",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      gender.text = newValue!;
                    });
                  },
                  items: <String>['Laki-laki', 'Perempuan']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Jenis kelamin harus diisi!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  width: 171,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _simpan().then((value) {
                          if (value) {
                            final snackBar = SnackBar(
                              content:
                                  const Text('Data, berhasil ditambahkan!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                                content:
                                    const Text('OPS!,Gagal Menyimpan data.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PegawaiPage())),
                              (route) => false);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child: Text(
                            'Tambah ',
                            style: TextStyle(color: Colors.brown, fontSize: 23),
                          ),
                        ),
                        Icon(
                          Icons.person_add_alt_sharp,
                          color: Colors.brown,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )));
  }
}
