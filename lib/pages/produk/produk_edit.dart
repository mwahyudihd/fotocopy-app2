import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/produk/tabel_page.dart';
import 'package:http/http.dart' as http;

class ProdukEdit extends StatefulWidget {
  final String? isId;
  final String? isName;
  final String? isHarga;
  final String? isStok;
  const ProdukEdit(
      {super.key,
      this.isId,
      this.isName,
      this.isHarga,
      this.isStok});

  @override
  State<ProdukEdit> createState() => _ProdukEditState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _ProdukEditState extends State<ProdukEdit> {
  final formKey = GlobalKey<FormState>();
  late final String textAwal;
  late final String textDua;
  late final String textTiga;
  // late final int stock = int.parse(widget.isStok.toString());

  TextEditingController nama = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController kode = TextEditingController();

  @override
  void initState() {
    super.initState();
    textAwal = widget.isName ?? '';
    textDua = widget.isHarga ?? '';
    textTiga = widget.isId ?? '';
    nama = TextEditingController(text: textAwal);
    harga = TextEditingController(text: textDua);
    kode = TextEditingController(text: textTiga);
  }

  Future _simpan() async {
    final response = await http.put(
      Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/produk/${widget.isId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nama": nama.text.capitalize(),
        "harga": harga.text,
        "stok": "${widget.isStok}",
      }),
    );

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
                    hintText: "Nama Produk",
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
                  readOnly: true,
                  controller: kode,
                  decoration: InputDecoration(
                    fillColor: Colors.amberAccent,
                    filled: true,
                    hintText: "Pegawai",
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
                              content: const Text('Data, berhasil diubah!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                                content:
                                    const Text('OPS!,Gagal mengubah data.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => TabelPage1())),
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
