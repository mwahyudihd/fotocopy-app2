import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/jasa/tabel_page.dart';
import 'package:http/http.dart' as http;

class JasaForm extends StatefulWidget {
  const JasaForm({super.key});

  @override
  State<JasaForm> createState() => _JasaFormState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _JasaFormState extends State<JasaForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController pegawai = TextEditingController();
  Future _simpan() async {
    final response = await http.post(
        Uri.parse('https://wahyudi.barudakkoding.com/fotocopy-api/public/jasa'),
        body: {
          "nama_jasa": nama.text.capitalize(),
          "harga": harga.text,
          "nama_pegawai": pegawai.text.capitalize(),
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
            color: Colors.amberAccent,
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
              child: Column(
                children: [
                SizedBox(height: 150),
                TextFormField(
                  controller: nama,
                  decoration: InputDecoration(
                    hintText: "Nama Jasa",
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
                TextFormField(
                  controller: harga,
                  decoration: InputDecoration(
                    hintText: "Harga",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Harus di isi!";
                    } else if (!isNumeric(value)) {
                      return "Harga harus berupa Angka!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: pegawai,
                  decoration: InputDecoration(
                    hintText: "Pegawai",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama Pegawai harus di isi!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                Container(
                  height: 60,
                  width: 171,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _simpan().then((value) {
                          if (value) {
                            final snackBar = SnackBar(
                              content: const Text('Data, berhasil ditambahkan!'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                                content:
                                    const Text('OPS!,Gagal Menyimpan data.'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => TabelPage())),
                              (route) => false);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent),
                    child: 
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child: Text(
                            'Simpan ',
                            style: TextStyle(color: Colors.brown, fontSize: 26),
                          ),
                        ),
                        Icon(Icons.save, color: Colors.brown,),
                      ],
                    ),
                  ),
                ),
              ]),
            )));
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
