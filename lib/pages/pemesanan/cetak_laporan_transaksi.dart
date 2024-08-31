import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class CetakLaporanTransaksi extends StatefulWidget {
  const CetakLaporanTransaksi({super.key});

  @override
  State<CetakLaporanTransaksi> createState() => _CetakLaporanTransaksiState();
}

class _CetakLaporanTransaksiState extends State<CetakLaporanTransaksi> {
  List _listdata = [];
  bool _isDownload = false;
  bool _loaddata = true;
  String _userId = '';

  Future<void> _loadUserSesi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });

    await _getdata();
  }

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pelanggan/'));
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

  int _calculateTotalAmount() {
    int total = 0;
    for (var item in _listdata) {
      int jumlahUnit = int.parse(item['jumlah_unit'] ?? '0');
      int hargaUnit = int.parse(item['harga_unit'] ?? '0');
      total += jumlahUnit * hargaUnit;
    }
    return total;
  }

  Future<void> _createPdf() async {
    final pdf = pw.Document();

    setState(() {
      _isDownload = true;
    });

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>[
                    'No',
                    'Kode',
                    'Nama',
                    'Pesanan',
                    'Kategori',
                    'Tanggal',
                    'Jumlah unit',
                    'Harga',
                    'Total'
                  ],
                  ..._listdata.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    int jumlahUnit = int.parse(item['jumlah_unit'] ?? '0');
                    int hargaUnit = int.parse(item['harga_unit'] ?? '0');
                    int totalAmount = jumlahUnit * hargaUnit;
                    return [
                      (index + 1).toString(),
                      item['kode_unit'] ?? '',
                      item['nama_pelanggan'] ?? '',
                      item['jenis_pesanan'] ?? '',
                      item['kategori'] ?? '',
                      item['create_on'] ?? '',
                      item['jumlah_unit'] ?? '',
                      item['harga_unit'] ?? '',
                      totalAmount.toString()
                    ];
                  })
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Keseluruhan: ${_calculateTotalAmount()}',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    final downloadsDirectory = Directory('/storage/emulated/0/Download');
    final file = File("${downloadsDirectory.path}/laporan_transaksi.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to ${file.path}')),
    );

    setState(() {
      _isDownload = false;
    });

    print('PDF saved to ${file.path}');
  }

  @override
  void initState() {
    super.initState();
    _loadUserSesi();
  }

  @override
  Widget build(BuildContext context) {
    int no = 1;
    int totalAmount = _calculateTotalAmount();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: Text('Laporan Transaksi',
            style: TextStyle(color: Colors.amberAccent)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _loaddata = true;
              });
              _getdata();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.brown,
            ),
          ),
        ],
      ),
      body: _loaddata
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 45,
                          columns: const <DataColumn>[
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Kode')),
                            DataColumn(label: Text('Nama')),
                            DataColumn(label: Text('Pesanan')),
                            DataColumn(label: Text('Kategori')),
                            DataColumn(label: Text('Tanggal')),
                            DataColumn(label: Text('Jumlah Unit')),
                            DataColumn(label: Text('Harga')),
                            DataColumn(label: Text('Total')),
                          ],
                          rows: _listdata.map<DataRow>((index) {
                            int jumlahUnit = int.parse(index['jumlah_unit'] ?? '0');
                            int hargaUnit = int.parse(index['harga_unit'] ?? '0');
                            int totalAmount = jumlahUnit * hargaUnit;
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text((no++).toString())),
                                DataCell(Text(index['kode_unit'] ?? '')),
                                DataCell(Text(index['nama_pelanggan'] ?? '')),
                                DataCell(Text(index['jenis_pesanan'] ?? '')),
                                DataCell(Text(index['kategori'] ?? '')),
                                DataCell(Text(index['create_on'] ?? '')),
                                DataCell(Text(index['jumlah_unit'] ?? '')),
                                DataCell(Text(index['harga_unit'] ?? '')),
                                DataCell(Text(totalAmount.toString())),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Keseluruhan: $totalAmount',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        child: Icon(
          _isDownload ? Icons.download_done_sharp : Icons.download_sharp,
          color: Colors.amberAccent,
        ),
        onPressed: _createPdf,
      ),
    );
  }
}
