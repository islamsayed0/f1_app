import 'package:f1/Screen/home.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'Services/f1_api_cal.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final apiService = ApiService(dio);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: Home(apiService: apiService),
    );
  }
}
