import 'package:dictionary_app/components/list/details/audio_player.dart';
import 'package:dictionary_app/components/list/details/meanings.dart';
import 'package:dictionary_app/helpers/state.dart';
import 'package:dictionary_app/models/app_state.dart';
import 'package:dictionary_app/models/word_details.dart';
import 'package:flutter/material.dart';

class WordDetailsView extends StatefulWidget {
  const WordDetailsView({
    super.key,
  });

  @override
  State<WordDetailsView> createState() => _WordDetailsViewState();
}

class _WordDetailsViewState extends State<WordDetailsView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final AppState appState = StateUtils.appStateWithContext(context);
    isLoading = true;
    appState.getDetailsWord().then((value) {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState =
        StateUtils.appStateWithContextAndWithListener(context);
    final WordDetails? wordDetails = appState.currentWordDetails;
    final bool isFavorite = appState.currentWord?.isFavorite ?? false;
    final url = getUrlAudio(wordDetails?.phonetics);

    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: isLoading || appState.currentWordDetails == null
            ? null
            : IconButton(
                icon: Icon(Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.grey),
                onPressed: () {
                  appState.addWordToFavorite();
                }),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : wordDetails != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.pinkAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(wordDetails.word),
                              Text(wordDetails.phonetic??""),
                            ],
                          ),
                        ),
                        Container(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Meanings",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        AudioPlayerWidget(
                          audioUrl: url,
                        ),
                        Expanded(
                            child:
                                MeaningsWidget(meanings: wordDetails.meanings))
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      "Palavra não encontrada",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ));
  }

  String? getUrlAudio(List<Phonetic>? phonetics) {
    return phonetics
        ?.where(
            (element) => element.audio != null && element.audio!.isNotEmpty,).firstOrNull?.audio;
  }
}
