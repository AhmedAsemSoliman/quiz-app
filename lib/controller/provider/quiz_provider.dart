import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:quizly_app/controller/services/api_services.dart';
import 'package:quizly_app/models/auiz_model.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizModel> quizList = [];
  QuizModel? currentQuiz;
  int quizIndex = 0;
  bool quiestionAnswered=false;

  Future<void> fetchDataQuiz() async {
    List<dynamic> resQuizList = await ApiServices().fetchQuizData();
    List<QuizModel> quizData = [];
    for (var data in resQuizList) {
      QuizModel quizModel = QuizModel.fromJson(data);
      List<String>? incOptions = quizModel.incorrectAnswers;
      incOptions!.add(quizModel.correctAnswer!);
      incOptions.shuffle();
      quizModel.answersOptions = incOptions;
      quizData.add(quizModel);
    }
    quizList = quizData;
    currentQuiz = quizData[0];
    quizIndex = 0;
    quiestionAnswered=false;
    print(quizList.length);
    print(quizList);
    notifyListeners();
  }
quizQuestionAnswer(){
    quiestionAnswered=true;
    notifyListeners();
}
  void updateCurrentQuiz(int selectedIndex) {
    if(currentQuiz!.answersOptions![selectedIndex]==currentQuiz!.correctAnswer){
      currentQuiz!.answerCorrectly=true;
      notifyListeners();
    }
    if (quizIndex + 1 < quizList.length) {
      quizIndex++;
      currentQuiz = quizList[quizIndex];
      quiestionAnswered=false;
      notifyListeners();
    }
  }
}