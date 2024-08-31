import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/produk/delete.dart';
import 'package:fotocopy_app/pages/produk/produk_edit.dart';
import 'package:fotocopy_app/pages/produk/produk_form.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class TabelPage1 extends StatefulWidget {
  const TabelPage1({super.key});
  @override
  _TabelPage1State createState() => _TabelPage1State();
}

class _TabelPage1State extends State<TabelPage1> {
  List _listdata = [];
  bool _loaddata = true;
  String? _selectedId;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/produk'));
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
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/produk/${_selectedId.toString()}'));
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
          'Data Produk',
          style: TextStyle(color: Colors.amberAccent),
        )),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProdukForm()));
            },
            icon: Icon(
              Icons.add_box,
              color: Colors.amberAccent,
            ),
          ),
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
          ),
        ],
      ),
      body: _loaddata
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                      label: Flexible(child: Text('Nama')),
                    ),
                    DataColumn(
                      label: Flexible(child: Text('Harga')),
                    ),
                    DataColumn(
                      label: Flexible(child: Text('Kode')),
                    ),
                    DataColumn(
                      label: Flexible(child: Text('Stok')),
                    ),
                    DataColumn(label: Flexible(child: Text('Del'))),
                    DataColumn(label: Flexible(child: Text('Edit'))),
                  ],
                  rows: _listdata.map<DataRow>((item) {
                    final cells = DataRow(
                      cells: <DataCell>[
                        DataCell(Text((no++).toString())),
                        DataCell(Text(item['nama'])),
                        DataCell(Text(NumberFormat.currency(
                                locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                            .format(int.parse(item['harga']))
                            .toString())),
                        DataCell(Text(item['kode_produk'])),
                        DataCell(Text(item['stok'])),
                        DataCell(
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
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
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.amberAccent),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Batal',
                                                style: TextStyle(
                                                    color: Colors.brown),
                                              )),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent),
                                              onPressed: () async {
                                                final namaProduk = item['nama'];
                                                setState(() {
                                                  _selectedId = 
                                                      item['kode_produk'];
                                                });
                                                _remove();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            DeleteData(
                                                              namaProduk:
                                                                  namaProduk,
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
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 0,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final idProduk = item['kode_produk'];
                                final String namaProduk = item['nama'];
                                final hargaProduk = item['harga'];
                                final stokData = item['stok'];
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProdukEdit(
                                          isId: idProduk,
                                          isName: namaProduk,
                                          isHarga: hargaProduk,
                                          isStok: stokData,
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
    );
  }
}
