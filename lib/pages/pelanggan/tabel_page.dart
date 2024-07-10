import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fotocopy_app/pages/pelanggan/delete.dart';
import 'package:fotocopy_app/pages/pelanggan/pelanggan_edit.dart';
import 'package:fotocopy_app/pages/pelanggan/pelanggan_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabelPage2 extends StatefulWidget {
  const TabelPage2({super.key});
  @override
  _TabelPage2State createState() => _TabelPage2State();
}

class _TabelPage2State extends State<TabelPage2> {
  bool _isVisible = true;
  List _listdata = [];
  bool _loaddata = true;
  int? _selectedId;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/pelanggan'));
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
          'https://hafiz.barudakkoding.com/fotocopy-api/public/pelanggan/${_selectedId}'));
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
          'Data Pelanggan',
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
                          DataColumn(
                            label: Flexible(child: Text('nama_pelanggan')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('jenis_pesanan')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('alamat')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('status')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('Jumlah unit')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('kode unit')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('kategori')),
                          ),
                          DataColumn(
                            label: Flexible(child: Text('create_on')),
                          ),
                          DataColumn(label: Flexible(child: Text('Del'))),
                          DataColumn(label: Flexible(child: Text('Edit'))),
                        ],
                        rows: _listdata.map<DataRow>((item) {
                          final cells = DataRow(
                            cells: <DataCell>[
                              DataCell(Text((no++).toString())),
                              DataCell(Text(item['nama_pelanggan'])),
                              DataCell(Text(item['jenis_pesanan'])),
                              DataCell(Text(item['alamat'])),
                              DataCell(Text(item['status'])),
                              DataCell(Text(item['jumlah_unit'])),
                              DataCell(Text(item['kode_unit'])),
                              DataCell(Text(item['kategori'])),
                              DataCell(Text(item['create_on'])),
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
                                                      final namaPelanggan =
                                                          item[
                                                              'nama_pelanggan'];
                                                      setState(() {
                                                        _selectedId = int.parse(
                                                            item[
                                                                'id_pelanggan']);
                                                      });
                                                      _remove();
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      ((context) =>
                                                                          DeleteData(
                                                                            namapelanggan:
                                                                                namaPelanggan,
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
                                      final idpelanggan = item['id_pelanggan'];
                                      final String namapelanggan =
                                          item['nama_pelanggan'];
                                      final jenispesanan =
                                          item['jenis_pesanan'];
                                      final alamat = item['alamat'];
                                      final status = item['status'];
                                      final jmlUnit = item['jumlah_unit'];
                                      final kdUnit = item['kode_unit'];
                                      final kategori = item['kategori'];
                                      final kodePesan = item['kode_pesanan'];
                                      final hargaUnit = item['harga_unit'];
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PelangganEdit(
                                                    isId: idpelanggan,
                                                    isNama: namapelanggan,
                                                    isJenis: jenispesanan,
                                                    isAlamat: alamat,
                                                    isJmlUnit: jmlUnit,
                                                    isKodePesanan: kodePesan,
                                                    isKodeUnit: kdUnit,
                                                    isStatus: status,
                                                    isKategori: kategori,
                                                    isHarga: hargaUnit,
                                                  )));
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
                                    builder: (context) =>
                                        const PelangganForm()));
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
