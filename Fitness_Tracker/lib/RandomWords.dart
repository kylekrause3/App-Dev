import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  void _pushSaved(){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (context){
              final tiles = _saved.map(
                      (pair) {
                    return ListTile(
                        title: Text(
                          pair.asPascalCase,
                          style: _biggerFont,
                        )
                    );
                  }
              );
              final divided = tiles.isNotEmpty
                  ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
                  : <Widget>[];
              return Scaffold(
                appBar : AppBar(
                    title: const Text('Saved Suggestions')
                ),
                body: ListView(children: divided),
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            )
          ],
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i){
              if(i.isOdd) return const Divider(); //every odd index given a divider

              final index = i ~/ 2;
              if(index >= _suggestions.length){
                _suggestions.addAll(generateWordPairs().take(10));
              }

              final alreadySaved = _saved.contains(_suggestions[index]);
              return ListTile( //fixed height row that contains text
                title: Text(
                  _suggestions[index].asPascalCase,
                  style: _biggerFont,
                ),
                trailing: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                ),
                onTap: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(_suggestions[index]);
                    } else {
                      _saved.add(_suggestions[index]);
                    }
                  });
                },
              );
            }
        )
    );
  }
}