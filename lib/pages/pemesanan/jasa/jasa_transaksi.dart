import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/riwayat_pesanan_jasa.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/tabel_data_jasa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JasaTransaksi extends StatefulWidget {
  const JasaTransaksi({super.key});

  @override
  State<JasaTransaksi> createState() => _JasaTransaksiState();
}

class _JasaTransaksiState extends State<JasaTransaksi> {
  List _listdata = [];
  bool _isloading = true;
  String _userEmail = '';
  String _userId = '';
  String _role = '';
  String? _idSelect;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan_status_js/belum'));
      if (response.statusCode == 200) {
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

  Future _updateStatusPelanggan() async {
    final response = await http.put(
      Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan_status/$_idSelect'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "status": "selesai",
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
        appBar: AppBar(
          backgroundColor: Colors.brown,
          iconTheme: IconThemeData(color: Colors.amberAccent),
          title: const Text(
            'Data Pesanan | Jasa',
            style: TextStyle(color: Colors.amberAccent),
          ),
          actions: <Widget>[
            if (_role == 'casier')
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TabelDataJasa()));
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
                        trailing:
                            Text('${_listdata[index]['jumlah_unit']}/unit'),
                        tileColor: Colors.amberAccent,
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          'Yakin ingin mengkonfirmasi pesanan?!'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Batal',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blueAccent),
                                            onPressed: () {
                                              try {
                                                final idPegawai =
                                                    _listdata[index]
                                                        ['id_pelanggan'];
                                                setState(() {
                                                  _idSelect = idPegawai;
                                                });
                                                _updateStatusPelanggan();
                                                const snackBar = SnackBar(
                                                  content: Text(
                                                      'Yay! Pesanan selesai dikonfirmasi.'),
                                                );
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RiwayatPesananJasa()));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } catch (err) {
                                                print(err);
                                                const snackBar = SnackBar(
                                                  content: Text(
                                                      'Ups! Pesanan gagal dikonfirmasi.'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            },
                                            child: Text('Ya',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  );
                })));
  }
}
