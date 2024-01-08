import 'dart:async';
import 'dart:io' as io;
import 'package:dictionary_app/models/word.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await setDB();
    return _db!;
  }

  DatabaseHelper.internal();

  final StreamController<List<Word>> _wordsStreamController = StreamController.broadcast();

  Stream<List<Word>> get wordsStream => _wordsStreamController.stream;

  setDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'DATABASE_COLETOR.db');
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE word (
      word TEXT PRIMARY KEY,
      value INTEGER,
      isFavorite INTEGER,
      isViewed INTEGER
    )''');
  }

  Future<bool> hasData() async {
    var dbClient = await db;

    try {

      int? countLotes = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM word'));

      return countLotes! > 0;
    } catch (error) {
      print("Erro ao verificar dados: $error");
      return false;
    }
  }

  Future<int?> getDatabaseVersion() async {
    var dbClient = await db;
    return await dbClient.getVersion();
  }

  Future<void> close() async {
    var dbClient = await db;
    return await dbClient.close();
  }

  Future<int> updateWord(Word word) async {
    final dbClient = await db;

    final existingWord = await dbClient.query(
      'word',
      where: 'word = ?',
      whereArgs: [word.word],
    );

    if (existingWord.isNotEmpty) {
      return await dbClient.update(
        'word',
        word.toJson(),
        where: 'word = ?',
        whereArgs: [word.word],
      );
    } else {
      final newWord = Word(
        word: word.word,
        value: word.value,
        isFavorite: word.isFavorite,
        isViewed: word.isViewed,
      );
      return await dbClient.insert('word', newWord.toJson());
    }
  }

  Future<List<Word>> getAllViewed() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'word',
      where: 'isViewed = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Word.fromJson(maps[i]);
    });
  }

  Future<bool> isWordFavorite(Word word) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'word',
      where: 'word = ? AND isFavorite = ?',
      whereArgs: [word.word, 1],
      limit: 1,  // Limita os resultados a apenas um registro
    );

    return maps.isNotEmpty;
  }

  Future<List<Word>> getAllFavorites() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'word',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Word.fromJson(maps[i]);
    });
  }

  Future<List<Word>> getAllWords() async {
    final dbClient = await db;
    try {
      final maps = await dbClient.query('word', orderBy: 'modification DESC');
      final words = List.generate(maps.length, (i) => Word.fromJson(maps[i]));
      _wordsStreamController.add(words); // Adiciona relatórios à Stream
      return words;
    } catch (e) {
      print("Error getting all words: $e");
      throw e;
    }
  }

  void dispose() {
    _wordsStreamController.close();
  }

}