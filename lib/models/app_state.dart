import 'dart:convert';

import 'package:dictionary_app/models/word.dart';
import 'package:dictionary_app/models/word_details.dart';
import 'package:dictionary_app/service/word_service.dart';
import 'package:dictionary_app/services/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AppState with ChangeNotifier {
  List<Word> items = [];
  List<Word> allViewed = [];
  List<Word> allFavorites = [];

  WordDetails? _currentWordDetails;
  Word? _currentWord;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  WordDetails? get currentWordDetails => _currentWordDetails;
  Word? get currentWord => _currentWord;

  void setCurrentWordDetails(WordDetails? wordDetails) {
    _currentWordDetails = wordDetails;
    notifyListeners();
  }

  void setCurrentWord(Word word) {
    _currentWord = word;
    notifyListeners();
  }


  void appInit(){
    loadJsonData();
  }


  void loadJsonData() async {
    String data = await rootBundle.loadString('assets/words_dictionary.json');
    Map<String, dynamic> jsonResult = json.decode(data);

    List<Word> loadedItems = [];
    jsonResult.forEach((word, value) {
      loadedItems.add(Word(word: word, value: value));
    });

    items = loadedItems;
    notifyListeners();
  }

  Future<void> getDetailsWord() async {
    if(_currentWord == null) throw "Erro inesperado";
    try {
      _currentWordDetails = await WordService().fetchWordDetails(_currentWord!.word);
      if(_currentWordDetails != null) {
        addWordToViewed(_currentWord!);
      }
    } on Exception catch (e) {
      _currentWordDetails == null;
    }
    notifyListeners();
  }
  
  void addWordToFavorite(){
    if(_currentWord == null) throw "Erro inesperado";
    try {
      Word word = _currentWord!;
      word.isFavorite = !word.isFavorite;
      _databaseHelper.updateWord(word);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  void addWordToViewed(Word word){
    word.isViewed = true;
    _databaseHelper.updateWord(word);
  }

  void getAllViewed() async {
    allViewed = await _databaseHelper.getAllViewed();
    notifyListeners();
  }

  void getAllFavorites() async {
    allFavorites = await _databaseHelper.getAllFavorites();
    notifyListeners();
  }

  Future<bool> isWordFavorite(Word word){
    return _databaseHelper.isWordFavorite(word);
  }

}