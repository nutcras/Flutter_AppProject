import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_project/model/TextModel.dart';
import 'package:flutter_application_project/views/Customerhome_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/config/config.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      backgroundColor: Color.fromARGB(255, 93, 234, 137),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              TextFormFieldModel(
                controller: fname,
                labelText: 'ชื่อ',
                hintText: 'ชื่อ',
                textError: 'กรุณากรอก',
                helperText: 'กรุณากรอกชื่อ',
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormFieldModel(
                controller: lname,
                labelText: 'นามสกุล',
                hintText: 'นามสกุล',
                textError: 'กรุณากรอก',
                helperText: 'กรุณากรอกนามสกุล',
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormFieldModel(
                controller: phone,
                labelText: 'เบอร์โทรศัพท์',
                hintText: 'เบอร์โทรศัพท์',
                textError: 'กรุณากรอก',
                helperText: 'กรุณากรอกเบอร์โทรศัพท์',
              ),
              const SizedBox(
                height: 15,
              ),
              // TextFormFieldModel(
              //   controller: role,
              //   labelText: 'ประเภทผู้ใช้งาน',
              //   hintText: 'ประเภทผู้ใช้งาน',
              //   textError: 'กรุณากรอก',
              //   helperText: 'กรอกประเภทผู้ใช้งาน ลูกค้า: C ,พนักงาน: S  ',
              // ),
              const SizedBox(
                height: 15,
              ),
              // TextFormFieldModel(
              //   controller: address,
              //   labelText: 'ที่อยู่',
              //   hintText: 'ที่อยู่',
              //   textError: 'กรุณากรอก',
              //   helperText: 'กรอกที่อยู่',
              // ),
              TextFormFieldModel(
                controller: username,
                labelText: 'ชื่อผู้ใช้',
                hintText: 'ชื่อผู้ใช้',
                textError: 'กรุณากรอก',
                helperText: 'กรอกชื่อผู้ใช้',
              ),
              TextFormFieldModel(
                controller: password,
                labelText: 'รหัสผ่าน',
                hintText: 'รหัสผ่าน',
                textError: 'กรุณากรอก',
                helperText: 'กรอกรหัสผ่านอย่างน้อย 6 ตัว',
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState?.save();
                  }
                  print('สมัครสมาชิก');

                  await checkRegister(
                      fname.text,
                      lname.text,
                      phone.text,
                      role.text,
                      address.text,
                      username.text,
                      password.text,
                      context);
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                      color: Color.fromARGB(255, 45, 134, 156),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

Future checkRegister(
    fname, lname, phone, role, address, username, password, context) async {
  EasyLoading.show(status: 'loading...');

  Uri url = Uri.parse('http://192.168.1.38:3200/api/users');
  http
      .post(
    url,
    headers: headers,
    body: jsonEncode({
      "fname": fname,
      "lname": lname,
      "number": phone,
      "role": "c",
      "address": "address",
      "username": username,
      "password": password,
    }),
  )
      .then((req) async {
    print(req.statusCode);
    if (req.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      var data = jsonDecode(req.body);
      prefs.setString('token', data['token']);
      headers?['Authorization'] = "bearer ${data['token']}";
      EasyLoading.showSuccess('Great Success!');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Customerhome(index: 0)),
          (Route<dynamic> route) => false);
    } else {
      print('error');
      EasyLoading.showError('Failed with Error');
    }
  });
}
