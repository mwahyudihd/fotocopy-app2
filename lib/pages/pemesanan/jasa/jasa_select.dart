import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/jasa_transaksi.dart';
import 'package:fotocopy_app/pages/pemesanan/jasa/riwayat_pesanan_jasa.dart';

class JasaSelect extends StatefulWidget {
  const JasaSelect({super.key});

  @override
  State<JasaSelect> createState() => _JasaSelectState();
}

class _JasaSelectState extends State<JasaSelect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          iconTheme: IconThemeData(color: Colors.amberAccent),
          title: const Text(
            'Pesanan & Riwayat | JASA',
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
                  leading: Icon(Icons.work),
                  subtitle: Text('Pesanan'),
                  title: Text('Jasa'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JasaTransaksi()));
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
                  leading: Icon(Icons.work_history),
                  title: Text('Riwayat Pesanan'),
                  subtitle: Text('Jasa'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RiwayatPesananJasa()));
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}