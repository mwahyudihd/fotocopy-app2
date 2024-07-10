import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/home_views/home_page.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/riwayat_pesanan.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/transaksi_produk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPesananSelect extends StatefulWidget {
  const ListPesananSelect({super.key});
  @override
  _ListPesananSelectState createState() => _ListPesananSelectState();
}

class _ListPesananSelectState extends State<ListPesananSelect> {
  String _userEmail = '';
  String _userId = '';
  String _role = '';

  @override
  void initState() {
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
            'Pesanan & Riwayat | Produk',
            style: TextStyle(color: Colors.amberAccent),
          ),
        ),
        body: Center(
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  tileColor: Colors.amberAccent,
                  textColor: Colors.brown,
                  leading: Icon(Icons.mail),
                  title: Text('Pesanan'),
                  subtitle: Text('Produk'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListPesananProduk()));
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                child: ListTile(
                  tileColor: Colors.amberAccent,
                  textColor: Colors.brown,
                  leading: Icon(Icons.history_outlined),
                  title: Text('Riwayat Pesanan'),
                  subtitle: Text('Produk'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListRiwayatPesananProduk()));
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
