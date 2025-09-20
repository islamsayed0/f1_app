import '../Models/Articlesmodle.dart';
import '../Models/drivers_model.dart';
import '../const/String.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../Models/podium_models.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<List<Driver>> getDrivers() async {
    final response = await dio.get(Strings.api_f1_drivers);

    final data = response.data as List;

    final drivers = data.map((e) => Driver.fromJson(e)).toList();

    return drivers;
  }
  Future<List<Articlesmodle>> getF1news() async {
    try {
      final Response response = await dio.get(Strings.api_f1_news);

      final Map<String, dynamic> jsonData =
      response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : {};

      final List<dynamic> articles = (jsonData['articles'] as List<dynamic>?) ?? <dynamic>[];
      final List<Articlesmodle> articleList = <Articlesmodle>[];

      for (final dynamic article in articles) {
        if (article is Map<String, dynamic>) {
          final String imageUrl = (article['urlToImage'] as String?) ?? '';
          final String title = (article['title'] as String?) ?? '';
          final String description = (article['description'] as String?) ?? '';
          final String content = (article['content'] as String?) ?? '';
          final String author = (article['source'] is Map<String, dynamic>)
              ? ((article['source'] as Map<String, dynamic>)['name'] as String? ?? '')
              : '';
          final String publishedAt = (article['publishedAt'] as String?) ?? '';
          final String url = (article['url'] as String?) ?? '';

          final Articlesmodle articlesmodle = Articlesmodle(
            imags: imageUrl,
            title: title,
            Subtitle: description,
            auther: author,
            date: publishedAt,
            url: url,
            content: content,
          );
          articleList.add(articlesmodle);
        }
      }
      return articleList;
    } catch (_) {
      return <Articlesmodle>[];
    }
  }

  Future<String> fetchFullArticleContent(String url) async {
    if (url.isEmpty) return '';
    try {
      final Response<String> response = await dio.get<String>(url, options: Options(responseType: ResponseType.plain));
      final String html = response.data ?? '';
      if (html.isEmpty) return '';

      final dom.Document document = html_parser.parse(html);

      final dom.Element? articleTag = document.querySelector('article');
      final Iterable<dom.Element> paragraphs = (articleTag ?? document.body)?.querySelectorAll('p') ?? <dom.Element>[];

      final String text = paragraphs
          .map((p) => p.text.trim())
          .where((t) => t.isNotEmpty)
          .join('\n\n');

      return text;
    } catch (_) {
      return '';
    }
  }

  Future<PodiumData?> getPodium() async {
    try {
      final Response response = await dio.get(Strings.api_f1_podiom);
      final Map<String, dynamic> root = response.data as Map<String, dynamic>;
      final Map<String, dynamic>? sportsResults = root['sports_results'] as Map<String, dynamic>?;
      if (sportsResults == null) return null;
      final String seriesTitle = (sportsResults['title'] as String?) ?? '';
      final Map<String, dynamic>? tables = sportsResults['tables'] as Map<String, dynamic>?;
      if (tables == null) return null;
      final String raceTitle = (tables['title'] as String?) ?? '';
      final Map<String, dynamic>? results = tables['results'] as Map<String, dynamic>?;
      if (results == null) return null;
      final String dateText = (results['date'] as String?) ?? '';
      final Map<String, dynamic>? track = results['track'] as Map<String, dynamic>?;
      final String trackName = track != null ? (track['name'] as String? ?? '') : '';
      final List<dynamic> standingsRaw = (results['standings'] as List<dynamic>? ?? <dynamic>[]);

      final List<PodiumEntry> standings = <PodiumEntry>[];
      int position = 1;
      for (final dynamic row in standingsRaw) {
        if (row is Map<String, dynamic>) {
          final Map<String, dynamic>? driver = row['driver'] as Map<String, dynamic>?;
          final String driverName = driver != null ? (driver['name'] as String? ?? '') : '';
          final String teamName = driver != null ? (driver['team'] as String? ?? '') : '';
          final String vehicleNumber = driver != null ? (driver['vehicle_number'] as String? ?? '') : '';
          final String grid = (row['grid'] as String?) ?? '';
          final String qualTime = (row['qual_time'] as String?) ?? '';
          standings.add(PodiumEntry(
            position: position,
            driverName: driverName,
            teamName: teamName,
            vehicleNumber: vehicleNumber,
            grid: grid,
            qualTime: qualTime,
          ));
          position += 1;
        }
      }

      return PodiumData(
        seriesTitle: seriesTitle,
        raceTitle: raceTitle,
        dateText: dateText,
        trackName: trackName,
        standings: standings,
      );
    } catch (_) {
      return null;
    }
  }

}
