import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Quiz_Class.dart';
import 'constant.dart';


class Quiz_Screen extends StatefulWidget {
  final   List<questionclass> question;

  const Quiz_Screen({super.key, required this.question,});

  @override
  State<Quiz_Screen> createState() => HomeState(question: question );
}

class HomeState extends State<Quiz_Screen> {
  final   List<questionclass> question;

  HomeState({ required this.question});

  List<SwipeItem> _swipeItems = [];
  MatchEngine? matchEngine;
  List<Icon> cheak = [];
  void initstate()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    quizbrain QuizBrain =quizbrain(question: question );

        for (int i = 0; i < QuizBrain.question.length ; i++) {
          _swipeItems.add(
              SwipeItem(
                  content: Content(text: QuizBrain.question[i].q!, color: Colors.grey),
                  likeAction: () {
                    bool? cheakanswer = QuizBrain.getAnswer();
                    if (cheakanswer == true) {

                        cheak.add(Icon(Icons.check, color: Colors.green,));


                      QuizBrain.qtrue++;

                    }
                    else if (cheakanswer == false) {

                        cheak.add(Icon(Icons.close, color: Colors.red,));


                      QuizBrain.qfalse++;

                    }

  QuizBrain.nextQuestion();




                  },

                  nopeAction: () {
                    bool? cheakanswer = QuizBrain.getAnswer();
                    if (cheakanswer == false) {

                        cheak.add(Icon(Icons.check, color: Colors.green,));


                      QuizBrain.qtrue++;

                    }
                    else if (cheakanswer == true) {

                        cheak.add(Icon(Icons.close, color: Colors.red,));

                      QuizBrain.qfalse++;

                    }



                      QuizBrain.nextQuestion();



                  },


                  onSlideUpdate: (SlideRegion? region) async {
                    print("Region $region");
                  }));
        }

    matchEngine = MatchEngine(swipeItems: _swipeItems);
    return Scaffold(
      body: Container(
        color: Colors.white,
          child: Column(children: [
            Container(
              height: 550,
              child: SwipeCards(
                matchEngine: matchEngine!,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color:  _swipeItems[index].content.color,
                    alignment: Alignment.center,
                    child: Text(
                      _swipeItems[index].content.text,
                      style: TextStyle(fontSize: 50),
                    ),
                  );
                },
                onStackFinished: () {

                  Alert(
                    context: context,
                    type: AlertType.success,
                    title: "End of Question",
                    desc: ' worng answer : ${QuizBrain.qfalse} \n  '
                        ' right answer : ${QuizBrain.qtrue}   ',
                    buttons: [
                      DialogButton(
                        child:
                        Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);

                  } ,
                        width: 120,
                      )
                    ],
                  ).show();

            QuizBrain.reset();
            setState(() {
              cheak = [];
            });




                },
                itemChanged: (SwipeItem item, int index) {
                  print("item: ${item.content.text}, index: $index");
                },
                upSwipeAllowed: true,
                fillSpace: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      matchEngine?.currentItem?.nope();
                    },
                    child: Text("False")),
                TextButton(
                    onPressed: () {
                      matchEngine?.currentItem?.like();
                    },
                    child: Text("True"))
              ],
            ),
            Row(
                children: cheak
            ),
          ])),
    );
  }
}
