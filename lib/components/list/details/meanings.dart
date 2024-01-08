import 'package:dictionary_app/models/word_details.dart';
import 'package:flutter/material.dart';

class MeaningsWidget extends StatelessWidget {
  final List<Meaning> meanings;

  MeaningsWidget({Key? key, required this.meanings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meanings.length,
      itemBuilder: (context, index) {
        final meaning = meanings[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${meaning.partOfSpeech} - ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(child: Text(meaning.definitions[0].definition)),
            ],
          ),
        );
      },
    );
  }
}
