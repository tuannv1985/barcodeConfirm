import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanbarcode/scanbarcode.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> with TickerProviderStateMixin{
  TextEditingController controllerNameLogIn = TextEditingController();
  TextEditingController controllerPassLogIn = TextEditingController();
  TextEditingController controllerNameRegister = TextEditingController();
  TextEditingController controllerPassRegister = TextEditingController();
  TextEditingController controllerFullNameRegister = TextEditingController();
  TextEditingController controllerPhoneRegister = TextEditingController();
  TextEditingController controllerCompanyRegister = TextEditingController();
  late TabController _tabController;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Đăng nhập và đăng ký', style: TextStyle(fontSize: 25),),
        // centerTitle: true,
          bottom: TabBar(
              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              padding: const EdgeInsets.only(bottom: 5),
              controller: _tabController,
              tabs: const [
                Tab(text: 'ĐĂNG NHẬP'),
                Tab(text: 'ĐĂNG KÝ')
              ]
          )
      ),
      body: TabBarView(
        controller: _tabController,
        children:  [
          logInContent(context, width),
          registerContent(context)
        ],
      ),
    );
  }
  Widget logInContent(context, double width){
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 2/3*width,
            width: width,
            child: Image.asset('assets/images/image.jpg'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: controllerNameLogIn,
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
                prefixIcon: const Icon(Icons.person, size: 30),
                label: const Text('Tên đăng nhập', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: controllerPassLogIn,
              obscureText: true,
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
                prefixIcon: const Icon(Icons.key, size: 30),
                label: const Text('Mật khẩu', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 60,
            width: 200,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: () => logIn(context),
                child: const Text('ĐĂNG NHẬP', style: TextStyle(fontSize: 20),)
            ),
          )
        ],
      ),
    );
  }
  Widget registerContent(context){
    return SingleChildScrollView(
      child: Column(
        children: [
          // SizedBox(
          //   height: 2/3*width,
          //   width: width,
          //   child: Image.asset('assets/images/image.jpg'),
          // ),
          // const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: TextFormField(
              controller: controllerNameRegister,
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
                prefixIcon: const Icon(Icons.person, size: 30),
                label: const Text('Tên đăng ký', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: controllerPassRegister,
              obscureText: true,
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
                prefixIcon: const Icon(Icons.key, size: 30),
                label: const Text('Mật khẩu', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: controllerFullNameRegister,
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
                prefixIcon: const Icon(Icons.people_alt, size: 30),
                label: const Text('Họ tên đầy đủ', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: controllerPhoneRegister,
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
                prefixIcon: const Icon(Icons.phone, size: 30),
                label: const Text('Số điện thoại', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              controller: controllerCompanyRegister,
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
                prefixIcon: const Icon(Icons.corporate_fare, size: 30),
                label: const Text('Nhà máy', style: TextStyle(fontSize: 20),),
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 60,
            width: 200,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: () {
                  if(controllerNameRegister.text == '' || controllerPassRegister.text == '' || controllerFullNameRegister.text == '' || controllerPhoneRegister.text == '' || controllerCompanyRegister.text == ''){
                    if(controllerNameRegister.text == ''){
                      customDialog('Tên đăng ký không được trống');
                    }
                    if(controllerPassRegister.text == ''){
                      customDialog('Mật khẩu không được trống');
                    }
                    if(controllerFullNameRegister.text == ''){
                      customDialog('Họ tên không được trống');
                    }
                    if(controllerPhoneRegister.text == ''){
                      customDialog('Số điện thoại không được trống');
                    }
                    if(controllerCompanyRegister.text == ''){
                      customDialog('Nhà máy không được trống');
                    }
                  } else {
                    register(context);
                  }
                },
                child: const Text('ĐĂNG KÝ', style: TextStyle(fontSize: 20),)
            ),
          )
        ],
      ),
    );
  }
  void logIn(BuildContext context) async{
    try{
      var user = controllerNameLogIn.text;
      var pass = controllerPassLogIn.text;
      var response = await Dio().get('http://113.161.6.185:82/api/User/Get?user=$user&password=$pass');
      if(response.statusCode == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanBarcode(user: user)));
      }
      else {
        print('Fetch fail');
      }
    }catch (e){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text("Tài khoản đăng nhập chưa đúng hoặc chưa có"),
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
  void register(BuildContext context) async{
    try{
      var user = controllerNameRegister.text;
      var pass = controllerPassRegister.text;
      var fullName = controllerFullNameRegister.text;
      var phone = controllerPhoneRegister.text;
      var company = controllerCompanyRegister.text;
        var response = await Dio().post('http://113.161.6.185:82/api/UserServerTest/CreateUser?user=$user&password=$pass&username=$fullName&phonenumber=$phone&enterprisecode=$company&postion=Tài xế');
        if(response.statusCode == 200){
          controllerNameRegister.text = "";
          controllerPassRegister.text = "";
          controllerFullNameRegister.text = "";
          controllerPhoneRegister.text = "";
          controllerCompanyRegister.text ="";
          _tabController.index = 0;
        }
        else {
          print('Fetch fail');
        }
      }
    catch (e){
      customDialog('Tài khoản đã tồn tại');
      print('Register fail');
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
