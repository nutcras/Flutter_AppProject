import 'package:flutter/material.dart';
import 'package:flutter_application_project/views/Customerhome_page.dart';
import 'package:flutter_application_project/views/ProflieUpdate.dart';
import 'package:flutter_application_project/views/register.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/PageOne': (context) => RegisterScreen(),
  '/PageFour': (context) => const ProfileUpdate(),
  '/Page1': (context) => Customerhome(index: 0),
  '/OderUser': (context) => Customerhome(index: 1),
};
