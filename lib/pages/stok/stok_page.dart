import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fotocopy_app/pages/stok/stok_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StokPage extends StatefulWidget {
  const StokPage({super.key});
  @override
  _StokPageState createState() => _StokPageState();
}

extension StringExtension on String {
  String limitize() {
    return this.length > 10 ? this.substring(0, 10) : this;
  }

  String subLimitize() {
    return this.length > 18 ? this.substring(0, 18) : this;
  }
}

class _StokPageState extends State<StokPage> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(
          'https://hafiz.barudakkoding.com/fotocopy-api/public/produk/'));
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
          'Data Produk beserta stok',
          style: TextStyle(color: Colors.amberAccent),
          textAlign: TextAlign.center,
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
                                      'assets/${int.parse(_listdata[index]["stok"]) > 0 ? "ready-stock.png" : "no_stock.png"}'),
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
                                      'KODE : ${_listdata[index]['kode'].toString().limitize()}', 
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('Stok : ${_listdata[index]["stok"].toString().subLimitize()}'),
                                    Text('Nama : ${_listdata[index]["nama"].toString().subLimitize()}')
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
                                        final idProduk = _listdata[index]
                                                ['id_produk']
                                            .toString();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProdukDetail(
                                                        isId: idProduk)));
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
