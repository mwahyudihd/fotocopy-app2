import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/tambah_pesanan.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class TabelPageTrProduk extends StatefulWidget {
  const TabelPageTrProduk({super.key});
  @override
  _TabelPageTrProdukState createState() => _TabelPageTrProdukState();
}

class _TabelPageTrProdukState extends State<TabelPageTrProduk> {
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
          'Pilih Produk',
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
                    DataColumn(label: Flexible(child: Text('Pilih'))),
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
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 0,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.check_box_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final idProduk = item['kode_produk'];
                                final String namaProduk = item['nama'];
                                final hargaProduk = item['harga'];
                                final stokData = int.parse(item['stok']);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TambahPesanan(
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
