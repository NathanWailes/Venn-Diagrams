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
AudioPlayer click;
AudioPlayer question_complete;

void setup() {
  size(1000, 500);
  BaskOldFace = loadFont("BaskOldFace-48.vlw");
  minim = new Minim(this);
  player = minim.loadFile("theme.mp3");
  player.play();
  click = minim.loadFile("click.wav");
  question_complete = minim.loadFile("question_complete.wav");
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
      rotateNameOfSelectedCircleIn(circles);
    }
  }
}

