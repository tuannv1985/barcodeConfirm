import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scanbarcode/model_listno.dart';
import 'package:intl/intl.dart';
import 'package:scanbarcode/custemElevatedButton.dart';
class GetApiData extends StatefulWidget {
  final String barcode;
  const GetApiData({Key? key, required this.barcode}) : super(key: key);

  @override
  State<GetApiData> createState() => _GetApiDataState(barcode);
}

class _GetApiDataState extends State<GetApiData> {
  final String scanBarcode;
  TextEditingController textController = TextEditingController();
  List<DataModel>  data = [];
  List<DataModel>  dataCheckbox = [];
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('MM/dd/yyyy HH:mm:ss');
  File? image;
  var stt = 0;
  _GetApiDataState(this.scanBarcode);
  @override
  void initState() {
    _getData();
    super.initState();
  }
  _getData() async {
    try {
      var response = await Dio().get('http://113.161.6.185:82/api/PackageListSeverTest/Get?listOW=$scanBarcode');
      final decodedResponse = response.data;
      print(decodedResponse);
      List<DataModel>  temp = [];
      decodedResponse.forEach((element) {
        var model = DataModel.fromJson(element);
        temp.add(model);
      });
      setState(() {
        dataCheckbox.clear();
        data.clear();
        data.addAll(temp);
        dataCheckbox.addAll(temp);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Get Data Failure"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận giao hàng"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            header(),
            SizedBox(height: 20,),
            bodyHeader(),
            Expanded(
              child: Container(
                child: data.isNotEmpty? bodyContent() : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget header(){
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1.55),
        1: FlexColumnWidth(2),

      },
      border: const TableBorder(
        top: BorderSide.none,
        bottom: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
        horizontalInside: BorderSide.none,
        verticalInside: BorderSide.none,
      ),
      children: <TableRow>[
        TableRow(children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(" Số List", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),),
                  SizedBox(width: 10,),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Text('${dataCheckbox[0].OWCheckListNo}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),),
                  )
                ]
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Ngày XN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),),
                    SizedBox(width: 10,),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text(formatter.format(now), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),),
                    )
                  ]
              ),
            ),
          ),
        ]),
        TableRow(children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Kiện/Tổng", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),),
                    const SizedBox(width: 10,),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text('${dataCheckbox.length}/${data.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),),
                    )
                  ]
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 50),
              child: image != null ?
                CustomElevatedButton(onPressed: () => confirmBarcode(), child: const Text('Lưu xác nhận', style: TextStyle(color: Colors.blue),),)
                :CustomElevatedButton(onPressed: () => pickImage(), child: const Text('Chụp phiếu', style: TextStyle(color: Colors.blue)),)
            ),
          ),
        ]),
      ],
    );
  }
  Widget bodyHeader() {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),

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
              height: 50,
              child: Center(
                child: Text("STT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 50,
              child: const Center(
                child: Text("Số Kiện", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 50,
              child: const Center(
                child: Text("Nhà máy", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              color: Colors.amber,
              height: 50,
              child: const Center(
                child: Text("Kiểm tra kiện", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
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
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),

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

  TableRow childTableRow(DataModel data) {
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
            child: Text(data.FTPlaceCode ?? "", style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Container(
          height: 30,
          child: Center(
            child: Checkbox(
              value: data.checkbox,
              onChanged: (bool? value) {
                stt = 0;
                setState(() => data.checkbox = value);
              },
            ),
          ),
        ),
      ),
    ]);
  }
  confirmBarcode(){
    var temp = data.sublist(0,5).where((element) => element.checkbox == true).toList();
    for (var element in temp) {
      var date = element.FTFinishDate = formatter.format(now).toString();
      var rowID = element.RowID;
      putData(rowID, date);
    }
    setState((){
      dataCheckbox.clear();
      dataCheckbox.addAll(temp);
    });
  }
  Future putData(String? rowID, String? date) async {
    try {
      var response = await Dio().put('http://113.161.6.185:82/api/PackageListSeverTest/${rowID}',
          data: {'FTFinishDate': date});
          print('$rowID: $date');
          if (response.statusCode == 200) {
          // then parse the JSON.
          return DataModel.fromJson(response.data);
          } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          throw Exception('Failed to create album.');
          }
          } catch (e) {
        print(e);
      }
    }
  Future pickImage() async{
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera
      );
      if(photo == null) return;
      var size = File(photo.path).lengthSync();
      if(size > 512) {
        var percent = ((512/size)*100).ceil();
        File compressedFile = await FlutterNativeImage.compressImage(photo.path,
            quality: percent, percentage: 100);
        final imageTemp = File(compressedFile.path);
        setState(() => image = imageTemp);
      } else {
        final imageTemp = File(photo.path);
        setState(() => image = imageTemp);
      }

    } on PlatformException catch(e){
      print('Take picture fail: $e');
    }
  }
}
