import 'dart:developer';

import 'package:codealpha_flashcard_quiz_app/Quiz_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Quiz_Class.dart';
import 'constant.dart';

class Homme_Screen extends StatefulWidget {
  const Homme_Screen({super.key});

  @override
  State<Homme_Screen> createState() => _Homme_ScreenState();
}

class _Homme_ScreenState extends State<Homme_Screen> {
  void initState() {

    super.initState();
  }
  GlobalKey<FormState> formKey = GlobalKey();
  bool answer = true;
  String? Question;
  List<questionclass> questionList = [];
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Add Question...'),
              controller: controller,
              validator: (data) {
                if (data!.isEmpty) {
                  return 'field is required';
                }
              },
              autofocus: true,
              onChanged: (value) {
                Question = value;
              },
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
             const Text('Answer is true?'),
             Checkbox(value: answer, onChanged: (value) => setState(() {
               answer = !answer;
             })),
           ],),
            TextButton(
                onPressed: () {
                  questionList.add(questionclass(a:answer ,q:  Question));
                  controller.clear();
                },
                child: const Text("add Question")),
        SizedBox(height: 100,),
            TextButton(
                onPressed: () {
                    if (questionList.isNotEmpty )
                    {
                      log( '${questionList.length}' );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Quiz_Screen(question: questionList,)));
                    }
                  else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('NO Question added!'),
                        ),
                      );
                  }
                },
                child: Text("Start Quiz")),

          ],
        ),
      ),
    );
  }
}
