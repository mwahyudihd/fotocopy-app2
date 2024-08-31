import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pelanggan/tabel_page.dart';
import 'package:http/http.dart' as http;

class PelangganEdit extends StatefulWidget {
  final String? isId;
  final String? isNama;
  final String? isJenis;
  final String? isAlamat;
  final String? isStatus;
  final String? isJmlUnit;
  final String? isKodeUnit;
  final String? isKodePesanan;
  final String? isKategori;
  final String? isHarga;
  const PelangganEdit(
      {super.key,
      this.isId,
      this.isNama,
      this.isJenis,
      this.isAlamat,
      this.isJmlUnit,
      this.isKodePesanan,
      this.isKodeUnit,
      this.isStatus,
      this.isKategori,
      this.isHarga});

  @override
  State<PelangganEdit> createState() => _PelangganEditState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _PelangganEditState extends State<PelangganEdit> {
  final formKey = GlobalKey<FormState>();
  late final String textAwal;
  late final String textDua;
  late final String textTiga;
  late final String textEmpat;
  late final String textLima;
  late final String textEnam;
  late final String textTujuh;
  late final String textDelapan;

  TextEditingController nama = TextEditingController();
  TextEditingController jenis = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController kodeUnit = TextEditingController();
  TextEditingController jumlahUnit = TextEditingController();
  TextEditingController kategori = TextEditingController();
  TextEditingController harga = TextEditingController();

  @override
  void initState() {
    super.initState();
    textAwal = widget.isNama ?? '';
    textDua = widget.isJenis ?? '';
    textTiga = widget.isAlamat ?? '';
    textEmpat = widget.isStatus ?? 'belum';
    textLima = widget.isJmlUnit ?? '';
    textEnam = widget.isKodeUnit ?? '';
    textTujuh = widget.isKategori ?? 'produk';
    textDelapan = widget.isHarga ?? '';
    nama = TextEditingController(text: textAwal);
    jenis = TextEditingController(text: textDua);
    alamat = TextEditingController(text: textTiga);
    status = TextEditingController(text: textEmpat);
    jumlahUnit = TextEditingController(text: textLima);
    kodeUnit = TextEditingController(text: textEnam);
    kategori = TextEditingController(text: textTujuh);
    kategori = TextEditingController(text: textDelapan);
  }

  Future _simpan() async {
    final response = await http.put(
      Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan/${widget.isId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nama_pelanggan": nama.text.capitalize(),
        "jenis_pesanan": jenis.text,
        "alamat": alamat.text.capitalize(),
        "status": status.text,
        "jumlah_unit": jumlahUnit.text,
        "kode_unit": kodeUnit.text,
        "kategori": kategori.text,
        "kode_pesanan": widget.isKodePesanan.toString(),
        "harga_unit": harga.text
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
                SizedBox(height: 100),
                _formInput(nama, true, "Nama Pelanggan", false),
                SizedBox(height: 15),
                _formInput(jenis, true, "Jenis / Nama Jenis Pesanan", false),
                SizedBox(height: 15),
                _formInput(alamat, true, "Alamat", false),
                SizedBox(
                  height: 15,
                ),
                _dropDownInput(status, "Status", "belum", "selesai"),
                SizedBox(
                  height: 15,
                ),
                _formInput(jumlahUnit, false, "Jumlah Unit", false),
                SizedBox(
                  height: 15,
                ),
                _dropDownInput(kategori, "Kategori Pesanan", "produk", "jasa"),
                SizedBox(
                  height: 15,
                ),
                _formInput(kodeUnit, true, "Kode Unit yang dipesan", false),
                SizedBox(
                  height: 15,
                ),
                _formInput(harga, false, "Harga unit", false),
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

Widget _formInput(ctrl, bool typeData, String dataName, bool isFilled) {
  return TextFormField(
    readOnly: isFilled,
    controller: ctrl,
    keyboardType: typeData ? TextInputType.text : TextInputType.number,
    decoration: InputDecoration(
      hintText: dataName,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      filled: isFilled,
      fillColor: Colors.amberAccent,
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return "alamat ${dataName} harus di isi!";
      }
      return null;
    },
  );
}

Widget _dropDownInput(
    ctrl, String isNameHint, String firstVal, String secondVal) {
  return DropdownButtonFormField<String>(
    value: ctrl.text,
    onChanged: (value) {
      ctrl.text = value!;
    },
    decoration: InputDecoration(
      hintText: '$isNameHint',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    ),
    items: [
      DropdownMenuItem(
        value: '$firstVal',
        child: Text('$firstVal'),
      ),
      DropdownMenuItem(
        value: '$secondVal',
        child: Text('$secondVal'),
      ),
    ],
  );
}
