import 'dart:convert';

import 'package:rubisch/data/models/article_model.dart';

ArticleResponse articleResponseFromJson(String str) =>
    ArticleResponse.fromJson(json.decode(str));

String articleResponseToJson(ArticleResponse data) =>
    json.encode(data.toJson());

class ArticleResponse {
  String status;
  int totalResults;
  List<ArticleModel> articles;

  ArticleResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      ArticleResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<ArticleModel>.from(
          (json["articles"] as List)
              .map((x) => ArticleModel.fromJson(x))
              .where(
                (article) =>
                    article.author != null ||
                    article.urlToImage != null ||
                    article.content != null ||
                    article.description != null ||
                    article.publishedAt != null ||
                    article.source != null ||
                    article.title != null ||
                    article.url != null,
              ),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}
