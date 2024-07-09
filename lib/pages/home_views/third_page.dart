import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/absensi/location_tracking.dart';
import 'package:fotocopy_app/pages/absensi/tabel_absen.dart';
import 'package:fotocopy_app/pages/pemesanan/list_pesanan.dart';

class ThirdPage extends StatelessWidget {
  final String? getNama;
  const ThirdPage({super.key, this.getNama});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                tileColor: Colors.amberAccent,
                textColor: Colors.brown,
                leading: Icon(Icons.check_box),
                trailing: Text(':'),
                title: Text('Absensi'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationTracking(
                                setNama: getNama,
                              )));
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
                leading: Icon(Icons.calendar_today),
                title: Text('Riwayat Absensi'),
                trailing: Text(':'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TabelAbsen()));
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
                leading: Icon(Icons.credit_card),
                trailing: Text(':'),
                title: Text('Transaksi'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListPesanan()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
