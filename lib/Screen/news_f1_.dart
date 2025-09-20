import 'package:f1/Widgets/News_F1.dart';
import 'package:flutter/material.dart';

import '../Models/Articlesmodle.dart';
import '../Services/f1_api_cal.dart';

class news_f1 extends StatelessWidget {
  const news_f1({super.key, required this.apiService});

  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Articlesmodle>>(
      future: apiService.getF1news(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }

        final articles = snapshot.data ?? <Articlesmodle>[];
        if (articles.isEmpty) {
          return const Center(child: Text('لا توجد أخبار متاحة الآن'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: articles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return NewsF1_wedgit(articlesmodle: articles[index], apiService: apiService);
          },
        );
      },
    ));
  }
}
