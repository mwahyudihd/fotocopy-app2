import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/absensi/tabel_absen%20_all.dart';
import 'home_page.dart';
import 'package:fotocopy_app/pages/pegawai/pegawai_page.dart';
import 'package:fotocopy_app/pages/pelanggan/tabel_page.dart';
import 'package:fotocopy_app/pages/produk/tabel_page.dart';
import 'package:fotocopy_app/pages/stok/stok_page.dart';
import 'package:fotocopy_app/pages/jasa/tabel_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          centerTitle: true,
          title: Text('Master Data'),
          titleTextStyle: TextStyle(color: Colors.amberAccent),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TabelPage1()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/product.png'),
                        )),
                  ),
                ),
                SizedBox(
                  width: 25,
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TabelPage()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/services.png'),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 25,
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PegawaiPage()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/employee.png'),
                        )),
                  ),
                ),
                SizedBox(
                  width: 25,
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TabelPage2()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/clients.png'),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
              width: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => StokPage()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/inventory.png'),
                        )),
                  ),
                ),
                SizedBox(
                  width: 25.0,
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: ((context) => TabelAbsenAll())),
                        (route) => false);
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.brown,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('assets/absen.jpg'),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}