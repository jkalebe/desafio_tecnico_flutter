import 'package:dictionary_app/models/app_state.dart';
import 'package:dictionary_app/models/word.dart';
import 'package:dictionary_app/views/word_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/widgets.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          final items = appState.items;
          return GridView.builder(
            // Define o número de colunas
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  onTap(items[index], appState);
                },
                child: GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(items[index].word),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onTap(Word word, AppState appState){
    appState.setCurrentWord(word);
    appState.setCurrentWordDetails(null);
    nextScreen(context, WordDetailsView());
  }
}
