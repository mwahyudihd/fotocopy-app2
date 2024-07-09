import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fotocopy_app/pages/jasa/jasa_edit.dart';
import 'package:fotocopy_app/pages/jasa/delete.dart';
import 'package:fotocopy_app/pages/jasa/jasa_form.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class TabelPage extends StatefulWidget {
  const TabelPage({super.key});
  @override
  _TabelPageState createState() => _TabelPageState();
}

class _TabelPageState extends State<TabelPage> {
  bool _isVisible = true;
  List _listdata = [];
  bool _loaddata = true;
  String? _selectedId;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/jasa'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _loaddata = false;
          _listdata = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _remove() async {
    try {
      final response = await http.delete(Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/jasa/${_selectedId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _loaddata = false;
          _listdata = data;
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
    int no = 1;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: Center(
            child: Text(
          'Data Jasa',
          style: TextStyle(color: Colors.amberAccent),
        )),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _loaddata = true;
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
      body: _loaddata
          ? Center(
              child: CircularProgressIndicator(),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  if (scrollNotification.metrics.pixels >
                      scrollNotification.metrics.maxScrollExtent / 2.5) {
                    setState(() {
                      _isVisible = false;
                    });
                  } else {
                    setState(() {
                      _isVisible = true;
                    });
                  }
                }
                return true;
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 48,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('No'),
                          ),
                          DataColumn(label: Text('Kode')),
                          DataColumn(
                            label: Flexible(child: Text('Nama Jasa')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('Harga')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('Pegawai')),
                          ),
                          DataColumn(label: Flexible(child: Text('Del'))),
                          DataColumn(label: Flexible(child: Text('Edit'))),
                        ],
                        rows: _listdata.map<DataRow>((item) {
                          final cells = DataRow(
                            cells: <DataCell>[
                              DataCell(Text((no++).toString())),
                              DataCell(Text(item['kode_jasa'])),
                              DataCell(Text(item['nama_jasa'])),
                              DataCell(Text(NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0)
                                  .format(int.parse(item['harga']))
                                  .toString())),
                              DataCell(Text(item['nama_pegawai'])),
                              DataCell(
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      width: 0,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Yakin ingin menghapus data ini?!'),
                                              actions: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .amberAccent),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Batal',
                                                      style: TextStyle(
                                                          color: Colors.brown),
                                                    )),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent),
                                                    onPressed: () async {
                                                      final idJasa =
                                                          item['nama_jasa'];
                                                      setState(() {
                                                        _selectedId = 
                                                            item['kode_jasa'];
                                                      });
                                                      _remove();
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      ((context) =>
                                                                          DeleteData(
                                                                            namaJasa:
                                                                                idJasa,
                                                                          ))),
                                                              (route) => false);
                                                    },
                                                    child: Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ],
                                            );
                                          }));
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      width: 0,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      final idJasa = item['kode_jasa'];
                                      final String namaJasa = item['nama_jasa'];
                                      final hargaJasa = item['harga'];
                                      final pegawaiJasa = item['nama_pegawai'];
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => JasaEdit(
                                                  isId: idJasa,
                                                  isName: namaJasa,
                                                  isHarga: hargaJasa,
                                                  isPegawai: pegawaiJasa)));
                                    },
                                  ),
                                ),
                              )
                            ],
                          );
                          return cells;
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Visibility(
                        visible: _isVisible,
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.add,
                            color: Colors.brown,
                          ),
                          backgroundColor: Colors.amberAccent,
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const JasaForm()));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
