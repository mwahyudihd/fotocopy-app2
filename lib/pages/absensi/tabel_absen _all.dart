import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class TabelAbsenAll extends StatefulWidget {
  const TabelAbsenAll({super.key});

  @override
  State<TabelAbsenAll> createState() => _TabelAbsenAllState();
}

class _TabelAbsenAllState extends State<TabelAbsenAll> {
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
          'https://hafiz.barudakkoding.com/fotocopy-api/public/absen/'));
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

  Future<void> _createPdf() async {
    final pdf = pw.Document();

    setState(() {
      _isDownload = true;
    });

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['No', 'UID', 'Nama', 'Lokasi', 'Tanggal'],
              ..._listdata.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return [
                  (index + 1).toString(),
                  item['uid'] ?? '',
                  item['nama'] ?? '',
                  item['lokasi'] ?? '',
                  item['tgl_submit'] ?? ''
                ];
              })
            ],
          );
        },
      ),
    );

    final downloadsDirectory = Directory('/storage/emulated/0/Download');
    final file = File("${downloadsDirectory.path}/data_absen_All.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to ${file.path}')),
    );

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
        title:
            Text('Data Absensi', style: TextStyle(color: Colors.amberAccent)),
        actions: [
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: Colors.amberAccent),
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 45,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('UID')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Lokasi')),
                          DataColumn(label: Text('Tanggal')),
                        ],
                        rows: _listdata.map<DataRow>((index) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text((no++).toString())),
                              DataCell(Text(index['uid'] ?? '')),
                              DataCell(Text(index['nama'] ?? '')),
                              DataCell(Text(index['lokasi'] ?? '')),
                              DataCell(Text(index['tgl_submit'] ?? '')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        child: Icon( _isDownload ?
          Icons.download_done_sharp : Icons.download_sharp,
          color: Colors.amberAccent,
        ),
        onPressed: _createPdf,
      ),
    );
  }
}
