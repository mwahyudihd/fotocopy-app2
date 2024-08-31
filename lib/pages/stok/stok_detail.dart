import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fotocopy_app/pages/stok/stok_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fotocopy_app/pages/stok/stok_page.dart';
import 'package:fotocopy_app/pages/stok/stok_remove.dart';

class ProdukDetail extends StatefulWidget {
  final String? isId;

  const ProdukDetail({Key? key, this.isId}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  List _listdata = [];
  bool _isloading = true;
  late final String? _setImage;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/produk/${widget.isId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata.add(data);
          _isloading = false;
          int cekData = int.parse(_listdata[0]['stok']);
          if (cekData > 0) {
            _setImage = 'ready-stock.png';
          } else {
            _setImage = 'no_stock.png';
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.amberAccent),
        title: const Center(
          child: Text(
            'Detail Produk',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
        actions: [
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: Colors.amberAccent),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: ((context) => StokPage())),
                  (route) => false);
            },
            icon: Icon(Icons.home_filled),
            color: Colors.brown,
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.only(left: 15),
              padding: const EdgeInsets.all(9.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/${_setImage.toString()}'),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Kode Barang/Produk : ${_listdata[0]["kode_produk"]}',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Jumlah stok : ${_listdata[0]["stok"]}/Unit',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Nama Produk : ${_listdata[0]["nama"]}'),
                    Text(
                        'Harga : ${NumberFormat.currency(locale: "id_ID", symbol: "Rp.", decimalDigits: 0).format(int.parse(_listdata[0]["harga"])).toString()}'),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            final String idSaver = _listdata[0]['kode_produk'];
                            final String namaSaver = _listdata[0]['nama'];
                            final String hargaSaver = _listdata[0]['harga'];
                            final String stokSaver = _listdata[0]['stok'];
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StokFormRemove(
                                      getId: idSaver,
                                      getNama: namaSaver,
                                      getHarga: hargaSaver,
                                      getStok: stokSaver,
                                    )));
                          },
                          label: Text(
                            'Kurangi',
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.amberAccent,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown),
                          onPressed: () {
                            final String idSaver = _listdata[0]['kode_produk'];
                            final String namaSaver = _listdata[0]['nama'];
                            final String hargaSaver = _listdata[0]['harga'];
                            final String stokSaver = _listdata[0]['stok'];
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StokFormPlus(
                                      getId: idSaver,
                                      getNama: namaSaver,
                                      getHarga: hargaSaver,
                                      getStok: stokSaver,
                                    )));
                          },
                          label: Text(
                            'Tambah',
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
