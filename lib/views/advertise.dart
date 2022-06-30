import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_project/views/Customerhome_page.dart';
import 'package:flutter_application_project/views/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';

class adertise extends StatefulWidget {
  const adertise({Key? key}) : super(key: key);

  @override
  State<adertise> createState() => AdertiseState();
}

class AdertiseState extends State<adertise> {
  TextEditingController type_message = TextEditingController();
  TextEditingController typ_date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 89, 160, 51),
          title: Text("ประชาสัมพันธ์    "),
        ),
        backgroundColor: Color.fromARGB(255, 225, 231, 234),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                const SizedBox(height: 100),
                const Text(
                  '  แก้ไขข้อมูลประชาสัมพันธ์  ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 54, 178, 240),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 55),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      child: Column(children: [
                        TextFormField(
                            controller: type_message,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'พิมพ์...',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 159, 158, 158)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 23, 158, 237),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 23, 158, 237),
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            )),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            checkPr(typ_date.text, type_message.text, context);
                          },
                          child: const Text(
                            'สำเร็จ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            primary: Color.fromARGB(255, 102, 195, 252),
                          ),
                        ),
                      ]),
                    )),
                ListTile(
                  // leading: Icon(FontAwesomeIcons.rightFromBracket),
                  title: Text(
                    'ออกจากระบบ',
                    style: TextStyle(color: Colors.red),
                  ), //แก้ตรงนี้--------------------------------------------------------------------------------------
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                          //แก้ตรงนี้--------------------------------------------------------------------------------------
                        ),
                        (route) => false);
                  },
                ),
              ]),
            ),
          ),
        ));
  }
}

Future checkPr(String prdate, String prdescription, context) async {
  EasyLoading.init();

  Uri url = Uri.parse('http://192.168.1.38:3200/api/public_relations');
  http
      .post(
    url,
    headers: headers,
    body: jsonEncode({"prdate": prdate, "prdescription": prdescription}),
  )
      .then((req) async {
    if (req.statusCode == 200) {
      EasyLoading.showSuccess('Great Success!');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Customerhome(index: 0)),
          (Route<dynamic> route) => false);
    } else {
      EasyLoading.showError('Failed with Error');
    }
  });
}
