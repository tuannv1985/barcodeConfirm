import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanbarcode/service_api.dart';

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({Key? key}) : super(key: key);

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  String _scanBarcode = 'Nhấn vào: Quét Barcode';
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
            children: <Widget>[
              // ElevatedButton(
              //     onPressed: () => scanBarcodeNormal(),
              //     child: Text('Start barcode scan')),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await scanQR();
                          Navigator.push(context, MaterialPageRoute(builder: (_) => GetApiData(barcode: _scanBarcode,)));
                          },
                        child: const Text('Quét Barcode')),
                    const SizedBox(height: 50,),
                    Text('$_scanBarcode\n',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ]
        )
    );
  }
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Không tìm thấy Barcode';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}