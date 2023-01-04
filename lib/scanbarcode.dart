import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanbarcode/model_driver.dart';
import 'package:scanbarcode/service_api.dart';

class ScanBarcode extends StatefulWidget {
  final String? user;
  const ScanBarcode({Key? key, this.user}) : super(key: key);

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  var stt =0;
  List<DriverModel> data = [];
  List<DriverModel> dataFilter = [];
  String _scanBarcode = '';
  TextEditingController controller = TextEditingController();
  _getDataDriver() async{
    try {
      var response = await Dio().get('http://113.161.6.185:82/api/PackageListSeverTest/Check?user=${widget.user}&listOW=all');
      final decodeRes = response.data;
      List<DriverModel> temp = [];
      decodeRes.forEach((element) {
        var model = DriverModel.fromJson(element);
        temp.add(model);
      });
      setState((){
        data.addAll(temp);
        dataFilter.addAll(temp);
      });
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Get Data Failure"),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét Barcode và tìm kiếm'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: width * 1/2.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              )
                          ),
                          onPressed: () async {
                            await scanQR();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => GetApiData(barcode: _scanBarcode,)));
                            },
                          child: const Text('Quét Barcode',style: TextStyle(fontSize: 17),)
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: width * 1/2.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              )
                          ),
                        onPressed: (){
                            _getDataDriver();
                        },
                        child: Text("Lấy dữ liệu",style: TextStyle(fontSize: 17),)
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: Row(
                  children: [
                    const Text('Tìm kiếm',style: TextStyle(fontSize: 18),),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                  width: 1
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 1.5
                              )
                          ),
                          prefixIcon: const Icon(Icons.search_outlined, size: 30),
                          label: const Text('Thông tin chuyến', style: TextStyle(fontSize: 15),),
                        ),
                        style: const TextStyle(fontSize: 15),
                        onChanged: (text){
                          setState((){
                            var temp = dataFilter.where((element) => element.OWCheckListNo!.contains(controller.text,0));
                            data.clear();
                            data.addAll(temp);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              bodyHeader(),
              Expanded(
                child: Container(
                  child: data.isNotEmpty ? bodyContent() : Container(),
                )
              )
            ]
        ),
      ),
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
  Widget bodyHeader() {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(3)
      },
      border: const TableBorder(
        top: BorderSide(width: 1),
        bottom: BorderSide.none,
        left: BorderSide(width: 1),
        right: BorderSide(width: 1),
        horizontalInside: BorderSide(width: 1),
        verticalInside: BorderSide(width: 1),
      ),
      children: <TableRow>[
        TableRow(children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 40,
              child: Center(
                child: Text("STT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 40,
              child: const Center(
                child: Text("Số chuyến", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 40,
              child: const Center(
                child: Text("Số kiện", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 40,
              child: const Center(
                child: Text("Biển số xe", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              color: Colors.amber,
              height: 40,
              child: const Center(
                child: Text("Ngày xác nhận", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
        ]),
      ],
    );
  }
  Widget bodyContent() {
    stt =0;
    return SingleChildScrollView(
      child:  Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(3),
          3: FlexColumnWidth(3),
          4: FlexColumnWidth(3)
        },
        border: const TableBorder(
          top: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
          left: BorderSide(width: 1),
          right: BorderSide(width: 1),
          horizontalInside: BorderSide(width: 1),
          verticalInside: BorderSide(width: 1),
        ),
        children: data.map((e) {
          stt++;
          return childTableRow(e);
        }).toList(),
      ),
    );
  }

  TableRow childTableRow(DriverModel data) {
    // if(data.cargoName.contains(other)
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
          height: 30,
          child: Center(
            child: Text('$stt', style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
          height: 30,
          child: Center(
            child: Text(data.OWCheckListNo ?? "", style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
          height: 30,
          child: Center(
            child: Text(data.CaseNo ?? "", style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
          height: 30,
          child: Center(
            child: Text(data.OWTruckNo ?? "", style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Container(
          height: 30,
          child: Center(
            child: Text(data.FTFinishDate ?? "", style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),),
          ),
        ),
      ),
    ]);
  }
}