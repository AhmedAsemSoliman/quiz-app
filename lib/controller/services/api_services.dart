import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:quizly_app/controller/services/api_header.dart';
class ApiServices{
  Future fetchQuizData()async{
    try{
    http.Response response=await  http.get(Uri.parse(quizApi),headers:{
      "Content":"application/json" ,
      "Accept":"application/json"
    } ).timeout(Duration(minutes:1),onTimeout:(){
      throw Exception('Connection TimeOut...');
    });
    if(response.statusCode==200){
      var resDecode=jsonDecode(response.body);
      print(resDecode);
      return resDecode;
      }
    return [];
    }catch(error){
    //  log(int.parse(error.toString()));
    }
  }
}