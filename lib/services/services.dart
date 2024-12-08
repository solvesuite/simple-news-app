import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/modelAllNews.dart';
import 'package:news/model/modelBBcNews.dart';

class MyService {
  Future<ModelAllNews> fetchAllNews(String category) async {
    String newsUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=dbf5772eeacb447f8e1cb2adfb6684bc';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return ModelAllNews.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }

  Future<ModelBbcNews> fetchBBCNews() async {
    String newsUrl =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=dbf5772eeacb447f8e1cb2adfb6684bc';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return ModelBbcNews.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }
}
