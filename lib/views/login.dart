// ignore_for_file: implementation_imports

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_project/config/config.dart';
import 'package:flutter_application_project/views/Customerhome_page.dart';
import 'package:flutter_application_project/views/register.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/src/easy_loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool hidepassword = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void initState() {
    super.initState();
    checkToken1();
  }

  checkToken1() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      headers?['Authorization'] = "bearer ${prefs.getString('token')}";
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Customerhome(index: 0)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("เข้าสู่ระบบ"),
        ),
        backgroundColor: const Color.fromARGB(255, 225, 231, 234),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  const SizedBox(height: 100),
                  const Text(
                    'ลงทะเบียน',
                    style: TextStyle(
                        color: Color.fromARGB(255, 54, 178, 240),
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: username,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 17),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'ชื่อผู้ใช้',
                                hintText: 'ชื่อผู้ใช้',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 9, 9, 9)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 23, 158, 237),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 23, 158, 237),
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  size: 30,
                                  color: Color.fromARGB(255, 46, 152, 252),
                                )),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              controller: password,
                              obscureText: hidepassword,
                              decoration: InputDecoration(
                                  labelText: 'รหัสผ่าน',
                                  hintText: 'รหัสผ่าน',
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 23, 158, 237)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 23, 158, 237)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    size: 30,
                                    color: Color.fromARGB(255, 46, 152, 252),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: (() {
                                        setState(() {
                                          hidepassword = !hidepassword;
                                        });
                                      }),
                                      icon: Icon(
                                        hidepassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 30,
                                        color: const Color.fromARGB(
                                            255, 46, 152, 252),
                                      )))),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              await checkLogin(
                                  username.text, password.text, context);
                              // Navigator.pushNamedAndRemoveUntil(context,
                              //     "/Page1", (Route<dynamic> route) => false);
                            },
                            child: const Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 45, 134, 156),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              primary: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'หรือ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 16, 16, 16)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RegisterScreen();
                              }));
                            },
                            child: const Text('สร้างบัญชีผู้ใช้',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 45, 134, 156),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              primary: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ])),
          ),
        ));
  }
}

Future checkLogin(String username, String password, context) async {
  EasyLoading.init();

  Uri url = Uri.parse('http://192.168.1.38:3200/api/users/login');
  http
      .post(
    url,
    headers: headers,
    body: jsonEncode({"username": username, "password": password}),
  )
      .then((req) async {
    print(req.statusCode);
    if (req.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      var data = jsonDecode(req.body);
      prefs.setString('token', data['token']);
      prefs.setInt('idm', data['user_id']);
      headers?['Authorization'] = "bearer ${data['token']}";
      EasyLoading.showSuccess('Great Success!');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Customerhome(index: 0)),
          (Route<dynamic> route) => false);
    } else {
      EasyLoading.showError('Failed with Error');
    }
  });
}
