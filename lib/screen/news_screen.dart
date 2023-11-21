import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_app/network/rss.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class NewsScreen extends StatefulWidget {
  String url;
  NewsScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Rss rss = Rss();
  List news = [];
  Future<void> readRss(String url) async {
    final Xml2Json xml2json = Xml2Json();
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      xml2json.parse(response.body.toString());
      var jsonData = await xml2json.toGData();
      var data = json.decode(jsonData);
      news = data['rss']['channel']['item'];
      print(news);
    } else {
      print('Failed to load RSS: ${response.statusCode}');
      print(response.body);
    }
  }

  String getImgUrl(String htmlString) {
    var document = parse(htmlString);
    var imgElement = document.getElementsByTagName('img').first;
    String? imageUrl = imgElement.attributes['src'];
    return imageUrl!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News screen'),
      ),
      body: FutureBuilder(
        future: readRss(widget.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: NetworkImage(
                            getImgUrl(news[index]['description']['__cdata'])),
                        width: 80,
                        height: 60,
                      ),
                      GestureDetector(
                        child: Expanded(
                          child: Text(
                            '${news[index]['title']['\$t']}',
                            softWrap: true,
                          ),
                        ),
                        onTap: (){},
                      )
                    ],
                  );
                });
          }
        },
      ),
    );
  }
}
