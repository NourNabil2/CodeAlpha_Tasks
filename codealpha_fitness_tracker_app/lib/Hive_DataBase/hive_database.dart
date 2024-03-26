
import 'package:hive_flutter/hive_flutter.dart';

import '../datetime/date_time.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDatabase {

  final _myBox = Hive.box("workout_database1");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {

      return true;
    }
  }
  String getStartDate() {
    return _myBox.get("START_DATE");
  }


  void saveToDatabase(List<Workout> workouts) {
    //convert workout objects into lists of strings so that we can save in hive
    final WorkoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }
    //"COMPLETION_STATUS_20240129"-> 1 or 0
    _myBox.put("WORKOUTS", WorkoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");

    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {

      List<Exercise> exercisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {

        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }


  bool exerciseCompleted(List<Workout> workouts) {

    for (var workout in workouts) {

      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given data yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    //returns 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

//converts workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //eg. [upperbody, lowerbody]
  ];
  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//converts the exercises in a workout object into a list of strings
//so we have a list [each list of workoutname have a list/lists of exercises]
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [

  ];
  //go through each workout

  for (int i = 0; i < workouts.length; i++) {
    // get exercises from each workout
    List<Exercise> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [
    ];
    //go through each exercise in exerciseList
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        // [biceps, 10kg, 10reps, 3sets],[triceps, 20kg, 10reps, 3sets],
      ];
      individualExercise.addAll([
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
