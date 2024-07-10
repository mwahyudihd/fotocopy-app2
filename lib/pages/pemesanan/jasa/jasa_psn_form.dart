import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/jasa_transaksi.dart';
import 'package:http/http.dart' as http;

class JasaPsnForm extends StatefulWidget {
  String? isId;
  String? isName;
  String? isHarga;
  String? namaPelayan;
  JasaPsnForm(
      {super.key, this.isId, this.isHarga, this.isName, this.namaPelayan});

  @override
  State<JasaPsnForm> createState() => _JasaPsnFormState();
}

class _JasaPsnFormState extends State<JasaPsnForm> {
  late final jenisSet;
  late final kodeSet;
  late final hargaSet;
  late final namaPegawaiSet;

  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController jenis = TextEditingController();
  TextEditingController dilayani = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController kodeUnit = TextEditingController();
  TextEditingController harga = TextEditingController();

  @override
  void initState() {
    super.initState();
    jenisSet = widget.isName ?? '';
    kodeSet = widget.isId ?? '';
    hargaSet = widget.isHarga ?? '';
    namaPegawaiSet = widget.namaPelayan ?? '';
    jenis = TextEditingController(text: jenisSet);
    kodeUnit = TextEditingController(text: kodeSet);
    harga = TextEditingController(text: hargaSet);
    dilayani = TextEditingController(text: namaPegawaiSet);
  }

  Future _simpan() async {
    final response = await http.post(
        Uri.parse(
            'https://hafiz.barudakkoding.com/fotocopy-api/public/pelanggan'),
        body: {
          "nama_pelanggan": nama.text,
          "jenis_pesanan": jenis.text,
          "alamat": dilayani.text,
          "jumlah_unit": jumlah.text,
          "kode_unit": kodeUnit.text,
          "kategori": 'jasa',
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
                _formInput(dilayani, true, "Nama Yang Melayani", true),
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
                        _simpan();
                        const snackBar = SnackBar(
                          content:
                              Text('Yay! Pesanan berhasil ditambahkan antrian'),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JasaTransaksi()));
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
