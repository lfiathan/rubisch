import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rubisch/data/models/article_response.dart';

class ArticleApi {
  static final String _baseUrl = "https://newsapi.org/v2/";

  Future<ArticleResponse> topHeadlines() async {
    final String apiKey = dotenv.env['NEWS_API_KEY'] ?? 'DEFAULT_KEY';
    final String category = dotenv.env['CATEGORY'] ?? 'rubbish';
    // final String fromDate = dotenv.env['FROM_DATE'] ?? '2025-05-01';
    final String sortBy = dotenv.env['SORT_BY'] ?? 'publishedAt';

    final response = await http.get(
      Uri.parse(
        "${_baseUrl}everything?q=$category&sortBy=$sortBy&apiKey=$apiKey",
      ),
    );

    if (response.statusCode == 200) {
      return ArticleResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load top headlines");
    }
  }
}
