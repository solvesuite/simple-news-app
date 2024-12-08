
import 'package:news/model/modelAllNews.dart';
import 'package:news/model/modelBBcNews.dart';
import 'package:news/services/services.dart';

class NewsListViewModel {
  Future<ModelAllNews> fetchNews(String category) async {
    final myApiResult = await MyService().fetchAllNews(category);

    return myApiResult;
  }

  Future<ModelBbcNews> fetchBBcNews() async {
    final bbcApi = await MyService().fetchBBCNews();

    return bbcApi;
  }
}
