import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/cetak_laporan_transaksi.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/jasa_select.dart';
import 'package:fotocopy_app/pages/pemesanan/produk/list_pesanan_select.dart';


class ListPesanan extends StatefulWidget {
  const ListPesanan({super.key});
  @override
  _ListPesananState createState() => _ListPesananState();
}

class _ListPesananState extends State<ListPesanan> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          iconTheme: IconThemeData(color: Colors.amberAccent),
          title: const Text(
            'Pesanan | Produk & Jasa',
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
                  leading: Icon(Icons.production_quantity_limits),
                  subtitle: Text('Pesanan'),
                  title: Text('Produk'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListPesananSelect()));
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
                  leading: Icon(Icons.work),
                  title: Text('Jasa'),
                  subtitle: Text('pesanan'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JasaSelect()));
                },
              ),
            ),
            Card(
                child: ListTile(
                  tileColor: Colors.amberAccent,
                  textColor: Colors.brown,
                  leading: Icon(Icons.report),
                  title: Text('Laporan'),
                  subtitle: Text('Transaksi'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CetakLaporanTransaksi()));
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
