import 'package:flutter/material.dart';
import 'package:new_app/network/rss.dart';
import 'package:new_app/screen/news_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List listTitle = [
      'Trang chu',
      'The gioi',
      'Kinh doanh',
      'The thao',
      'Khoa hoc'
    ];
    List listUrl = [
      'https://vnexpress.net/rss/tin-moi-nhat.rss',
      'https://vnexpress.net/rss/the-gioi.rss',
      'https://vnexpress.net/rss/kinh-doanh.rss',
      'https://vnexpress.net/rss/the-thao.rss',
      'https://vnexpress.net/rss/khoa-hoc.rss'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              child: ListTile(
                title: Text(listTitle[index]),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewsScreen(url: listUrl[index])));
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: listTitle.length),
    );
  }
}
