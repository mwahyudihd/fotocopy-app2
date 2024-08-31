import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pegawai/pegawai_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fotocopy_app/pages/pegawai/delete.dart';

class PegawaiDetail extends StatefulWidget {
  final String? isId;

  const PegawaiDetail({super.key, this.isId});

  @override
  _PegawaiDetailState createState() => _PegawaiDetailState();
}

class _PegawaiDetailState extends State<PegawaiDetail> {
  List _listdata = [];
  bool _isloading = true;
  late final String? _statGender;
  late final String? isNamaPegawai;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pegawai/${widget.isId.toString()}'));
      if (response.statusCode == 200) {
        // print(response.body);
        final data = jsonDecode(response.body);
        setState(() {
          _listdata.add(data);
          _isloading = false;
          isNamaPegawai = _listdata[0]['nama_pegawai'];
          var cekData = _listdata[0]['gender'];
          if (cekData == "Laki-laki") {
            _statGender = 'Laki-laki.png';
          } else {
            _statGender = 'Perempuan.png';
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _remove() async {
    try {
      final response = await http.delete(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pegawai/${_listdata[0]["id_pegawai"].toString()}'));
      if (response.statusCode == 200) {
        _isloading = true;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.amberAccent),
        title: const Center(
          child: Text(
            'Detail Pegawai',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.only(left: 15),
              padding: const EdgeInsets.all(9.0),
              child: Center(
                child: Column(
                  children: [
                    _uidData(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Image.asset('assets/${_statGender.toString()}'),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text('Nama : ${_listdata[0]["nama_pegawai"]}'),
                    Text('Jobdesk : ${_listdata[0]['jobdesk']}.'),
                    Text('Gender : ${_listdata[0]["gender"]}'),
                    Text(
                        'Jumlah Gaji : ${NumberFormat.currency(locale: "id_ID", symbol: "Rp.", decimalDigits: 0).format(int.parse(_listdata[0]['gaji'])).toString()}'),
                    Text('No Telpon : ${_listdata[0]["no_tlp"]}'),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Yakin Ingin menghapus data pegawai ini?!',
                                    ),
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
                                            style:
                                                TextStyle(color: Colors.brown),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {
                                            _remove();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        DeleteData(
                                                          namaPegawai:
                                                              isNamaPegawai,
                                                        ))),
                                                (route) => false);
                                          },
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(
                                                color: Colors.amberAccent),
                                          )),
                                    ],
                                  );
                                }));
                          },
                          label: Text(
                            'Hapus',
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.amberAccent,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown),
                          onPressed: () {
                            final String idSaver = _listdata[0]['id_pegawai'];
                            final String nameSaver = _listdata[0]['nama_pegawai'];
                            final String jobSaver = _listdata[0]['jobdesk'];
                            final String tlpSaver = _listdata[0]['no_tlp'];
                            final String gajiSaver = _listdata[0]['gaji'];
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PegawaiFormEdit(
                                      getId: idSaver,
                                      getNama: nameSaver,
                                      getJobdesk: jobSaver,
                                      getTelp: tlpSaver,
                                      getGaji: gajiSaver,
                                    )));
                          },
                          label: Text(
                            'Edit',
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _uidData() {
    return Container(
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
      ),
      child: Text(
        'UID: ${widget.isId}',
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }
}
