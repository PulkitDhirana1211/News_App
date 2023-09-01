import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/general_news_model.dart';
import 'package:news_app/models/model.dart';
class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewsHeadlines() async{
    String url="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=7763a68aef37454f8c390f5dc8c3f04d";
    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      log(response.body);
    }

    if(response.statusCode==200) {
      final dataresponse = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(dataresponse);
    }
    throw Exception('Error'); 
  }
  Future<NewsHeadlinesModel> fetchCountryData(String countryName)async{
    String url = 'https://newsapi.org/v2/top-headlines?country=${countryName}&apiKey=7763a68aef37454f8c390f5dc8c3f04d' ;
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }

    throw Exception('Error');
  } 
  Future<GeneralNewsModel> fetchGeneralNews(String query)async{
    String url = 'https://newsapi.org/v2/everything?q=$query&apiKey=7763a68aef37454f8c390f5dc8c3f04d';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return GeneralNewsModel.fromJson(body);
    }

    throw Exception('Error');
  } 
  Future<GeneralNewsModel> fetchGeneralNews2(String query)async{
    String url = 'https://newsapi.org/v2/everything?q=${query}&from=2023-08-31&to=2023-08-31&sortBy=popularity&apiKey=7763a68aef37454f8c390f5dc8c3f04d';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return GeneralNewsModel.fromJson(body);
    }

    throw Exception('Error');
  } 
}