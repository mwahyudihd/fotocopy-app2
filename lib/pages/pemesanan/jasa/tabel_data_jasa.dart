import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/jasa_psn_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TabelDataJasa extends StatefulWidget {
  const TabelDataJasa({super.key});

  @override
  State<TabelDataJasa> createState() => _TabelDataJasaState();
}

class _TabelDataJasaState extends State<TabelDataJasa> {
  List _listdata = [];
  bool _loaddata = true;
  String? _selectedId;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/jasa'));
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
          'Pilih Jasa',
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
                      label: Flexible(child: Text('Yang melayani')),
                    ),
                    DataColumn(label: Flexible(child: Text('Pilih'))),
                  ],
                  rows: _listdata.map<DataRow>((item) {
                    final cells = DataRow(
                      cells: <DataCell>[
                        DataCell(Text((no++).toString())),
                        DataCell(Text(item['nama_jasa'])),
                        DataCell(Text(NumberFormat.currency(
                                locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                            .format(int.parse(item['harga']))
                            .toString())),
                        DataCell(Text(item['kode_jasa'])),
                        DataCell(Text(item['nama_pegawai'])),
                        
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
                                final idJasa = item['kode_jasa'];
                                final String namaJasa = item['nama_jasa'];
                                final hargaJasa = item['harga'];
                                final namaPelayan = item['nama_pegawai'];
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => JasaPsnForm(
                                      isId: idJasa, isHarga: hargaJasa, isName: namaJasa, namaPelayan: namaPelayan,
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