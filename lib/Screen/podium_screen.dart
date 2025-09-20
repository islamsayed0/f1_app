import 'package:flutter/material.dart';

import '../Models/podium_models.dart';
import '../Services/f1_api_cal.dart';

class PodiumScreen extends StatelessWidget {
  const PodiumScreen({super.key, required this.apiService});

  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PodiumData?>(
      future: apiService.getPodium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }
        final PodiumData? data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('لا توجد بيانات متاحة'));
        }
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  data.seriesTitle,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  data.raceTitle,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        data.trackName,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  Text(
                    data.dateText,
                    style: const TextStyle(color: Colors.black54),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: data.standings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final PodiumEntry e = data.standings[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: Text(e.position.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text('${e.driverName}  (${e.vehicleNumber})', textAlign: TextAlign.right),
                        ),
                        subtitle: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text('${e.teamName}  |  Grid: ${e.grid}  |  Time: ${e.qualTime}', textAlign: TextAlign.right),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


