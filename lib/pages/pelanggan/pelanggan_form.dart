import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController jumlah = TextEditingController();
  TextEditingController kode = TextEditingController();
  TextEditingController kategori = TextEditingController(text: 'produk');
  TextEditingController harga = TextEditingController();

  Future _simpan() async {
    final response = await http.post(
        Uri.parse(
            'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan'),
        body: {
          "nama_pelanggan": nama.text.capitalize(),
          "jenis_pesanan": jenis.text.capitalize(),
          "alamat": alamat.text.capitalize(),
          "jumlah_unit": jumlah.text,
          "kode_unit": kode.text.toString(),
          "kategori": kategori.text.toString(),
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
            'Tambah Data',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
        body: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                SizedBox(height: 80),
                _formInput(nama, true, "Nama Pelanggan", false),
                SizedBox(height: 15),
                _formInput(jenis, true, "Jenis / Nama yang Pesanan", false),
                SizedBox(height: 15),
                _formInput(alamat, true, "Alamat", false),
                SizedBox(height: 15),
                _formInput(jumlah, false, "Jumlah Unit", false),
                SizedBox(
                  height: 15,
                ),
                _formInput(kode, true, "Kode Unit", false),
                SizedBox(
                  height: 15,
                ),
                _dropDownInput(kategori, "Kategori Pesanan", "produk", "jasa"),
                SizedBox(height: 15,),
                _formInput(harga, false, "Harga unit", false),
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
