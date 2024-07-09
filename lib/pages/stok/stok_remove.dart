import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fotocopy_app/pages/stok/stok_detail.dart';

class StokFormRemove extends StatefulWidget {
  final String? getKode;
  final String? getNama;
  final String? getHarga;
  final String? getStok;
  final String? getId;

  const StokFormRemove(
      {super.key,
      this.getId,
      this.getKode,
      this.getNama,
      this.getHarga,
      this.getStok});

  @override
  State<StokFormRemove> createState() => _StokFormRemoveState();
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : '';
  }
}

class _StokFormRemoveState extends State<StokFormRemove> {
  late final String codeSet;
  late final String nameSet;
  late final String priceSet;
  late final String stokSet;

  late final String idData;

  final formKey = GlobalKey<FormState>();
  TextEditingController stock = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeSet = widget.getKode ?? '';
    nameSet = widget.getNama ?? '';
    priceSet = widget.getHarga ?? '';
    stokSet = widget.getStok ?? '';
  }

  Future _simpan() async {
    final int totalStok = int.parse(stokSet) - int.parse(stock.text);
    final response = await http.put(
      Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/produk/${widget.getId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "kode": codeSet,
        "nama": nameSet,
        "harga": priceSet,
        "stok": totalStok.toString()
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
            'Kurangi Stok',
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
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  controller: stock,
                  decoration: InputDecoration(
                    hintText: "Jumlah yang kurangi",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jumlah yang ingin ditambahkan Harus di isi!";
                    } else if (!isNumeric(value)) {
                      return "Jumlah harus berupa Angka!";
                    }
                    double? numberValue = double.tryParse(value);
                    if (numberValue == null || numberValue < 0) {
                      return 'Harap masukkan angka tanpa simbol';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  width: 175,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        idData = widget.getId.toString();
                      });
                      if (formKey.currentState!.validate()) {
                        _simpan().then((value) {
                          if (value) {
                            final snackBar = SnackBar(
                              content:
                                  const Text('Stok, berhasil ditakurangi!'),
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
                                  builder: ((context) => ProdukDetail(
                                        isId: idData,
                                      ))),
                              (route) => true);
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
                            'Kurangi ',
                            style: TextStyle(color: Colors.brown, fontSize: 26),
                          ),
                        ),
                        Icon(
                          Icons.remove_circle_outline,
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
