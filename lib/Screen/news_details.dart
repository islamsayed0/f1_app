import 'package:flutter/material.dart';

import '../Models/Articlesmodle.dart';
import '../Services/f1_api_cal.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key, required this.article, this.apiService});

  final Articlesmodle article;
  final ApiService? apiService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (article.imags.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.imags,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                article.title,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      article.auther,
                      style: const TextStyle(color: Colors.orangeAccent, fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Text(
                  article.date,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                article.Subtitle,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 10),
            if (article.content.isNotEmpty)
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  article.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.right,
                ),
              ),
            if (article.content.isEmpty && apiService != null && article.url.isNotEmpty)
              FutureBuilder<String>(
                future: apiService!.fetchFullArticleContent(article.url),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final String full = snap.data ?? '';
                  if (full.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      full,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}


