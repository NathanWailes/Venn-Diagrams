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

