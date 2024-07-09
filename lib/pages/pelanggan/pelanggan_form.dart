import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pelanggan/tabel_page.dart';
import 'package:http/http.dart' as http;

class PelangganForm extends StatefulWidget {
  const PelangganForm({super.key});

  @override
  State<PelangganForm> createState() => _PelangganFormState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _PelangganFormState extends State<PelangganForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController jenis = TextEditingController();
  TextEditingController alamat = TextEditingController();
  Future _simpan() async {
    final response = await http.post(
        Uri.parse(
            'https://hafiz.barudakkoding.com/fotocopy-api/public/pelanggan'),
        body: {
          "nama_pelanggan": nama.text.capitalize(),
          "jenis_pesanan": jenis.text.capitalize(),
          "alamat": alamat.text.capitalize(),
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
              child: Column(children: [
                SizedBox(height: 150),
                TextFormField(
                  controller: nama,
                  decoration: InputDecoration(
                    hintText: "Nama pelanggan",
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
                  controller: jenis,
                  decoration: InputDecoration(
                    hintText: "Jenis_pesanan",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jenis pesanan Harus di isi!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: alamat,
                  decoration: InputDecoration(
                    hintText: "alamat",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "alamat Pegawai harus di isi!";
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
                                  builder: ((context) => TabelPage2())),
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
                            'Simpan ',
                            style: TextStyle(color: Colors.brown, fontSize: 26),
                          ),
                        ),
                        Icon(
                          Icons.save,
                          color: Colors.brown,
                        ),
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
