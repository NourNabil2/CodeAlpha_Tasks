
import 'constant.dart';
class quizbrain {
  final   List<questionclass> question;

  quizbrain({required this.question});


  int questionNum=0;
  int qtrue =0;
  int qfalse =0;


  String getquestion()
  {
    return question[questionNum].q.toString();
  }
  bool? getAnswer  ()
  {
    return question[questionNum].a;
  }
  void nextQuestion ()
  {
    if (questionNum < question.length - 1)
    {
      questionNum++;
    }

  }

  void reset() {
    questionNum = 0;
    question.clear();
    qfalse=0;
    qtrue=0;
  }
}