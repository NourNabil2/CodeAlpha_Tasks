
import 'package:codealpha_fitness_tracker_app/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../Hive_DataBase/workout_data.dart';
import '../components/heat_map.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  // text controller
  TextEditingController newWorkoutNameController = TextEditingController();

  // create a new workout
  void addWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Create a new workout"),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: () {
                //get workout name from text controller
                String newWorkoutName = newWorkoutNameController.text;
                //check if the workout is empty
                if(checkNewWorkoutNameIfEmpty(newWorkoutName)){
                // add workout to workoutdata list
                Provider.of<WorkoutData>(
                context,
                listen: false,
                ).addWorkout(newWorkoutName);
                //pop dialog box
                Navigator.pop(context);
                clear();
                }
                },
                  child: const Text("save"),
                ),
                // cancel button
                MaterialButton(
                  onPressed: () {
                Navigator.pop(context);
                clear();
                },
                  child: const Text("cancel"),
                ),
              ],
            ),
    );
  }


  bool checkNewWorkoutNameIfEmpty(String newWorkoutName){
    if(newWorkoutName==''){
      var snackBar = const SnackBar(content: Text('NO Workout added!!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }


  //clear controllers
  void clear() {
    newWorkoutNameController.clear();
  }

  void updateWorkout(int indexOfWorkout,String oldWorkoutName){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update the workout"),
        content: TextField(
          decoration: InputDecoration(hintText: oldWorkoutName),
          controller: newWorkoutNameController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              saveExistingWorkout(indexOfWorkout,oldWorkoutName);
            },
            child: const Text("save"),
          ),
          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              clear();
            },
            child: const Text("cancel"),
          ),
        ],
      ),
    );
  }
  void saveExistingWorkout(int indexOfWorkout,String oldWorkoutName){
    String newWorkoutName = newWorkoutNameController.text;
    if(newWorkoutName!='') {
      // add exercise to workout
      Provider.of<WorkoutData>(
        context,
        listen: false,
      ).updateWorkout(
        indexOfWorkout,
        newWorkoutName,
      );
    }
    //pop dialog box
    Navigator.pop(context);
    clear();
  }
  void deleteWorkout(int indexOfWorkout){
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).deleteWorkout(
      indexOfWorkout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.white30,
          title: const Center( child: Text("Fitness Tracker App",style: TextStyle(fontWeight: FontWeight.bold,),)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: FloatingActionButton(
            clipBehavior: Clip.antiAlias,
            elevation: 15,
            foregroundColor: Colors.tealAccent,
            backgroundColor: Colors.teal,
            onPressed: addWorkout,
            child: const Text('Add New Workout',style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold),),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
           gradient: LinearGradient(colors: [Colors.white70,Colors.white60,Colors.white38,Colors.white30],begin: AlignmentDirectional.bottomEnd)
          ),
          child: ListView(
            children: [
              // Heap Map
              MyHeatMap(
                  datasets: value.heapMapDataSet,
                  startDateYYYYMMDD: value.getStartDate()),
              //Workout List
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        //update option
                        SlidableAction(onPressed: (context) =>updateWorkout(index,value.getWorkoutList()[index].name),
                          backgroundColor: Colors.grey.shade800,
                          icon: Icons.settings,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        //delete option
                          SlidableAction(onPressed: (context) =>deleteWorkout(index),
                          backgroundColor: Colors.red.shade400,
                          icon: Icons.delete,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutPage(
                            workoutName: value.getWorkoutList()[index].name ,
                            index: index,
                          ),
                        ),
                      )

                      ,
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                      child: ListTile(
                      title: Text(
                        value.getWorkoutList()[index].name,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
