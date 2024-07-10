import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class InvoicePreviewJasa extends StatefulWidget {
  final String? kodePesanan;
  final String? tglPesan;
  final String? namaPemesan;
  final String? dilayaniOleh;
  final String? jmlUnit;
  final String? kodeUnit;
  final String? getHargaUnit;
  final String? totalAmount;
  final String? namaJenis;

  InvoicePreviewJasa({
    Key? key,
    this.kodePesanan,
    this.tglPesan,
    this.namaPemesan,
    this.jmlUnit,
    this.kodeUnit,
    this.getHargaUnit,
    this.totalAmount,
    this.namaJenis,
    this.dilayaniOleh
  }) : super(key: key);

  @override
  _InvoicePreviewJasaState createState() => _InvoicePreviewJasaState();
}

class _InvoicePreviewJasaState extends State<InvoicePreviewJasa> {
  bool _isDownload = true;

  Future<void> _generateInvoicePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Invoice Details',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              _invoiceDetailsTablePdf(),
            ],
          ),
        );
      },
    ));

    final output = await Directory('/storage/emulated/0/Download');
    final file = File("${output.path}/invoice_jasa.pdf");
    await file.writeAsBytes(await pdf.save());

    // Setelah selesai menyimpan PDF, tampilkan snackbar dan ubah state _isDownload.
    const snackBar = SnackBar(
      content: Text('File berhasil didownload di folder download!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _isDownload = false;
    });
  }

  pw.Widget _invoiceDetailsTablePdf() {
    return pw.Table.fromTextArray(
      data: [
        ['Nomor Invoice',':', '${widget.kodePesanan ?? ''}'],
        ['Tanggal',':', '${widget.tglPesan ?? ''}'],
        ['Nama Pelanggan',':', '${widget.namaPemesan ?? ''}'],
        ['Yang Melayani',':', '${widget.dilayaniOleh.toString()}'],
        ['Nama pesanan', ':', widget.namaJenis.toString()],
        ['Jumlah Unit', ':', '${widget.jmlUnit.toString()}/unit'],
        ['Harga', ':','Rp.${widget.getHargaUnit.toString()}'],
        ['Total Amount',':', 'Rp.${widget.totalAmount.toString()}'],
      ],
      border: pw.TableBorder.all(),
      cellStyle: const pw.TextStyle(),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      body: Center(
        child: ClipPath(
          clipper: ZigZagClipper(),
          child: Container(
            width: 500,
            color: Colors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'Invoice Jasa',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              _invoiceDetailsTable(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _generateInvoicePdf();
        },
        backgroundColor: Colors.brown,
        child: Icon(
          _isDownload ? Icons.download_outlined : Icons.download_done_outlined,
          color: Colors.amberAccent,
        ),
      ),
    );
  }

  Widget _invoiceDetailsTable() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(7),
          },
          children: [
            _tableRow('Nomor Invoice:', '${widget.kodePesanan ?? ''}'),
            _tableRow('Tanggal:', '${widget.tglPesan ?? ''}'),
            _tableRow('Nama Pelanggan:', '${widget.namaPemesan ?? ''}'),
            _tableRow('Nama pesanan', widget.namaJenis.toString()),
            _tableRow('Jumlah Unit', widget.jmlUnit.toString()),
            _tableRow('Harga', widget.getHargaUnit.toString()),
            _tableRow('Total Amount:', widget.totalAmount.toString()),
          ],
          border: TableBorder.all(color: Colors.black),
        ),
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(value),
        ),
      ],
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double factor = 8.0;
    Path path = Path();
    path.moveTo(factor, 0);
    path.arcToPoint(Offset(0, factor),
        radius: Radius.circular(factor), clockwise: false);

    path.lineTo(0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 20;

    while (x < size.width) {
      if (x + increment > size.width) {
        x += size.width - x;
      } else {
        x += increment;
      }

      y = (y == size.height) ? size.height - increment : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, factor);
    path.arcToPoint(Offset(size.width - factor, 0),
        radius: Radius.circular(factor), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
