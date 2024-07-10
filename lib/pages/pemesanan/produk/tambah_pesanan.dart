import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/transaksi_produk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahPesanan extends StatefulWidget {
  String? isId;
  String? isName;
  String? isHarga;
  int? isStok;
  TambahPesanan({super.key, this.isId, this.isHarga, this.isName, this.isStok});

  @override
  State<TambahPesanan> createState() => _TambahPesananState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _TambahPesananState extends State<TambahPesanan> {
  late final jenisSet;
  late final kodeSet;
  late final hargaSet;

  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController jenis = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController kodeUnit = TextEditingController();
  TextEditingController harga = TextEditingController();

  @override
  void initState() {
    super.initState();
    jenisSet = widget.isName ?? '';
    kodeSet = widget.isId ?? '';
    hargaSet = widget.isHarga ?? '';
    jenis = TextEditingController(text: jenisSet);
    kodeUnit = TextEditingController(text: kodeSet);
    harga = TextEditingController(text: hargaSet);
  }

  Future _updateStokProdukIfChecked() async {
    final int totalStok =
        int.parse(widget.isStok.toString()) - int.parse(jumlah.text);
    final response = await http.put(
      Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/produk/${widget.isId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nama": widget.isName.toString(),
        "harga": widget.isHarga.toString(),
        "stok": totalStok.toString()
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future _simpan() async {
    final response = await http.post(
        Uri.parse(
            'https://hafiz.barudakkoding.com/fotocopy-api/public/pelanggan'),
        body: {
          "nama_pelanggan": nama.text.capitalize(),
          "jenis_pesanan": jenis.text.capitalize(),
          "alamat": alamat.text.capitalize(),
          "jumlah_unit": jumlah.text,
          "kode_unit": kodeUnit.text,
          "kategori": 'produk',
          "harga_unit": harga.text
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
            'Tambah Pesanan',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
        body: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                SizedBox(height: 150),
                _formInput(nama, true, "Nama Pelanggan", false),
                SizedBox(height: 15),
                _formInput(jenis, true, "Jenis Pesanan", true),
                SizedBox(height: 15),
                _formInput(alamat, true, "Alamat", false),
                SizedBox(
                  height: 8.0,
                ),
                _formInput(jumlah, false, "Jumlah Unit", false),
                SizedBox(
                  height: 8.0,
                ),
                _formInput(kodeUnit, true, "Kode Unit", true),
                SizedBox(
                  height: 8.0,
                ),
                _formInput(harga, false, "Harga unit", true),
                SizedBox(height: 50),
                Container(
                  height: 60,
                  width: 171,
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        _updateStokProdukIfChecked();
                        _simpan();
                        const snackBar = SnackBar(
                          content:
                              Text('Yay! Pesanan berhasil ditambahkan antrian'),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListPesananProduk()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (errorData) {
                        const snackBar = SnackBar(
                          content: Text(
                              'Ups! Pesanan gagal ditambahkan antrian karena'),
                        );
                        print(errorData);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
