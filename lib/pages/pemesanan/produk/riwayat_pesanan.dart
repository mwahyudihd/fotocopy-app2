import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/home_views/home_page.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/invoice_preview.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/tabel_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class ListRiwayatPesananProduk extends StatefulWidget {
  const ListRiwayatPesananProduk({super.key});
  @override
  _ListRiwayatPesananProdukState createState() =>
      _ListRiwayatPesananProdukState();
}

class _ListRiwayatPesananProdukState extends State<ListRiwayatPesananProduk> {
  List _listdata = [];
  bool _isloading = true;
  String _userEmail = '';
  String _userId = '';
  String _role = '';
  List _listdataProduk = [];

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan_status_pdk/selesai'));
      if (response.statusCode == 200) {
        // print(response.body);
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('userEmail') ?? '';
      _userId = prefs.getString('userId') ?? '';
      _role = prefs.getString('role') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: IconThemeData(color: Colors.amberAccent),
        title: const Text(
          'Data Riwayat Pesanan | Produk',
          style: TextStyle(color: Colors.amberAccent),
        ),
        actions: <Widget>[
          if (_role == 'casier')
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TabelPageTrProduk()));
              },
              icon: Icon(
                Icons.add_to_queue_sharp,
                color: Colors.amberAccent,
              ),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                _isloading = true;
              });
              _getdata();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.amberAccent,
            ),
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            ) : _listdata.length < 1
              ? Container(
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset('assets/no-data.gif'),
                        Text('Belum Ada Data!', style: TextStyle(color: Colors.brown, fontSize: 24),),
                      ],
                    ),
                  )
                )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      '${_listdata[index]['nama_pelanggan']} - ${_listdata[index]['jenis_pesanan']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(_listdata[index]['kategori']),
                    leading: Icon(Icons.paste_rounded),
                    trailing: Text('${_listdata[index]['jumlah_unit']}/unit'),
                    tileColor: Colors.amberAccent,
                    onTap: () async {
                      final kodePesanan = _listdata[index]['kode_pesanan'];
                      final tgl = _listdata[index]['create_on'];
                      final jmlUnit = _listdata[index]['jumlah_unit'];
                      final kdUnit = _listdata[index]['kode_unit'];
                      final nmPemesan = _listdata[index]['nama_pelanggan'];
                      final hargaUnit = _listdata[index]['harga_unit'];
                      final namaPesanan = _listdata[index]['jenis_pesanan'];
                      final int amountTotal = int.parse(hargaUnit.toString()) *
                          int.parse(jmlUnit.toString());
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InvoicePreview(
                                kodePesanan: kodePesanan,
                                tglPesan: tgl,
                                jmlUnit: jmlUnit,
                                kodeUnit: kdUnit,
                                namaPemesan: nmPemesan,
                                getHargaUnit: hargaUnit,
                                totalAmount: amountTotal.toString(),
                                namaJenis: namaPesanan,
                              )));
                    },
                  ),
                );
              }),
            ),
    );
  }
}
