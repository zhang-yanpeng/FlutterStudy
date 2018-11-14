import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//  借助第三方库，随意生成文本
//    final wordPair = new WordPair.random();

    return new MaterialApp(
      title: 'First Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWordsStates extends State<RandomWords> {
//集合，用来保存原始单词
  final _suggesss = <WordPair>[];

//设置字体大小 颜色
  final _style = const TextStyle(fontSize: 18.0, color: Colors.blue);

//收藏的条目集合
  final _save = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter"),
//      添加一个列表图标
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.ac_unit), onPressed: null),
          new IconButton(icon: new Icon(Icons.list), onPressed: pushSave),
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
//        列表中每个item 都会执行一次此方法
          if (i.isOdd) return new Divider();
//      获得证书，i~/2向下取整
          final index = i ~/ 2;
          if (index >= _suggesss.length) {
//        生成10个单词，加入列表
            _suggesss.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggesss[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
//  判断当前条目是否已经添加收藏
    final alreadySave = _save.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _style,
      ),
      trailing: new Icon(alreadySave ? Icons.favorite : Icons.favorite_border,
          color: alreadySave ? Colors.red : null),
//    添加click事件
      onTap: () {
        setState(() {
          if (alreadySave) {
            _save.remove(pair);
          } else {
            _save.add(pair);
          }
        });
      },
    );
  }

//跳转至新的页面
  void pushSave() {
//  通过路由来进行跳转
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _save.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _style,
          ),
        );
      });

      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();


      return new Scaffold(
        appBar: new AppBar(title: new Text("Save"),),
        body: new ListView(children: divided,),
      );

    }));
  }
}

/**
 * 可滚动的状态
 */
class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsStates();
  }
}
