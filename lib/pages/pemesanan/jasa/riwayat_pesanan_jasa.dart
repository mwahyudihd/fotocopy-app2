import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/tabel_data_jasa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/invoice_preview_jasa.dart';

class RiwayatPesananJasa extends StatefulWidget {
  const RiwayatPesananJasa({super.key});

  @override
  State<RiwayatPesananJasa> createState() => _RiwayatPesananJasaState();
}

class _RiwayatPesananJasaState extends State<RiwayatPesananJasa> {
  List _listdata = [];
  bool _isloading = true;
  String _userEmail = '';
  String _userId = '';
  String _role = '';
  List _listdataProduk = [];

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan_status_js/selesai'));
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
          'Data Riwayat Pesanan | Jasa',
          style: TextStyle(color: Colors.amberAccent),
        ),
        actions: <Widget>[
          if (_role == 'casier')
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TabelDataJasa()));
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
            )
          : _listdata.length < 1
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
                        trailing:
                            Text('${_listdata[index]['jumlah_unit']}/unit'),
                        tileColor: Colors.amberAccent,
                        onTap: () async {
                          final kodePesanan = _listdata[index]['kode_pesanan'];
                          final tgl = _listdata[index]['create_on'];
                          final jmlUnit = _listdata[index]['jumlah_unit'];
                          final kdUnit = _listdata[index]['kode_unit'];
                          final nmPemesan = _listdata[index]['nama_pelanggan'];
                          final hargaUnit = _listdata[index]['harga_unit'];
                          final namaPesanan = _listdata[index]['jenis_pesanan'];
                          final dilayaniOleh = _listdata[index]['alamat'];
                          final int amountTotal =
                              int.parse(hargaUnit.toString()) *
                                  int.parse(jmlUnit.toString());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InvoicePreviewJasa(
                                    kodePesanan: kodePesanan,
                                    tglPesan: tgl,
                                    jmlUnit: jmlUnit,
                                    kodeUnit: kdUnit,
                                    namaPemesan: nmPemesan,
                                    getHargaUnit: hargaUnit,
                                    totalAmount: amountTotal.toString(),
                                    namaJenis: namaPesanan,
                                    dilayaniOleh: dilayaniOleh,
                                  )));
                        },
                      ),
                    );
                  }),
                ),
    );
  }
}
