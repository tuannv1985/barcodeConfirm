import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scanbarcode/scanbarcode.dart';
import 'package:scanbarcode/service_api.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: ScanBarcode());
  }
}