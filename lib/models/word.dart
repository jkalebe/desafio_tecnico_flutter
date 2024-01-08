class Word {
  final String word;
  final int value;
  bool isFavorite;
  bool isViewed;

  Word({required this.word, required this.value, this.isFavorite = false, this.isViewed = false});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] as String,
      value: json['value'] as int,
      isFavorite: json['isFavorite'] == 1,
      isViewed: json['isViewed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'value': value,
      'isFavorite': isFavorite,
      'isViewed': isViewed,
    };
  }
}