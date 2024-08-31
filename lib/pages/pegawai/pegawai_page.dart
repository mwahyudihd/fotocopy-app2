import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fotocopy_app/pages/pegawai/pegawai_form.dart';
import 'package:fotocopy_app/pages/pegawai/pegawai_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});
  @override
  _PegawaiPageState createState() => _PegawaiPageState();
}

extension StringExtension on String {
  String limitize() {
    return this.length > 10 ? this.substring(0, 10) : this;
  }

  String subLimitize() {
    return this.length > 18 ? this.substring(0, 18) : this;
  }
}

class _PegawaiPageState extends State<PegawaiPage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://wahyudi.barudakkoding.com/fotocopy-api/public/pegawai/'));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Data Pegawai',
          style: TextStyle(color: Colors.amberAccent),
        ),
        actions: [
          IconButton.filled(
              onPressed: () {
                setState(() {
                  _isloading = true;
                });
                _getdata();
              },
              style: IconButton.styleFrom(backgroundColor: Colors.amberAccent),
              icon: Icon(
                Icons.refresh,
                color: Colors.brown,
              )),
          IconButton.filled(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PegawaiForm()));
              },
              style: IconButton.styleFrom(backgroundColor: Colors.amberAccent),
              icon: Icon(
                Icons.person_add,
                color: Colors.brown,
              )),
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
                    color: Colors.amberAccent,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.brown,
                                  width: 3,
                                ),
                                color: Colors.brown,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/${_listdata[index]["gender"] == "Laki-laki" ? "Laki-laki.png" : "Perempuan.png"}'),
                                )),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _listdata[index]['nama_pegawai']
                                          .toString()
                                          .limitize(), //diambil sampe 20 karakter saja,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(_listdata[index]["jobdesk"]
                                        .toString()
                                        .subLimitize()),
                                    Text(_listdata[index]["no_tlp"]
                                        .toString()
                                        .subLimitize())
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: IconButton.filled(
                                      style: IconButton.styleFrom(
                                          backgroundColor: Colors.brown),
                                      onPressed: () async {
                                        final idPegawai =
                                            _listdata[index]['id_pegawai'];
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PegawaiDetail(
                                                        isId: idPegawai)));
                                      },
                                      icon: Icon(Icons.arrow_right_outlined)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
              }),
            ),
    );
  }
}
