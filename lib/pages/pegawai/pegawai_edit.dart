import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fotocopy_app/pages/pegawai/pegawai_page.dart';

class PegawaiFormEdit extends StatefulWidget {
  final String? getNama;
  final String? getJobdesk;
  final String? getTelp;
  final String? getGaji;
  final String? getId;

  const PegawaiFormEdit(
      {super.key,
      this.getNama,
      this.getJobdesk,
      this.getTelp,
      this.getGaji,
      this.getId});

  @override
  State<PegawaiFormEdit> createState() => _PegawaiFormEditState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _PegawaiFormEditState extends State<PegawaiFormEdit> {
  late final String nameSet;
  late final String jobSet;
  late final String tlpSet;
  late final String gajiSet;
  late final String uidSet;

  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController jobdesk = TextEditingController();
  TextEditingController notelp = TextEditingController();
  TextEditingController gaji = TextEditingController();
  TextEditingController uid = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameSet = widget.getNama ?? '';
    jobSet = widget.getJobdesk ?? '';
    tlpSet = widget.getTelp ?? '';
    gajiSet = widget.getGaji ?? '';
    uidSet = widget.getId ?? '';
    nama = TextEditingController(text: nameSet);
    jobdesk = TextEditingController(text: jobSet);
    notelp = TextEditingController(text: tlpSet);
    gaji = TextEditingController(text: gajiSet);
    uid = TextEditingController(text: uidSet);
  }

  Future _simpan() async {
    final response = await http.put(
      Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pegawai_job/${widget.getId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "jobdesk": jobdesk.text.capitalize(),
        "gaji": gaji.text,
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
            'Edit Jobdesk dan Gaji',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
        body: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                TextField(
                  readOnly: true,
                  controller: uid,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.amber,
                    hintText: "UID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                    controller: nama,
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: Colors.amber,
                      filled: true,
                      hintText: "Nama Pegawai",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
                SizedBox(height: 15),
                TextFormField(
                  controller: jobdesk,
                  decoration: InputDecoration(
                    hintText: "Jobdesk",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jobdesk harus di isi!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  readOnly: true,
                  controller: notelp,
                  decoration: InputDecoration(
                    fillColor: Colors.amber,
                    filled: true,
                    hintText: "Nomor Telpon",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: gaji,
                  decoration: InputDecoration(
                    hintText: "Jumlah gaji",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jumlah gaji Harus di isi!";
                    } else if (!isNumeric(value)) {
                      return "Jumlah gaji harus berupa Angka!";
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
                              content: const Text('Data, berhasil diedit!'),
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
