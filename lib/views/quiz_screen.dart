import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quizly_app/controller/provider/quiz_provider.dart';
import 'package:quizly_app/models/auiz_model.dart';
import 'package:quizly_app/utlis/colors.dart';
import 'package:quizly_app/utlis/text_style.dart';
import 'package:sizer/sizer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    Provider.of<QuizProvider>(context, listen: false).fetchDataQuiz();
  }

  String convertToTitleCase(String input) {
    List<String> words = input.split('_');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }
    return words.join(' ');
  }

  Color getColorBasedOnQuestionDifficulty(String difficulty) {
    if (difficulty == 'easy') {
      return teal;
    } else if (difficulty == 'medium') {
      return yellow;
    } else {
      return red;
    }
  }

  Color updateOptionColor(int index) {
    QuizModel? quizProvider = Provider.of<QuizProvider>(context).currentQuiz;
    if ((selectedIndex != -1) &&
        (quizProvider?.answersOptions?[selectedIndex]) ==
            (quizProvider?.correctAnswer) &&
        (selectedIndex == index)) {
      return green;
    } else if ((selectedIndex != -1) &&
        (quizProvider?.answersOptions?[index]) ==
            (quizProvider?.correctAnswer)) {
      return green;
    } else if ((selectedIndex != -1) &&
        (quizProvider?.answersOptions?[selectedIndex]) !=
            (quizProvider?.correctAnswer) &&
        selectedIndex == index) {
      return red;
    } else {
      return grey100!;
    }
  }

  void restartQuizDialogueBox() {
    List<QuizModel> quiz = Provider.of<QuizProvider>(context,listen: false).quizList;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Congratulations! Your Score: ${quiz.where((quizData) => quizData.answerCorrectly == true).length}/${quiz.length}',
                style: AppTextStyle.body2,
              ),
              SizedBox(height: 5.h),
              ElevatedButton(
                onPressed: () {
                  Provider.of<QuizProvider>(context, listen: false).fetchDataQuiz();
                  setState(() {
                    selectedIndex = -1;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Restart Quiz',
                  style: AppTextStyle.body3.copyWith(color: white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: black,
                  minimumSize: Size(70.w, 6.h),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: grey300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(94.w, 6.h),
            ),
            onPressed: () {
              if ((Provider.of<QuizProvider>(context, listen: false).quizIndex + 1) ==
                  (Provider.of<QuizProvider>(context, listen: false).quizList.length)) {
                restartQuizDialogueBox();
              } else {
                print('index = ${(Provider.of<QuizProvider>(context, listen: false).quizIndex + 1)}');
                Provider.of<QuizProvider>(context, listen: false).updateCurrentQuiz(selectedIndex);
                setState(() {
                  selectedIndex = -1;
                });
              }
            },
            child: Text(
              'Next question',
              style: AppTextStyle.body3,
            ),
          ),
          body: Consumer<QuizProvider>(
              builder: (context, provider, child) {
                if (provider.quizList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else {
                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.w),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Difficulty: ',
                                    style: AppTextStyle.body3,
                                  ),
                                  TextSpan(
                                    text: convertToTitleCase(
                                      '${provider.currentQuiz!.difficulty}',
                                    ),
                                    style: AppTextStyle.body3.copyWith(
                                      color: getColorBasedOnQuestionDifficulty(
                                        provider.currentQuiz!.difficulty!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Text(
                                '${provider.quizList.where((quizData) => quizData.answerCorrectly == true).length}/${provider.quizList.length}',
                                style: AppTextStyle.body3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Q ${provider.quizIndex + 1}: ',
                              style: AppTextStyle.headline2,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        provider.currentQuiz!.question.toString(),
                        style: AppTextStyle.headline3,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 3.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Genre: ',
                              style: AppTextStyle.body3.copyWith(color: grey),
                            ),
                            TextSpan(
                              text: convertToTitleCase('${provider.currentQuiz!.category}'),
                              style: AppTextStyle.body3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 600,
                        width: 500,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.currentQuiz?.answersOptions?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: ElevatedButton(
                            onPressed:provider.quiestionAnswered==true?(){}:(){
                              setState(() {
                                Provider.of<QuizProvider>(context,listen:false).quizQuestionAnswer();
                                selectedIndex=index;
                              });

                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:updateOptionColor(index),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                minimumSize: Size(94.w, 6.h)),
                            child: Text(
                              provider.currentQuiz!.answersOptions![index],
                              style: AppTextStyle.body1,
                            )),
                      );
                    }),
              )
            ],
          );
        }
      })),
    );
  }
}
