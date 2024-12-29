class QuizModel {
  final String? correctAnswer;
  final String? category;
  final List<String>? incorrectAnswers;
  List<String>? answersOptions;
  final String? question;
  final String? difficulty;
  bool answerCorrectly;

  QuizModel({
    required this.correctAnswer,
    required this.category,
    required this.incorrectAnswers,
    required this.answersOptions,
    required this.question,
    required this.difficulty,
    this.answerCorrectly = false,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      correctAnswer: json['correctAnswer'] ?? '',
      category: json['category'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrectAnswers']),
      question: json['question']['text'],
      difficulty: json['difficulty'] ?? '',
      answerCorrectly: false,
      answersOptions: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'question': question,
      'difficulty': difficulty,
    };
  }
}