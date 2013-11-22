//******************************************************************************
float screenWidth = 1000;
float screenHeight = 500;
Test test1 = new Test("Test 1", 10);
int currentQuestionIndex = test1.currentQuestionIndex;
Question currentQuestion = test1.questions[currentQuestionIndex];
Circle[] circles = currentQuestion.circles; //nickname
Goal[][] goals = currentQuestion.goals; //nickname
PFont BaskOldFace;
String currentScreen = "In-Game";
MenuButton[] inGameButtons = {
      new MenuButton("Main Menu", screenWidth - 150, 5, 125, 30)};
MenuButton[] menuButtons = {
      new MenuButton("Return to Game", screenWidth - 150, 5, 125, 30)};
int questionStartTime = (hour() * 3600) + (minute() * 60) + second();

import ddf.minim.*;
Minim minim;
AudioPlayer player;

void setup() {
  size(1000, 500);
  BaskOldFace = loadFont("BaskOldFace-48.vlw");
  minim = new Minim(this);
  player = minim.loadFile("theme.mp3");
  player.play();
}

void draw() {
  background(0);
  //draw_waveforms();
  updateMousePos();
  drawGUI();
  if (currentScreen == "In-Game") {
    drawCircleArray(circles);
    checkIfQuestionIsComplete();
  } else if (currentScreen == "Main Menu") {
  }
}

void draw_waveforms() {
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    stroke(255, 255, 255);
    line( x1, height/4 + player.left.get(i)*50, x2, height/4 + player.left.get(i+1)*50 );
    line( x1, height/2 + player.right.get(i)*50, x2, height/2 + player.right.get(i+1)*50 );
  }
}
void updateMousePos( ){
  if (currentScreen == "In-Game") {
    if (aCircleCenterIsBeingHoveredOver(circles)) {
      cursor(MOVE);
    } else if (aCircleRadiusIsBeingHoveredOver(circles)) {
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  } else if (currentScreen == "Main Menu") {
  }
}

void mousePressed() {
  if (currentScreen == "Menu") {
  } else if (currentScreen == "In-Game") {
    if (mouseButton == LEFT) {
      checkForSelectedCirclesInArray(circles);
    }
  }
}

void keyPressed() {
  if (currentScreen == "Menu") {
    
    if (key == 'k') {
      currentScreen = "In-Game";
    }
    
  } else if (currentScreen == "In-Game") {
    if (key == 'k') {
      currentScreen = "Menu";
    } else if (key == 'n') { //I use this to create new questions/goals
      for (int i = 0; i < goals.length; i++) {
        for (int j = 0; j < goals[i].length; j++) {
          String relation = howMuchOfCircle1IsInCircle2(circles[i], circles[j]);
          if (j == (goals[i].length - 1)) {
            print ("\"" + relation + "\"},\n");
          } else if (j == 0) {
            print ("{\"" + relation + "\", ");
          } else {
            print ("\"" + relation + "\", ");
          }
        }
      }
    } else if (key == 'a') {
      cursor(MOVE);
    }
  }
}

void mouseReleased() {
  if (currentScreen == "Menu") {

  } else if (currentScreen == "In-Game") {
    deselectCirclesInArray(circles);
  }
}

void mouseClicked() {
  if (currentScreen == "Menu") {
    processMenuGUIClicks();
  } else if (currentScreen == "In-Game") {
    processInGameGUIClicks();
  }
}

void mouseDragged() {
  if (currentScreen == "Menu") {

  } else if (currentScreen == "In-Game") {
    if (mouseButton == LEFT) {
      dragSelectedCirclesIn(circles);
      resizeSelectedCirclesIn(circles);
    }
  }
}

class Circle {
  String name;
  float centerX, centerY;
  float radius;
  boolean centerSelected = false;
  boolean radiusSelected = false;
  color circle_color = color(255, 255, 255);
  
  Circle(String _name, float _centerX, float _centerY, float _radius) {
    name = _name;
    centerX = _centerX;
    centerY = _centerY;
    radius = _radius;
  }

  boolean centerHasMouseOverIt() {
    float margin_for_error = radius * .3;
    if (dist(mouseX, mouseY, centerX, centerY) < margin_for_error) {
      circle_color = color(255, 80, 80);
      return true;
    } else {
      circle_color = color(255, 255, 255);
      return false;
    }
  }
  
  void drawSelf() {
      smooth();
      stroke(circle_color);
      noFill();
      ellipse(centerX, centerY, radius*2, radius*2);
      
      //draw label
      textFont(BaskOldFace);
      float txtSize = 24;
      textSize(txtSize);
      float x_offset = name.length() * txtSize / 4;
      fill(255);
      text(name, centerX - x_offset, centerY - radius);
  }
  
  boolean radiusHasMouseOverIt() {
    float distance = dist(mouseX, mouseY, centerX, centerY);
    float margin_for_error = radius * .3;
    if ((max((radius - margin_for_error), radius - 20) < distance) && 
        (distance < min((radius + margin_for_error), radius + 20))) {
      circle_color = color(255, 80, 80);
      return true;
    } else {
      circle_color = color(255, 255, 255);
      return false;
    }
  }
} //end of class Circle

boolean aCircleCenterIsBeingHoveredOver(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].centerHasMouseOverIt()) {
      return true;
    }
  }
  return false;
}

boolean aCircleRadiusIsBeingHoveredOver(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].radiusHasMouseOverIt()) {
      return true;
    }
  }
  return false;
}

void checkForSelectedCirclesInArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].centerHasMouseOverIt()) {
      circles[i].centerSelected = true;
      return;
    }
  }
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].radiusHasMouseOverIt()) {
      circles[i].radiusSelected = true;
      return;
    }
  }
}

void deselectCirclesInArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    circleArray[i].centerSelected = false;
    circleArray[i].radiusSelected = false;
  }
}

void dragSelectedCirclesIn(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    if (circleArray[i].centerSelected == true) {
      circleArray[i].centerX = mouseX;
      circleArray[i].centerY = mouseY;
    }
  } 
}

void drawCircleArray(Circle[] circleArray) {
  for (int i = 0; i < circleArray.length; i++) {
    circleArray[i].drawSelf();
  }
}

float percentOfCircle1InCircle2(Circle circle1, Circle circle2) {
  float x1 = circle1.centerX;
  float y1 = circle1.centerY;
  float r1 = circle1.radius;
  float x2 = circle2.centerX;
  float y2 = circle2.centerY;
  float r2 = circle2.radius;
  if (circle1 == circle2) {
    return 1;
  } else if (dist(x1, y1, x2, y2) > (r1 + r2)) { //no As are Bs
    return 0;
  } else if (dist(x1, y1, x2, y2) <= r2-r1) { //all As are Bs
    return 1;
  } else { //some As are Bs
    return 0.5;
  }
}

void resizeSelectedCirclesIn(Circle[] circleArray) {
  for (int i = 0; i < circles.length; i++) {
    if (circleArray[i].radiusSelected == true) {
      float centerX = circleArray[i].centerX;
      float centerY = circleArray[i].centerY;
      float pMouseDistance = dist(pmouseX, pmouseY, centerX, centerY);
      float mouseDistance = dist(mouseX, mouseY, centerX, centerY);
      circleArray[i].radius += (mouseDistance - pMouseDistance);
      circleArray[i].radius = max(circles[i].radius,0);
    }
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



String howMuchOfCircle1IsInCircle2(Circle circle1, Circle circle2) {
  float percent = percentOfCircle1InCircle2(circle1, circle2);
  String relation;
  if (percent == 0) {
    relation = "No";
  } else if (percent == 1) {
    relation = "All";
  } else {
    relation = "Some";
  }
  return relation;
}
class MenuButton {
  String name;
  float xPos, yPos;
  float bWidth, bHeight;
  color bColor = color(0, 0, 100);
  
  MenuButton(String _name, float _xPos, float _yPos, float _bWidth,
             float _bHeight) {
    name = _name;
    xPos = _xPos;
    yPos = _yPos;
    bWidth = _bWidth;
    bHeight = _bHeight;
  }
  
  void drawSelf() {
    noStroke();
    fill(bColor);
    rect(xPos, yPos, bWidth, bHeight, min(bWidth, bHeight) / 5);
    textFont(BaskOldFace);
    textSize(24);
    fill(255);
    textAlign(LEFT);
    text(name, xPos + 5, yPos + 24);
    
  }
}


void processInGameGUIClicks() {
  for (int i=0; i < inGameButtons.length; i++) {
    if ((mouseX < inGameButtons[i].xPos) ||
        (mouseX > inGameButtons[i].xPos + inGameButtons[i].bWidth) ||
        (mouseY < inGameButtons[i].yPos) ||
        (mouseY > inGameButtons[i].yPos + inGameButtons[i].bHeight)) {
      continue;
    } else {
      currentScreen = "Menu";
    }
  }
}

void processMenuGUIClicks() {
  for (int i=0; i < menuButtons.length; i++) {
    if ((mouseX < menuButtons[i].xPos) ||
        (mouseX > menuButtons[i].xPos + menuButtons[i].bWidth) ||
        (mouseY < menuButtons[i].yPos) ||
        (mouseY > menuButtons[i].yPos + menuButtons[i].bHeight)) {
      continue;
    } else {
      currentScreen = "In-Game";
    }
  }
}

void drawInGameGUI () {
  textFont(BaskOldFace);
  textSize(24);
  fill(255);
  float titleYPos = height/10;
  textAlign(CENTER);
  text(test1.name, width / 2, titleYPos);
  textAlign(LEFT);

  listRelationsBetweenCircles(titleYPos);
  listGoals(titleYPos);
  drawTimer();
  for (int i = 0; i < inGameButtons.length; i++) {
    inGameButtons[i].drawSelf();
  }
}
void drawMainMenuGUI () {
  textFont(BaskOldFace);
  textSize(48);
  fill(255);
  float titleYPos = height/10;
  textAlign(CENTER);
  text("Venn Diagram Teacher", width / 2, titleYPos);
  for (int i = 0; i < menuButtons.length; i++) {
    menuButtons[i].drawSelf();
  }
}
void drawGUI() {
  if (currentScreen == "Menu") {
    drawMainMenuGUI();
  } else if (currentScreen == "In-Game") {
    drawInGameGUI();
  }
}

void drawMenu() {
  if (currentScreen == "In-Game") {

  } else if (currentScreen == "Main Menu") {
    
  }
}

void drawTimer() {
  int currentTime = (hour() * 3600) + (minute() * 60) + second();
  int time = currentTime - questionStartTime;
  float timer_height = textAscent() + textDescent();
  text("Timer: " + time, 0, height - timer_height - 5);
}

void listGoals(float titleYPos) {
  textSize(18);
  color old_color = color(255);//save the old color to replace the fill later
  float yPosOfLastText = titleYPos;
  String title = "Question " + currentQuestion.number + " Goals:";
  text(title, width - 300, yPosOfLastText + 30);
  yPosOfLastText += 30;
  for (int i = 0; i < circles.length; i++) {
    for (int j = 0; j < circles.length; j++) {
      if (j == i) {
        continue; //don't compare a circle with itself
      } else {
        String goal_relation = goals[i][j].name;
        String relation = howMuchOfCircle1IsInCircle2(circles[i], circles[j]);
        if (goal_relation == "Some") {
          if ((goal_relation == relation) ||
              (relation == "All")) {
            fill(0, 150, 0);
            goals[i][j].isComplete = true;
          } else {
            fill(150, 0, 0);
            goals[i][j].isComplete = false;
          }
        } else {
          if (goal_relation == relation) {
            fill(0, 150, 0);
            goals[i][j].isComplete = true;
          } else {
            fill(150, 0, 0);
            goals[i][j].isComplete = false;
          }
        }
        String name1 = circles[i].name;
        String name2 = circles[j].name;
        String message = goal_relation + " " + name1 + " are " + name2 + ".";
        float x_offset = textWidth(message) + 5;
        text(message, width - x_offset, yPosOfLastText + 30);
        yPosOfLastText += 30;
      }
    }
  }
  fill(old_color);
}

void listRelationsBetweenCircles(float titleYPos) {
  textSize(18);
  fill(255);
  float yPosOfLastText = titleYPos;
  text("Current situation:", 5, yPosOfLastText + 30);
  yPosOfLastText += 30;
  for (int i = 0; i < circles.length; i++) {
    for (int j = 0; j < circles.length; j++) {
      if (j == i) {
        continue; //don't compare a circle with itself
      } else {
        String message = generateMessageBetween(circles[i], circles[j]);
        text(message, 5, yPosOfLastText + 30);
        yPosOfLastText += 30;
      }
    }
  }
}

String generateMessageBetween(Circle circle1, Circle circle2) {
  String relation = howMuchOfCircle1IsInCircle2(circle1, circle2);
  String name1 = circle1.name;
  String name2 = circle2.name;
  String message = relation + " " + name1 + " are " + name2 + ".";
  return message;
}

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

