import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanbarcode/model_listno.dart';
import 'package:intl/intl.dart';
import 'package:scanbarcode/custemElevatedButton.dart';
import 'package:scanbarcode/scanbarcode.dart';
class GetApiData extends StatefulWidget {
  final String barcode;
  const GetApiData({Key? key, required this.barcode}) : super(key: key);
  @override
  State<GetApiData> createState() => _GetApiDataState();
}
class _GetApiDataState extends State<GetApiData> {
  List<DataModel>  data = [];
  List<DataModel>  dataCheckbox = [];
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('MM/dd/yyyy HH:mm:ss');
  final DateFormat formatterImage = DateFormat('ddMMyyyy_HHmmss');
  File? image;
  var stt = 0;
  bool dataSuccess = true;
  bool imageSuccess = true;
  @override
  void initState() {
    _getData();
    super.initState();
  }
  _getData() async {
    try {
      var response = await Dio().get('http://113.161.6.185:82/api/PackageListSeverTest/Get?listOW=${widget.barcode}');
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận giao hàng"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            header(height, width),
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
  Widget header(double height, double width){
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1.5),
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
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Số List", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                  SizedBox(width: 5,),
                  Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: width * 1/4.4,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Text(data.isNotEmpty ? data.first.OWCheckListNo ?? "" : "", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                  )
                ]
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ngày xác nhận", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                    Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: width * 1/4.4,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text(formatter.format(now), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),textAlign: TextAlign.center,),
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
              height: 45,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tài xế", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                    SizedBox(width: 5,),
                    Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: width * 1/4.4,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text(data.isNotEmpty ? data.first.OWDeliveryEmployeeCode ?? "" : "", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                    )
                  ]
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Biển số xe", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                    Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: width * 1/4.4,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text(data.isNotEmpty ? data.first.OWTruckNo ?? "" : "", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),textAlign: TextAlign.center,),
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
              height: 45,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Kiện/Tổng", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                    const SizedBox(width: 5,),
                    Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: width * 1/6,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Text('${dataCheckbox.length}/${data.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),),
                    )
                  ]
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
                height: 45,
                margin: EdgeInsets.only(top: 5,left: width*1/10, right: width*1/8),
                child: image != null ? CustomElevatedButton(
                  onPressed: () => confirmBarcode(),
                  child: const Text('Lưu xác nhận',textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),)
                    :CustomElevatedButton(onPressed: () => pickImage(), child: const Text('Chụp phiếu',textAlign: TextAlign.center, style: TextStyle(fontSize: 13)))
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
        2: FlexColumnWidth(3),
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
                child: Text("Số Kiện", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              color: Colors.amber,
              height: 40,
              child: const Center(
                child: Text("Nhà máy", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 12),),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.bottom,
            child: Container(
              color: Colors.amber,
              height: 40,
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
          2: FlexColumnWidth(3),
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
                setState(() => data.checkbox = value);
              },
            ),
          ),
        ),
      ),
    ]);
  }
  confirmBarcode() async{
    try{
      dataSuccess = true;
      var temp = data.where((element) => element.checkbox == true).toList();
      for (var element in temp) {
        var date = element.FTFinishDate = formatter.format(now).toString();
        var rowID = element.RowID;
        await putData(rowID, date);
      }
      postImage();
      if(dataSuccess){
        print('Đã lưu xác nhận thành công');
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanBarcode()));
      } else {
        customDialog('Lưu xác nhận chưa thành công');
      }
      setState((){
        dataCheckbox.clear();
        dataCheckbox.addAll(temp);
      });
    }catch(e){
      print('Xác nhận Fail');
    }
  }
  Future putData(String? rowID, String? date) async {
    try {
      var response = await Dio().put('http://113.161.6.185:82/api/PackageListSeverTest/${rowID}',
          data: {'FTFinishDate': date});
          if (response.statusCode == 200) {
          return DataModel.fromJson(response.data);
          } else {
            dataSuccess = false;
            print('Xác nhận Fail');
          }
        } catch (e) {
      print('chua luu xac nhan');
    }
  }
  Future postImage() async{
    try {
      String fileName = image!.path.split('/').last;
      String ext = fileName.split(".").last;
      String name = 'image_${formatterImage.format(now)}.$ext';
      FormData data = FormData.fromMap({
        'FileContent': await MultipartFile.fromFile(
          image!.path, filename: name),
      });
      final responseImage = await Dio().post(
          'http://113.161.6.185:82/api/ImageAPI/UploadFiles?listOW=${widget.barcode}',
          data: data);
      if (responseImage.statusCode == 200) {
        // customDialog('Đã lưu ảnh phiếu thành công');
        print('Lưu ảnh chụp phiếu true');
        return responseImage.data;
      } else {
        // customDialog('Lưu ảnh phiếu chưa thành công');
        print('Lưu ảnh chụp phiếu fail');
      }
    }catch (e) {
      // customDialog('Lưu ảnh phiếu chưa thành công');
      print('chua luu anh');
    }
  }
  Future pickImage() async{
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera
      );
      if(photo == null) return;
      var size = File(photo.path).lengthSync();
      if(size > 500000) {
        var percent = ((500000/size)*100).ceil();
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
  Future customDialog(String title) async{
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(title),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quay lại'),
          )
        ],
      ),
    );
  }
}
