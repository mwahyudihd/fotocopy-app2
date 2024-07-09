import 'package:flutter/material.dart';
import 'package:fotocopy_app/pages/produk/tabel_page.dart';

class DeleteData extends StatefulWidget {
  final String? namaProduk;

  const DeleteData({Key? key, this.namaProduk}) : super(key: key);

  @override
  State<DeleteData> createState() => _DeleteDataState();
}

class _DeleteDataState extends State<DeleteData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 270,
              ),
              Image.asset('assets/remove.gif'),
              SizedBox(
                height: 70.5,
              ),
              Text(
                'Produk ${widget.namaProduk} telah dihapus!',
                style: TextStyle(
                    height: 1.5, fontSize: 24.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 65.5,
              ),
              Container(
                height: 60,
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TabelPage1())),
                          (route) => false);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: Text(
                      'SELESAI',
                      style: TextStyle(color: Colors.brown, fontSize: 24, fontWeight: FontWeight.w700),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}