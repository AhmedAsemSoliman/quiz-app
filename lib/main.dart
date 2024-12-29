import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizly_app/controller/provider/quiz_provider.dart';
import 'package:quizly_app/controller/services/api_services.dart';
import 'package:quizly_app/views/quiz_screen.dart';
import 'package:sizer/sizer.dart';

void main() async{
 await ApiServices().fetchQuizData();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder:(context,_,__){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<QuizProvider>(create:(context)=>QuizProvider())
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home:QuizScreen()
          ),
        );
      },
    );
  }
}
