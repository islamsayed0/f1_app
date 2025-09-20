import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import '../Models/drivers_model.dart';
import '../Services/f1_api_cal.dart';
import '../Widgets/Drivers_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'news_f1_.dart';
import 'podium_screen.dart';

class Home extends StatefulWidget {
  final ApiService apiService;
  Home({super.key, required this.apiService});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Random random = Random();
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Container(
          width: 100,
          height: 100,
            child: Image.asset('assets/imags/logo.png'))

        ),
      ),
      body:
      _selectIndex == 0 ?
      FutureBuilder<List<Driver>>(
        future: widget.apiService.getDrivers(),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final drivers = snapshot.data ?? [];
          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return DriversWidget(
                Driver_name: driver.driverName,
                Team_name: driver.teamName,
                country_code: driver.countryCode,
                Driver_image: driver.driverImage,
                color: driver.teamColor,
              );
            },
          );
        },
      )
      : _selectIndex == 1
          ? news_f1(apiService: widget.apiService)
          : PodiumScreen(apiService: widget.apiService),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectIndex,
        showElevation: true,
          items: [
            FlashyTabBarItem(
              icon: SvgPicture.asset(
                  'assets/imags/f1-helmet.svg',
                height: 24,
              ),
              title: Text('F1 Drivers'),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.newspaper),
              title: Text('F1 News'),
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              title: Text('Podium'),
            ),

          ],
        onItemSelected: (index) => setState(() {
          _selectIndex = index;
        }),
    ),
    );
  }
}
