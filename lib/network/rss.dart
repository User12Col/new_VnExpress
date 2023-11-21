import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../model/news.dart';

class Rss {
  Future<void> readRss(String url) async {
    List news = [];
    List obj = [];
    final Xml2Json xml2json = Xml2Json();
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      xml2json.parse(response.body.toString());
      var jsonData = await xml2json.toGData();
      var data = json.decode(jsonData);
      news = data['rss']['channel']['item'];

      //obj = convertToObject(news);

      //print(obj);
      print(news);
    } else {
      print('Failed to load RSS: ${response.statusCode}');
      print(response.body);
    }
  }

  List convertToObject(List news) {
    List obj = [];
    for(int i = 0 ;i<news.length;i++){
      String title = news[i]['title\$t'].toString();
      String imgUrl = news[i]['description']['__cdata'];
      String date = news[i]['pubDate\$t'].toString();
      String newLink = news[i]['link\$t'].toString();
      String description = news[i]['description']['__cdata'];

      print(title);

      News item = News(
          title: title,
          imgUrl: imgUrl,
          newLink: newLink,
          date: date,
          description: description);
      obj.add(item);
    }

    return obj;
  }
}
