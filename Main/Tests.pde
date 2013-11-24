class Test {
  String name;
  Question[] questions = {};
  int currentQuestionIndex = 0;
  boolean isComplete = false;
  
  Test() {
    
  }
  
  Test(String _name, int numOfQuestions) {
    name = _name;
    for (int i = 0; i < numOfQuestions; i++) {
      questions = (Question[]) append(questions, new Question(i, 3));
    }
  }
} // end of class Test

class Question {
  int number; //question number
  Circle[] circles = {};
  float[][] circle_overlaps = {};
  int[] test = {};
  Goal[][] goals = {};
  boolean isComplete = false;

  String[] nouns = {"awful things",
                    "awkward things",
                    "beautiful things",
                    "brave things",
                    "boring things",
                    "big things",
                    "small things",
                    "cool things",
                    "complicated things",
                    "As",
                    "Bs",
                    "Cs",
                    "Ds",
                    "wiggleworts",
                    "aggletafts",
                    "tillygrufts"};

  String[][][] tests = {
    {{"All", "Some", "Some"},
    {"Some", "All", "Some"},
    {"Some", "Some", "All"}},
    
    {{"All", "No", "No"},
    {"No", "All", "Some"},
    {"No", "Some", "All"}},

    {{"All", "No", "Some"},
    {"No", "All", "No"},
    {"All", "No", "All"}},
    
    {{"All", "All", "All"},
    {"Some", "All", "Some"},
    {"Some", "All", "All"}},
    
    {{"All", "No", "No"},
    {"No", "All", "Some"},
    {"No", "All", "All"}},
    
    {{"All", "Some", "No"},
    {"All", "All", "No"},
    {"No", "No", "All"}},
    
    {{"All", "Some", "Some"},
    {"All", "All", "No"},
    {"All", "No", "All"}}
  };

  Question(int _index, int numOfCircles) {
    number = _index + 1;
    int testNo = int(random(0, tests.length));
    
    for (int i = 0; i < numOfCircles; i++) {
      int cNameIndex = int(random(0, nouns.length));
      String nameUsed = "Used";
      String cName = "Used";
      while (nameUsed == "Used") {
        cNameIndex = int(random(0, nouns.length));
        cName = nouns[cNameIndex];
        if (cName != "Used") {
          nouns[cNameIndex] = "Used";
          nameUsed = "Done";
        }
      }
      //populate the goals 2D array
      goals = (Goal[][]) append(goals, new Goal[]{});

      for (int j = 0; j < numOfCircles; j++) {
        goals[i] = (Goal[]) append(goals[i], new Goal("tempName"));
        goals[i][j].name = tests[testNo][i][j];
      }
      
      
      /*  //RANDOM GOAL GENERATION
      for (int j = 0; j < numOfCircles; j++) {
        goals[i] = (Goal[]) append(goals[i], new Goal("tempName"));
        if (j == i) {
          goals[i][j].name = "Itself";
          goals[i][j].isComplete = true;
        } else {
          float randomNumber = random(1);
          if (randomNumber < 0.33) {
            goals[i][j].name = "Some";
          } else if (randomNumber < 0.66) {
            goals[i][j].name = "All";
          } else {
            goals[i][j].name = "No";
          }
        }
      }*/
      float cXPos = (screenWidth / (numOfCircles + 1)) * (i + 1);
      int cRadius = int(random(25, 60));
      circles = (Circle[]) append(circles, new Circle(cName, cXPos, screenHeight * 3 / 4, cRadius));
    }
  }

  /*
  float[][] constructLogicalRelationships(int numOfCircles) {
    float[][] relationArray = {};
    
    //initialize array with 0s so I can tell later if that spot is empty
    for (int i = 0; i < numOfCircles; i++) {
      for (int j = 0; j < numOfCircles; j++) {
        if relationArray{i}{j} = 0;
        //the opposite relation will have to be 0 as well
        relationArray{j}{i} = 0;
      }
    }
    for (int i = 0; i < numOfCircles; i++) {
      for (int j = 0; j < numOfCircles; j++) {
        //check the value for this coordinate; if it's zero, put some random
        //relation there (eg "some", "none", or "all").  1 means none, 2 means
        //some, 3 means all
        if (relationArray{i}{j} == 0) {
          
          //first I need to check if the opposite relation is something that
          //will limit my options
          int oppositeRelation = relationArray{j}{i};
          int randomRelation = int(random(3)) + 1; //random # from 1 to 3
          relationArray{i}{j} = randomRelation;
          
          //then I need to figure out what the opposite relation will be
        }
        //otherwise I need to check if the current relation breaks any rules

      }
    }
      
    return testThing;
  }
  */
  
} // end of class Question

class Goal {
  String name;
  boolean isComplete = false;
  
  Goal(String _name) {
    name = _name;
  }
}


void checkIfQuestionIsComplete() {
  //check to see if all the goals have been completed; if so, go to next Q
  int completedGoals = 0;
  for (int i = 0; i < goals.length; i++) {
    for (int j = 0; j < goals[i].length; j++) {
      if (j == i) {
        continue;
      } else if (goals[i][j].isComplete == true) {
        completedGoals++;
      }
    }
  }
  int numOfAllGoals = int(pow((goals.length), 2)) - goals.length;
  if ((completedGoals == numOfAllGoals) && (mousePressed == false)){
    currentQuestion.isComplete = true;
    question_complete.play();
    question_complete = minim.loadFile("question_complete.wav");
  }

  Question lastQuestion = test1.questions[(test1.questions.length - 1)];
  if (currentQuestion.isComplete && (currentQuestion != lastQuestion)) {
    currentQuestionIndex++;
    currentQuestion = test1.questions[currentQuestionIndex];
    circles = currentQuestion.circles;
    goals = currentQuestion.goals;
  } else if (currentQuestion.isComplete && (currentQuestion == lastQuestion)) {
    test1.isComplete = true;
    currentScreen = "Menu";
  }
}

