import 'package:flutter/material.dart';

class Driver {
  Driver({
    required this.driverName,
    required this.teamName,
    required this.countryCode,
    required this.driverImage,
    required this.teamColor,
  });

  final String driverName;
  final String teamName;
  final String countryCode;
  final String driverImage;
  final Color teamColor;

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverName: json['full_name'] ?? '',
      teamName: json['team_name'] ?? '',
      countryCode: json['country_code'] ?? '',
      driverImage: json['headshot_url'] ?? '',
      teamColor: _parseColor(json['team_colour']), // يحول HEX إلى Color
    );
  }

  static Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Colors.grey; // لون افتراضي
    }
    
    // إزالة # إذا كانت موجودة
    String cleanColor = colorString.replaceAll('#', '');
    
    // التأكد من أن اللون يحتوي على 6 أحرف
    if (cleanColor.length == 6) {
      return Color(int.parse('0xFF$cleanColor'));
    }
    
    return Colors.grey; // لون افتراضي في حالة الخطأ
  }
}
