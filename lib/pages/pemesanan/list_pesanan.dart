import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/home_views/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class ListPesanan extends StatefulWidget {
  const ListPesanan({super.key});
  @override
  _ListPesananState createState() => _ListPesananState();
}

class _ListPesananState extends State<ListPesanan> {
  List _listdata = [];
  bool _isloading = true;
  String _userEmail = '';
  String _userId = '';
  String _role = '';

  Future _getdata() async {
    try {
      final response = await http
          .get(Uri.parse('https://hafiz.barudakkoding.com/fotocopy-api/public/pelanggan_status/belum'));
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
          'Data Pesanan',
          style: TextStyle(color: Colors.amberAccent),
        ),
        actions: <Widget>[
          if ( _role == 'casier' )
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
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${_listdata[index]['nama_pelanggan']} - ${_listdata[index]['jenis_pesanan']}', overflow: TextOverflow.ellipsis,),
                    subtitle: Text(_listdata[index]['kategori']),
                    leading: Icon(Icons.paste_rounded),
                    trailing: Text('${_listdata[index]['jumlah_unit']}/unit'),
                    tileColor: Colors.amberAccent,
                    onTap: () async {
                      final idPegawai = _listdata[index]['id_pelanggan'];
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage()));
                    },
                  ),
                );
              }),
            ),
    );
  }
}
