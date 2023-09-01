import 'package:news_app/models/general_news_model.dart';
import 'package:news_app/models/model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {

  final _repo = NewsRepository();

  Future<NewsHeadlinesModel> fetchNewsHeadlines() async{
    final response = await _repo.fetchNewsHeadlines();
    return response;
  }

  Future<NewsHeadlinesModel> fetchCountryNews(String channelName) async{
    final response = await _repo.fetchCountryData(channelName);
    return response ;
  }

Future<GeneralNewsModel> fetchGeneralNews(String query1) async{
    final response = await _repo.fetchGeneralNews(query1);
    return response ;
  }
  Future<GeneralNewsModel> fetchGeneralNews2(String query1) async{
    final response = await _repo.fetchGeneralNews2(query1);
    return response ;
  }
}